import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';
import 'package:social_media/Controllers/AuthController.dart';
import 'package:social_media/Models/CategoryModel.dart';
import 'package:social_media/Models/CommentModel.dart';
import 'package:social_media/Models/PostModel.dart';
import 'package:social_media/Utils/Api.dart';
import 'package:social_media/Widgets/MyNetworkImage.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostContainer extends StatefulWidget {
  final PostModel post;
  const PostContainer({super.key, required this.post});

  @override
  State<PostContainer> createState() => _PostContainerState();
}

class _PostContainerState extends State<PostContainer> {
  late final PostModel post = widget.post;
  late final AuthController authController = Get.put(AuthController());
  final TextEditingController _commentController = TextEditingController();
  final RxList<CommentModel> _comments = <CommentModel>[].obs;
  final RxBool _isLoading = false.obs;
  bool _showFullContent = false;

  // Add the PageController here
  final PageController _pageController = PageController();
  int _currentPage = 0; // Track the current page

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage =
            _pageController.page?.round() ?? 0; // Update current page index
      });
    });
    print(post.createdAt);
  }

  @override
  void dispose() {
    _commentController.dispose();
    _pageController.dispose(); // Dispose the controller
    super.dispose();
  }

  void _showCommentsBottomSheet(BuildContext context) {
    _fetchComments();
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: _buildCommentsBottomSheet(context),
            ),
          );
        });
  }

  Future<void> _fetchComments() async {
    _isLoading.value = true;
    try {
      final response = await Api.dio.get('/posts/${post.id}/comments');
      if (response.statusCode == 200) {
        final data = (response.data);
        List<CommentModel> comments = (data['data'] as List)
            .map((postJson) => CommentModel.fromJson(postJson))
            .toList();
        _comments.assignAll(comments);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load comments');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> _addComment() async {
    if (_commentController.text.trim().isEmpty) return;
    _isLoading.value = true;
    try {
      final response =
          await Api.dio.post('/posts/${post.id}/comments', queryParameters: {
        'content': _commentController.text.trim(),
      });
      final data = (response.data);
      _comments.insert(0, CommentModel.fromJson(data['data']));
      _commentController.clear();
    } catch (e) {
      Get.snackbar('Error', 'Failed to add comment');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> _handleLike() async {
    try {
      final response = await Api.dio.post('/posts/${post.id}/toggle-like');
      if (response.statusCode == 200) {
        final data = response.data['data'];
        setState(() {
          if (data['liked']) {
            post.likesCount++;
          } else {
            post.likesCount--;
          }
          post.isLiked = data['liked'];
        });
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to toggle like');
    }
  }

  Widget _buildCommentsBottomSheet(BuildContext context) {
    return Obx(() {
      return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          margin: EdgeInsets.all(16),
          height: MediaQuery.of(context).size.height * 0.6,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Comments",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _isLoading.value
                    ? Expanded(
                        child: Center(
                            child: CircularProgressIndicator(
                        color: Theme.of(context).primaryColor,
                      )))
                    : Expanded(
                        child: _comments.isEmpty
                            ? Center(child: Text("No comments yet"))
                            : ListView.separated(
                                itemCount: _comments.length,
                                separatorBuilder: (_, __) => Divider(),
                                itemBuilder: (context, index) {
                                  final comment = _comments[index];
                                  return ListTile(
                                    leading: Container(
                                      width: 48,
                                      height: 48,
                                      padding: EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.black38,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          child: comment.user.profile == null
                                              ? Icon(Icons.person)
                                              : MyNetworkImage(
                                                  url: comment
                                                      .user.profile!.image)),
                                    ),
                                    title: Text(comment.user.username),
                                    subtitle: Text(comment.content),
                                    trailing: Text(
                                      timeago.format(comment.createdAt),
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.black54),
                                    ),
                                  );
                                },
                              ),
                      ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _commentController,
                        decoration: InputDecoration(
                          hintText: "Write a comment...",
                          hintStyle: TextStyle(color: Colors.black38),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: Icon(Icons.send,
                          color: Theme.of(context).primaryColor),
                      onPressed: _addComment,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildImageCarousel() {
    if (post.images == null || post.images!.isEmpty) return SizedBox.shrink();

    return Column(
      children: [
        SizedBox(
          height: 220, // Adjusted height for better proportion
          child: PageView.builder(
            controller: _pageController,
            itemCount: post.images!.length,
            itemBuilder: (context, index) {
              return MyNetworkImage(url: post.images![index].imagePath);
            },
          ),
        ),
        // Add PageViewDotIndicator after PageView
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: PageViewDotIndicator(
            currentItem: _currentPage, // Use the tracked page index
            count: post.images!.length,
            unselectedColor: Colors.grey[300]!,
            selectedColor: Theme.of(context).primaryColor,
            size: Size(20, 8),
            unselectedSize: Size(8, 8),
            borderRadius: BorderRadius.circular(50),
            boxShape: BoxShape.rectangle,
          ),
        ),
      ],
    );
  }

  Widget _buildCategories() {
    if (post.categories != null) {
      if (post.categories!.isNotEmpty) {
        return Wrap(
          spacing: 8.0,
          children: (post.categories as List<CategoryModel>)
              .map((category) => Chip(
                    label: Text(category.name),
                    color: WidgetStatePropertyAll(Colors.white),
                  ))
              .toList(),
        );
      } else {
        return SizedBox.shrink();
      }
    }
    return SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double padding = screenWidth * 0.04; // Dynamic padding based on screen size

    return Container(
      padding: EdgeInsets.all(padding),
      margin: EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(),
        ],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black38,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: post.user.profile == null
                      ? Icon(Icons.person, size: 24)
                      : MyNetworkImage(url: post.user.profile!.image)),
            ),
            title: Text(post.user.fullName.split(' ')[0]),
            subtitle: Text("@${post.user.username}"),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Icon(Icons.more_horiz),
                Text(
                  timeago.format(post.createdAt),
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Display categories
          _buildCategories(),

          const SizedBox(height: 16),
          _buildImageCarousel(),
          const SizedBox(height: 16),
          Text(
            post.title,
            style: TextStyle(
                fontSize: screenWidth < 600 ? 18 : 22,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            _showFullContent ? post.content : post.excerpt,
            style: TextStyle(fontSize: screenWidth < 600 ? 16 : 18),
          ),
          _showFullContent
              ? SizedBox.shrink()
              : TextButton(
                  onPressed: () {
                    setState(() {
                      _showFullContent = true;
                    });
                  },
                  child: Text("Read more",
                      style: TextStyle(color: Theme.of(context).primaryColor)),
                ),
          const SizedBox(height: 24),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _showCommentsBottomSheet(context);
                  },
                  style: ButtonStyle(
                      padding: WidgetStatePropertyAll(EdgeInsets.all(0)),
                      backgroundColor:
                          WidgetStatePropertyAll(Colors.transparent),
                      shadowColor: WidgetStatePropertyAll(Colors.transparent)),
                  child: Row(
                    children: [
                      Icon(
                        Icons.comment,
                        color: Theme.of(context).dividerColor,
                        size: 18.0,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Comments",
                        style: TextStyle(
                            color: Theme.of(context).dividerColor,
                            fontSize: 14),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: _handleLike,
                  style: ButtonStyle(
                      padding: WidgetStatePropertyAll(EdgeInsets.all(0)),
                      backgroundColor:
                          WidgetStatePropertyAll(Colors.transparent),
                      shadowColor: WidgetStatePropertyAll(Colors.transparent)),
                  child: Row(
                    children: [
                      Icon(
                        post.isLiked ? Icons.favorite : Icons.favorite_border,
                        color: post.isLiked
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).dividerColor,
                        size: 18.0,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "${post.likesCount}",
                        style: TextStyle(
                            color: post.isLiked
                                ? Theme.of(context).primaryColor
                                : Theme.of(context).dividerColor,
                            fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
