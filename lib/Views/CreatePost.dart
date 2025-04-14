import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media/Models/CategoryModel.dart';
import 'package:social_media/Utils/Api.dart';
import 'package:social_media/Widgets/MyAppBar.dart';
import 'package:social_media/Widgets/MyBottomNavigationBar.dart';
import 'package:social_media/Widgets/MyFloatingActionButton.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final List<CategoryModel> _categories = <CategoryModel>[];
  final List<CategoryModel> _selectedCategories = [];
  final List<XFile> _images = [];
  var isLoadingCategories = false.obs;
  var isLoading = false.obs;
  var fieldErrors = <String, String>{}.obs;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    if (isLoadingCategories.value) return;

    isLoadingCategories.value = true;
    try {
      final response = await Api.dio.get('/categories');
      if (response.statusCode == 200) {
        List<CategoryModel> categories = (response.data['data'] as List)
            .map((postJson) => CategoryModel.fromJson(postJson))
            .toList();

        setState(() {
          _categories.addAll(categories);
        });
      }
    } on dio.DioException catch (e) {
      print('Error fetching categories: $e');
    } finally {
      isLoadingCategories.value = false;
    }
  }

  // Update the method to use ImagePicker and add multiple images
  Future<void> _addImage() async {
    final picker = ImagePicker();
    final List<XFile>? pickedImages = await picker.pickMultiImage();
    if (pickedImages != null) {
      setState(() {
        print(pickedImages[0].path);
        _images.addAll(pickedImages);
      });
    }
  }

  Future<void> _createPost() async {
    if (isLoading.value) return;
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
    }

    fieldErrors.clear();
    isLoading.value = true;

    try {
      print(_selectedCategories[0].id);
      dio.FormData formData = dio.FormData.fromMap({
        'title': _titleController.text.trim(),
        'content': _contentController.text.trim(),
        // Add selected images as MultipartFile
        'images[]': await Future.wait(_images.map((image) async {
          return await dio.MultipartFile.fromFile(image.path,
              filename: image.name);
        })),
        'categories[]': (_selectedCategories.map((category) {
          return category.id;
        }).toList()),
      });
      final response = await Api.dio.post('/posts',
          data: formData,
          options: dio.Options(
            headers: {
              'Content-Type': 'multipart/form-data',
            },
          ));

      if (response.statusCode == 200) {
        Get.snackbar('Success', response.data['message']);
        Future.delayed(Duration(seconds: 3));
        Get.toNamed('/profile');
      }
    } on dio.DioException catch (e) {
      if (e.response?.statusCode == 422) {
        final errors = e.response?.data['errors'] as Map<String, dynamic>;
        errors.forEach((key, value) {
          fieldErrors[key] = value[0]; // Store the first error message
        });
      } else {
        fieldErrors['general'] =
            e.response?.data['message'] ?? 'An error occurred';
      }
    } finally {
      isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: MyAppBar(),
      floatingActionButton: MyFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: MyBottomNavigationBar(),
      body: Obx(() {
        return SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Post Title',
                  style: TextStyle(
                      color: Colors.grey.shade700, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.0),
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    hintText: 'Enter post title',
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor),
                    ),
                    errorText: fieldErrors['title'],
                  ),
                  maxLength: 191,
                  validator: (value) {
                    if (value == '' || value == null) {
                      return "Field is required.";
                    }
                    if (value.length >= 191) {
                      return "Title should not exceed 191 characters.";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),

                // Description Input
                Text(
                  'Post Description',
                  style: TextStyle(
                      color: Colors.grey.shade700, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.0),
                TextFormField(
                  controller: _contentController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'Enter post content',
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor),
                    ),
                    errorText: fieldErrors['content'],
                  ),
                  maxLength: 191,
                  validator: (value) {
                    if (value == '' || value == null) {
                      return "Field is required.";
                    }
                    if (value.length >= 191) {
                      return "Title should not exceed 191 characters.";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),

                // Images Section
                Text(
                  'Add Images (Optional)',
                  style: TextStyle(
                      color: Colors.grey.shade700, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.0),
                Wrap(
                  spacing: 8.0,
                  children: _images
                      .map((
                        image,
                      ) =>
                          Stack(
                            children: [
                              Container(
                                  width: 48,
                                  height: 48,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.file(File(image.path)),
                                  )),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _images.remove(image);
                                    });
                                  },
                                  child: Icon(Icons.close, color: Colors.red),
                                ),
                              ),
                            ],
                          ))
                      .toList(),
                ),
                SizedBox(height: 8.0),
                IconButton(
                  color: Colors.white,
                  icon: Icon(
                    Icons.image,
                  ),
                  onPressed: _addImage,
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStatePropertyAll(Theme.of(context).primaryColor),
                  ),
                ),
                SizedBox(height: 16.0),

                // Categories Section
                Text(
                  'Select Categories (Optional)',
                  style: TextStyle(
                      color: Colors.grey.shade700, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.0),
                isLoadingCategories.value
                    ? CircularProgressIndicator(
                        color: Theme.of(context).primaryColor,
                      )
                    : Wrap(
                        spacing: 8.0,
                        children: _categories.map((category) {
                          final isSelected =
                              _selectedCategories.contains(category);
                          return FilterChip(
                            label: Text(category.name),
                            selected: isSelected,
                            backgroundColor: Colors.white,
                            selectedColor:
                                Theme.of(context).primaryColor.withOpacity(0.2),
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  _selectedCategories.add(category);
                                } else {
                                  _selectedCategories.remove(category);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                SizedBox(height: 16.0),

                // Submit Button
                Container(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      _createPost();
                    },
                    child: Text('Create Post'),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
