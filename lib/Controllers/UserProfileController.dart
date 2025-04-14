import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart%20';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media/Controllers/AuthController.dart';
import 'package:social_media/Models/UserModel.dart';
import 'package:social_media/Utils/Api.dart';

class UserProfileController extends GetxController {
  late final AuthController authController = Get.find<AuthController>();

  var isLoading = false.obs;
  var fieldErrors = <String, String>{}.obs;

  late final TextEditingController bioController =
      TextEditingController(text: authController.user?.profile?.bio);
  XFile? image; // To hold the selected image

  final ImagePicker picker = ImagePicker();

  Future<bool> saveUserProfile() async {
    fieldErrors.clear();
    try {
      if (image == null) {
        Get.snackbar('Error', 'Please select an image.');
        return false;
      }
      print('image path ${image!.path}');

      final form = dio.FormData.fromMap({
        'bio': bioController.value.text.trim(),
        'image': await dio.MultipartFile.fromFile(
          image!.path,
          filename: image!.path.split('/').last,
        ),
      });

      print(form.files);

      final response = await Api.dio.post(
        '/user-profile',
        data: form,
      );

      print('data after saving ${response.data}');
      if (response.statusCode == 200) {
        final data = (response.data['data']);
        authController.user = UserModel.fromJson(data);
        return true; // Success
      }

      return false; // General error
    } on DioException catch (e) {
      if (e.response?.statusCode == 422) {
        final errors = e.response?.data['errors'] as Map<String, dynamic>;
        errors.forEach((key, value) {
          fieldErrors[key] = value[0]; // Store the first error message
        });
      } else {
        fieldErrors['general'] =
            e.response?.data['message'] ?? 'An error occurred';
      }
      return false;
    }
  }
}
