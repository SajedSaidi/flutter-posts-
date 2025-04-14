class PostImageModel {
  final int id;
  final String imagePath;
  final int postId;

  PostImageModel(
      {required this.id, required this.imagePath, required this.postId});

  factory PostImageModel.fromJson(Map<String, dynamic> json) => PostImageModel(
        id: json['id'] as int,
        imagePath: json['imagePath'] as String,
        postId: json['postId'] as int,
      );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imagePath': imagePath,
      'postId': postId,
    };
  }
}
