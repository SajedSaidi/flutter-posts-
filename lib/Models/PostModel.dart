import 'package:social_media/Models/CategoryModel.dart';
import 'package:social_media/Models/PostImageModel.dart';
import 'package:social_media/Models/UserModel.dart';

class PostModel {
  final int id;
  final String title;
  final String slug;
  final String content;
  final String excerpt;
  final String status;
  final int userId;
  final List<PostImageModel>? images;
  final List<CategoryModel>? categories;
  int likesCount;
  bool isLiked;
  final DateTime createdAt;
  final DateTime updatedAt;
  final UserModel user;

  PostModel({
    required this.id,
    required this.title,
    required this.slug,
    required this.content,
    required this.excerpt,
    required this.status,
    required this.userId,
    required this.images,
    this.categories,
    required this.likesCount,
    required this.isLiked,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      slug: json['slug'] ?? '',
      content: json['content'] ?? '',
      excerpt: json['excerpt'] ?? '',
      status: json['status'] ?? '',
      userId: json['userId'] ?? 0,
      categories: (json['categories'] as List<dynamic>?)
              ?.map((category) => CategoryModel.fromJson(category))
              .toList() ??
          [],
      images: (json['images'] as List<dynamic>?)
              ?.map((image) => PostImageModel.fromJson(image))
              .toList() ??
          [],
      likesCount: json['likesCount'] ?? 0,
      isLiked: json['isLiked'] ?? false,
      createdAt: DateTime.parse(json['createdAt'] ?? '2000-01-01T00:00:00Z'),
      updatedAt: DateTime.parse(json['updatedAt'] ?? '2000-01-01T00:00:00Z'),
      user: UserModel.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'slug': slug,
      'content': content,
      'excerpt': excerpt,
      'status': status,
      'userId': userId,
      'images': images?.map((image) => image.toJson()).toList(),
      'categories': categories?.map((category) => category.toJson()).toList(),
      'likesCount': likesCount,
      'isLiked': isLiked,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'user': user.toJson(),
    };
  }
}

class PaginationModel {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  PaginationModel({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
      currentPage: json['current_page'],
      lastPage: json['last_page'],
      perPage: json['per_page'],
      total: json['total'],
    );
  }
}
