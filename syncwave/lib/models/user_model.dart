class UserModel {
  final String id;
  final String name;
  final String? avatarUrl;
  final bool isHost;
  final String status; // 'listening', 'paused', 'offline'

  const UserModel({
    required this.id,
    required this.name,
    this.avatarUrl,
    this.isHost = false,
    this.status = 'listening',
  });
}

// Dummy users for UI
final class DummyUsers {
  static const UserModel currentUser = UserModel(
    id: 'me',
    name: 'Neil',
    avatarUrl: 'https://picsum.photos/seed/neil/100',
    isHost: false,
  );

  static const UserModel host = UserModel(
    id: 'host1',
    name: 'Elena Rostova',
    avatarUrl: 'https://picsum.photos/seed/elena/100',
    isHost: true,
    status: 'listening',
  );

  static const List<UserModel> listeners = [
    UserModel(
      id: 'u1',
      name: 'Marcus Thorne',
      avatarUrl: 'https://picsum.photos/seed/marcus/100',
      status: 'listening',
    ),
    UserModel(
      id: 'u2',
      name: 'Sophia Lin',
      avatarUrl: 'https://picsum.photos/seed/sophia/100',
      status: 'paused',
    ),
    UserModel(
      id: 'u3',
      name: 'Javier Costa',
      avatarUrl: null,
      status: 'listening',
    ),
    UserModel(
      id: 'u4',
      name: 'Diane Evans',
      avatarUrl: 'https://picsum.photos/seed/diane/100',
      status: 'offline',
    ),
  ];

  static const List<UserModel> recentRooms = [
    UserModel(id: 'r1', name: 'Sarah', status: 'listening'),
    UserModel(id: 'r2', name: 'Alex', status: 'listening'),
  ];
}
