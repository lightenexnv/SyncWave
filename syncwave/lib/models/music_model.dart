class MusicModel {
  final String title;
  final String artist;
  final String fileName;
  final String musicLink;
  final dynamic uploadedAt;

  MusicModel({
    required this.title,
    required this.artist,
    required this.fileName,
    required this.musicLink,
    required this.uploadedAt,
  });

  factory MusicModel.fromJson(Map<dynamic, dynamic> json) {
    return MusicModel(
      title: json['title'] ?? '',
      artist: json['artist'] ?? 'Unknown Artist',
      fileName: json['fileName'] ?? '',
      musicLink: json['musicLink'] ?? '',
      uploadedAt: json['uploadedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'artist': artist,
      'fileName': fileName,
      'musicLink': musicLink,
      'uploadedAt': uploadedAt,
    };
  }

  MusicModel copyWith({
    String? title,
    String? artist,
    String? fileName,
    String? musicLink,
    dynamic uploadedAt,
  }) {
    return MusicModel(
      title: title ?? this.title,
      artist: artist ?? this.artist,
      fileName: fileName ?? this.fileName,
      musicLink: musicLink ?? this.musicLink,
      uploadedAt: uploadedAt ?? this.uploadedAt,
    );
  }
}
