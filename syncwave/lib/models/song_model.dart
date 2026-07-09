class SongModel {
  final String id;
  final String title;
  final String artist;
  final String albumArtUrl;
  final Duration duration;
  final String? genre;

  const SongModel({
    required this.id,
    required this.title,
    required this.artist,
    required this.albumArtUrl,
    required this.duration,
    this.genre,
  });
}

// Dummy data for UI
final class DummySongs {
  static const List<SongModel> queue = [
    SongModel(
      id: '1',
      title: 'Midnight City',
      artist: 'M83',
      albumArtUrl: 'https://picsum.photos/seed/midnight/200',
      duration: Duration(minutes: 4, seconds: 3),
    ),
    SongModel(
      id: '2',
      title: 'Echoes of the City',
      artist: 'Neon Horizon',
      albumArtUrl: 'https://picsum.photos/seed/echoes/200',
      duration: Duration(minutes: 3, seconds: 47),
    ),
    SongModel(
      id: '3',
      title: 'Velvet Morning',
      artist: 'Ambient Soundscapes',
      albumArtUrl: 'https://picsum.photos/seed/velvet/200',
      duration: Duration(minutes: 5, seconds: 12),
    ),
    SongModel(
      id: '4',
      title: 'Concrete Jungle',
      artist: 'The Architects',
      albumArtUrl: 'https://picsum.photos/seed/concrete/200',
      duration: Duration(minutes: 3, seconds: 58),
    ),
    SongModel(
      id: '5',
      title: 'Digital Dawn',
      artist: 'System Overload',
      albumArtUrl: 'https://picsum.photos/seed/digital/200',
      duration: Duration(minutes: 4, seconds: 21),
    ),
  ];

  static const SongModel nowPlaying = SongModel(
    id: '0',
    title: 'Midnight City',
    artist: 'M83',
    albumArtUrl: 'https://picsum.photos/seed/midnight/400',
    duration: Duration(minutes: 4, seconds: 3),
  );

  static const List<SongModel> recentTracks = [
    SongModel(
      id: '6',
      title: 'Neon Genesis',
      artist: 'Kavinsky',
      albumArtUrl: 'https://picsum.photos/seed/neon/200',
      duration: Duration(minutes: 3, seconds: 30),
      genre: 'Electronic',
    ),
    SongModel(
      id: '7',
      title: 'Pacific Coast Highway',
      artist: 'Nightcraft',
      albumArtUrl: 'https://picsum.photos/seed/pacific/200',
      duration: Duration(minutes: 4, seconds: 15),
      genre: 'Ambient',
    ),
    SongModel(
      id: '8',
      title: 'Subtle Shift',
      artist: 'Unknown Artist',
      albumArtUrl: 'https://picsum.photos/seed/subtle/200',
      duration: Duration(minutes: 2, seconds: 55),
      genre: 'Beat',
    ),
  ];
}
