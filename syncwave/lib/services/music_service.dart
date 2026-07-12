import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/music_model.dart';
import 'cloudinary_service.dart';
import 'database_service.dart';
import '../utils/snackbarPopup.dart';

class MusicService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CloudinaryService _cloudinaryService = CloudinaryService();
  final DatabaseService _databaseService = DatabaseService();

  Future<void> uploadMusic() async {
    try {
      print("START");
      
      User? user = _auth.currentUser;
      if (user == null) {
        print("ERROR: No authenticated user");
        SnackbarUtils.show("Upload Failed", "No user logged in");
        return;
      }
      
      print("USER FOUND");
      print("User detected: ${user.uid}");

      // Pick music file
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
      );

      if (result == null) {
        print("ERROR: Cancelled picker");
        SnackbarUtils.show("Selection Cancelled", "No file was selected");
        return;
      }

      print("FILE PICKED");
      print("File selected");

      String? path = result.files.single.path;
      if (path == null) {
        print("ERROR: Invalid file path");
        SnackbarUtils.show("Upload Failed", "Invalid file path");
        return;
      }

      File musicFile = File(path);
      String originalName = result.files.single.name;
      String fileExtension = originalName.split('.').last.toLowerCase();

      // Check allowed formats: MP3, WAV, FLAC, M4A
      List<String> allowedFormats = ['mp3', 'wav', 'flac', 'm4a'];
      if (!allowedFormats.contains(fileExtension)) {
        print("ERROR: Invalid file format: $fileExtension");
        SnackbarUtils.show("Invalid File", "Only MP3, WAV, FLAC, and M4A files are allowed");
        return;
      }

      String fileName = "${DateTime.now().millisecondsSinceEpoch}_$originalName";

      print("UPLOAD STARTED");
      print("Cloudinary upload started");
      
      String? musicUrl = await _cloudinaryService.uploadAudio(musicFile.path, user.uid);

      if (musicUrl == null) {
        print("ERROR: Cloudinary upload failure");
        SnackbarUtils.show("Upload Failed", "Cloudinary upload failed");
        return;
      }

      print("UPLOAD SUCCESS");
      print("Upload successful");
      print("URL RECEIVED");
      print("Cloudinary URL received: $musicUrl");

      print("DATABASE WRITE");
      print("Database write started");

      String artistName = "Unknown Artist";
      final userProfileSnapshot = await FirebaseDatabase.instance
          .ref("syncwave_database")
          .child("users")
          .child(user.uid)
          .child("profile")
          .get();
      if (userProfileSnapshot.exists && userProfileSnapshot.value is Map) {
        final profileData = userProfileSnapshot.value as Map;
        artistName = profileData['name'] ?? user.displayName ?? "Unknown Artist";
      } else {
        artistName = user.displayName ?? user.email?.split('@').first ?? "Unknown Artist";
      }

      final music = MusicModel(
        title: originalName,
        artist: artistName,
        fileName: fileName,
        musicLink: musicUrl,
        uploadedAt: ServerValue.timestamp,
      );

      await _databaseService.saveMusic(user.uid, music);

      print("DATABASE SUCCESS");
      print("Database write successful");
      SnackbarUtils.show("Success", "Music Uploaded Successfully");
    } catch (e, stackTrace) {
      print("ERROR: $e");
      print(stackTrace);
      SnackbarUtils.show("Upload Failed", "An unexpected error occurred: $e");
    }
  }

  Stream<DatabaseEvent> getMyMusic() {
    User? user = _auth.currentUser;
    if (user == null) {
      print("ERROR: getMyMusic - No authenticated user");
      return FirebaseDatabase.instance.ref("empty_ref").onValue;
    }
    return _databaseService.getMyMusicsStream(user.uid);
  }
}