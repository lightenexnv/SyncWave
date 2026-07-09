class UserModel {
  final String name;
  final String avatarUrl;
  final bool isHost;

  const UserModel({
    required this.name,
    required this.avatarUrl,
    this.isHost = false,
  });

  // TODO: Connect Firebase user data here
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] as String,
      avatarUrl: map['avatarUrl'] as String,
      isHost: (map['isHost'] as bool?) ?? false,
    );
  }
}
