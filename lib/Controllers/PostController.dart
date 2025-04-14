import 'package:get/get.dart';
import 'package:social_media/Models/PostModel.dart';
import 'package:social_media/Models/UserModel.dart';

import 'package:social_media/Utils/Api.dart';

class PostController extends GetxController {
  List<PostModel> posts = <PostModel>[].obs;
  RxBool isLoading = false.obs;
  RxBool hasMore = true.obs;
  int currentPage = 1;
  int lastPage = 1;

  Future<void> fetchPosts({bool isRefresh = false, UserModel? user}) async {
    if (isLoading.value) return;

    if (isRefresh) {
      currentPage = 1;
      hasMore.value = true;
      posts.clear();
    }

    isLoading.value = true;

    try {
      print(user);
      final response = (user == null)
          ? await Api.dio.get("/posts", queryParameters: {'page': currentPage})
          : await Api.dio.get('/user-posts',
              queryParameters: {'page': currentPage, 'user_id': user.id});

      if (response.statusCode == 200) {
        final data = (response.data);

        if (data['status'] == 'success') {
          List<PostModel> newPosts = (data['data']['posts'] as List)
              .map((postJson) => PostModel.fromJson(postJson))
              .toList();

          PaginationModel pagination =
              PaginationModel.fromJson(data['data']['pagination']);

          if (currentPage == pagination.lastPage) {
            hasMore.value = false;
          }

          posts.addAll(newPosts);
          currentPage++;
        } else {
          throw Exception('Failed to load posts: ${data['message']}');
        }
      } else {
        throw Exception('Failed to load posts');
      }
    } catch (e) {
      print('Error fetching posts: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
