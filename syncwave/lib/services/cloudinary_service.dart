import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class CloudinaryService {
  final String cloudName = "defl5v5uk";
  final String uploadPreset = "CodeBid";

  Future<String?> uploadAudio(String filePath, String userId) async {
    print("START");
    print("UPLOAD STARTED");
    print("Cloudinary upload started");
    try {
      final file = File(filePath);
      final url = Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/video/upload");
      var request = http.MultipartRequest('POST', url);
      
      request.fields["upload_preset"] = uploadPreset;
      request.fields["folder"] = "syncwave/$userId";
      
      request.files.add(
        await http.MultipartFile.fromPath('file', file.path),
      );

      var response = await request.send();
      var res = await http.Response.fromStream(response);

      if (response.statusCode != 200 && response.statusCode != 201) {
        print("ERROR: Cloudinary upload failed with status ${response.statusCode}");
        throw Exception("Cloudinary upload failed: ${res.body}");
      }

      final data = jsonDecode(res.body);
      String? musicUrl = data["secure_url"];

      if (musicUrl == null) {
        print("ERROR: Cloudinary secure_url is null");
        throw Exception("Cloudinary secure_url is null: ${res.body}");
      }

      print("UPLOAD SUCCESS");
      print("Upload successful");
      print("URL RECEIVED");
      print("Cloudinary URL received: $musicUrl");
      return musicUrl;
    } catch (e, stackTrace) {
      print("ERROR: $e");
      print(stackTrace);
      rethrow;
    }
  }
}
