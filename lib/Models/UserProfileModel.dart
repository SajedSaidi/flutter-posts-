class UserProfileModel {
  final int id;
  final String bio;
  String? image;

  UserProfileModel({required this.id, required this.bio, required this.image});

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'],
      bio: json['bio'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bio': bio,
      'image': image,
    };
  }

  @override
  String toString() {
    // TODO: implement toString
    return "Bio: ${bio}, Image: ${image} ";
  }
}
