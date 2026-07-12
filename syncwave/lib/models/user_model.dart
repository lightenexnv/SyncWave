class UserModel {
  final String uid;
  final String name;
  final String email;
  final String? avatarUrl;
  final bool isHost;
  final String status; // 'listening', 'paused', 'offline'

  const UserModel({
    String? uid,
    String? id,
    required this.name,
    this.email = '',
    this.avatarUrl,
    this.isHost = false,
    this.status = 'listening',
  }) : uid = uid ?? id ?? '';

  String get id => uid;

  factory UserModel.fromJson(Map<dynamic, dynamic> json) {
    return UserModel(
      uid: json['uid'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      avatarUrl: json['avatarUrl'] ?? json['profileImage'],
      isHost: json['isHost'] == true,
      status: json['status'] ?? 'listening',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'avatarUrl': avatarUrl,
      'isHost': isHost,
      'status': status,
    };
  }

  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? avatarUrl,
    bool? isHost,
    String? status,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isHost: isHost ?? this.isHost,
      status: status ?? this.status,
    );
  }
}

// Dummy users for UI
final class DummyUsers {
  static const UserModel currentUser = UserModel(
    uid: 'me',
    name: 'Neil',
    email: 'neil@example.com',
    avatarUrl: 'https://picsum.photos/seed/neil/100',
    isHost: false,
  );

  static const UserModel host = UserModel(
    uid: 'host1',
    name: 'Elena Rostova',
    email: 'elena@example.com',
    avatarUrl: 'https://picsum.photos/seed/elena/100',
    isHost: true,
    status: 'listening',
  );

  static const List<UserModel> listeners = [
    UserModel(
      uid: 'u1',
      name: 'Marcus Thorne',
      email: 'marcus@example.com',
      avatarUrl: 'https://picsum.photos/seed/marcus/100',
      status: 'listening',
    ),
    UserModel(
      uid: 'u2',
      name: 'Sophia Lin',
      email: 'sophia@example.com',
      avatarUrl: 'https://picsum.photos/seed/sophia/100',
      status: 'paused',
    ),
    UserModel(
      uid: 'u3',
      name: 'Javier Costa',
      email: 'javier@example.com',
      avatarUrl: null,
      status: 'listening',
    ),
    UserModel(
      uid: 'u4',
      name: 'Diane Evans',
      email: 'diane@example.com',
      avatarUrl: 'https://picsum.photos/seed/diane/100',
      status: 'offline',
    ),
  ];

  static const List<UserModel> recentRooms = [
    UserModel(uid: 'r1', name: 'Sarah', email: 'sarah@example.com', status: 'listening'),
    UserModel(uid: 'r2', name: 'Alex', email: 'alex@example.com', status: 'listening'),
  ];
}
