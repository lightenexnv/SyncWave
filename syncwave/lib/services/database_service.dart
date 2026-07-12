import 'package:firebase_database/firebase_database.dart';
import '../models/user_model.dart';
import '../models/music_model.dart';

class DatabaseService {
  final FirebaseDatabase _db = FirebaseDatabase.instance;

  String _sanitizeKey(String key) {
    return key.replaceAll(RegExp(r'[.$#\[\]/]'), '_');
  }

  Future<void> saveUserProfile(UserModel user) async {
    print("DATABASE WRITE");
    print("Database write started");
    try {
      final ref = _db
          .ref("syncwave_database")
          .child("users")
          .child(user.uid)
          .child("profile");
      await ref.set(user.toJson());
      print("DATABASE SUCCESS");
      print("Database write successful");
    } catch (e, stackTrace) {
      print("ERROR: $e");
      print(stackTrace);
      rethrow;
    }
  }

  Future<void> saveMusic(String userId, MusicModel music) async {
    print("DATABASE WRITE");
    print("Database write started");
    try {
      final musicKey = _sanitizeKey(music.title);
      final ref = _db
          .ref("syncwave_database")
          .child("users")
          .child(userId)
          .child("my_Musics")
          .child(musicKey);
      await ref.set(music.toJson());
      print("DATABASE SUCCESS");
      print("Database write successful");
    } catch (e, stackTrace) {
      print("ERROR: $e");
      print(stackTrace);
      rethrow;
    }
  }

  Stream<DatabaseEvent> getMyMusicsStream(String userId) {
    print("Realtime update received");
    return _db
        .ref("syncwave_database")
        .child("users")
        .child(userId)
        .child("my_Musics")
        .onValue;
  }

  Stream<DatabaseEvent> getUserProfileStream(String userId) {
    return _db
        .ref("syncwave_database")
        .child("users")
        .child(userId)
        .child("profile")
        .onValue;
  }
}
