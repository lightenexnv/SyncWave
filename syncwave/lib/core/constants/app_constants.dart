abstract final class AppConstants {
  static const String appName = 'SyncWave';
  static const String tagline = 'Music feels better together';

  // Spacing scale (4px base unit)
  static const double spaceXS = 4.0;
  static const double spaceSM = 8.0;
  static const double spaceMD = 16.0;
  static const double spaceLG = 24.0;
  static const double spaceXL = 32.0;
  static const double spaceXXL = 48.0;

  // Border radius
  static const double radiusSM = 12.0;
  static const double radiusMD = 16.0;
  static const double radiusLG = 24.0;
  static const double radiusXL = 32.0;
  static const double radiusFull = 999.0;

  // Dummy room code shown on Create Room screen
  static const String dummyRoomCode = '482931';

  // Dummy songs list
  static const List<Map<String, String>> dummySongs = [
    {
      'title': 'Blinding Lights',
      'artist': 'The Weeknd',
      'duration': '3:22',
      'imageId': '10',
    },
    {
      'title': 'As It Was',
      'artist': 'Harry Styles',
      'duration': '2:37',
      'imageId': '20',
    },
    {
      'title': 'Anti-Hero',
      'artist': 'Taylor Swift',
      'duration': '3:20',
      'imageId': '30',
    },
    {
      'title': 'Flowers',
      'artist': 'Miley Cyrus',
      'duration': '3:21',
      'imageId': '40',
    },
    {
      'title': 'Unholy',
      'artist': 'Sam Smith',
      'duration': '2:36',
      'imageId': '50',
    },
    {
      'title': 'Calm Down',
      'artist': 'Rema & Selena Gomez',
      'duration': '3:59',
      'imageId': '60',
    },
    {
      'title': 'Rich Flex',
      'artist': 'Drake & 21 Savage',
      'duration': '3:57',
      'imageId': '70',
    },
  ];

  // Dummy members list
  static const List<Map<String, dynamic>> dummyMembers = [
    {'name': 'Alex Rivera', 'isHost': true, 'imageId': '11'},
    {'name': 'Jordan Lee', 'isHost': false, 'imageId': '22'},
    {'name': 'Sam Chen', 'isHost': false, 'imageId': '33'},
    {'name': 'Taylor Park', 'isHost': false, 'imageId': '44'},
    {'name': 'Morgan Kim', 'isHost': false, 'imageId': '55'},
  ];

  // Dummy recent rooms
  static const List<Map<String, dynamic>> dummyRooms = [
    {
      'name': 'Chill Vibes 🌙',
      'host': 'Alex Rivera',
      'members': 4,
      'genre': 'Lo-Fi',
      'imageId': '80',
    },
    {
      'name': 'Friday Night 🔥',
      'host': 'Jordan Lee',
      'members': 7,
      'genre': 'Hip-Hop',
      'imageId': '90',
    },
    {
      'name': 'Study Session 📚',
      'host': 'Sam Chen',
      'members': 3,
      'genre': 'Ambient',
      'imageId': '100',
    },
  ];
}
