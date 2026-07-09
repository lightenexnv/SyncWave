class SongModel {
  final String title;
  final String artist;
  final String albumArtUrl;
  final String duration;

  const SongModel({
    required this.title,
    required this.artist,
    required this.albumArtUrl,
    required this.duration,
  });

  // TODO: Connect Firebase / API deserialization here
  factory SongModel.fromMap(Map<String, dynamic> map) {
    return SongModel(
      title: map['title'] as String,
      artist: map['artist'] as String,
      albumArtUrl: map['albumArtUrl'] as String,
      duration: map['duration'] as String,
    );
  }
}
