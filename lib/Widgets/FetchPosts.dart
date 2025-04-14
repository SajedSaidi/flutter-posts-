import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media/Controllers/PostController.dart';
import 'package:social_media/Models/UserModel.dart';
import 'package:social_media/Widgets/PostContainer.dart';

class FetchPosts extends StatefulWidget {
  final UserModel? user;
  const FetchPosts({super.key, this.user});

  @override
  State<FetchPosts> createState() => _FetchPostsState();
}

class _FetchPostsState extends State<FetchPosts> {
  late final UserModel? user = widget.user;
  final PostController postController = PostController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      postController.fetchPosts(user: user);
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        postController.fetchPosts(user: user);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double horizontalPadding = screenWidth * 0.05; // 5% of screen width

    return Obx(() {
      if (postController.isLoading.value && postController.posts.isEmpty) {
        return Center(
            child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor));
      }

      return RefreshIndicator(
        color: Theme.of(context).primaryColor,
        triggerMode: RefreshIndicatorTriggerMode.onEdge,
        onRefresh: () async {
          await postController.fetchPosts(isRefresh: true, user: user);
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Column(
            children: [
              const SizedBox(height: 12),
              postController.posts.isEmpty
                  ? Expanded(
                      child: Center(
                        child: Text(
                          "No posts found.",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        scrollDirection: Axis.vertical,
                        itemCount: postController.posts.length +
                            (postController.hasMore.value &&
                                    postController.isLoading.value
                                ? 1
                                : 0),
                        itemBuilder: (context, index) {
                          if (index < postController.posts.length) {
                            return PostContainer(
                                post: postController.posts[index]);
                          } else {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                  child: CircularProgressIndicator(
                                      color: Theme.of(context).primaryColor)),
                            );
                          }
                        },
                      ),
                    ),
            ],
          ),
        ),
      );
    });
  }
}
