import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../models/music_model.dart';

class PlaybackService extends ChangeNotifier {
  static final PlaybackService _instance = PlaybackService._internal();
  factory PlaybackService() => _instance;

  PlaybackService._internal() {
    _player.positionStream.listen((pos) {
      position.value = pos;
    });
    _player.durationStream.listen((dur) {
      duration.value = dur ?? Duration.zero;
    });
    _player.playerStateStream.listen((state) {
      isPlaying.value = state.playing;
      if (state.processingState == ProcessingState.completed) {
        playNext();
      }
    });
  }

  final AudioPlayer _player = AudioPlayer();

  final ValueNotifier<MusicModel?> currentSong = ValueNotifier<MusicModel?>(null);
  final ValueNotifier<bool> isPlaying = ValueNotifier<bool>(false);
  final ValueNotifier<Duration> position = ValueNotifier<Duration>(Duration.zero);
  final ValueNotifier<Duration> duration = ValueNotifier<Duration>(Duration.zero);
  final ValueNotifier<List<MusicModel>> queue = ValueNotifier<List<MusicModel>>([]);
  final ValueNotifier<int> currentIndex = ValueNotifier<int>(-1);
  final ValueNotifier<bool> isMinimized = ValueNotifier<bool>(true);
  final ValueNotifier<bool> isVisible = ValueNotifier<bool>(false);
  final ValueNotifier<double> volume = ValueNotifier<double>(1.0);

  Future<void> playSong(MusicModel song, List<MusicModel> currentQueue) async {
    try {
      currentSong.value = song;
      queue.value = currentQueue;
      currentIndex.value = currentQueue.indexOf(song);
      isVisible.value = true;
      isMinimized.value = false; // Expands when a song starts playing

      await _player.setUrl(song.musicLink);
      _player.play();
    } catch (e) {
      debugPrint("Error playing song: $e");
    }
  }

  void togglePlay() {
    if (isPlaying.value) {
      _player.pause();
    } else {
      _player.play();
    }
  }

  void seek(Duration pos) {
    _player.seek(pos);
  }

  void skipForward() {
    final newPos = position.value + const Duration(seconds: 10);
    if (newPos < duration.value) {
      seek(newPos);
    } else {
      seek(duration.value);
    }
  }

  void skipBackward() {
    final newPos = position.value - const Duration(seconds: 10);
    if (newPos > Duration.zero) {
      seek(newPos);
    } else {
      seek(Duration.zero);
    }
  }

  void playNext() {
    if (queue.value.isEmpty || currentIndex.value == -1) return;
    int nextIdx = currentIndex.value + 1;
    if (nextIdx < queue.value.length) {
      playSong(queue.value[nextIdx], queue.value);
    } else {
      // Loop back to start
      playSong(queue.value[0], queue.value);
    }
  }

  void playPrevious() {
    if (queue.value.isEmpty || currentIndex.value == -1) return;
    int prevIdx = currentIndex.value - 1;
    if (prevIdx >= 0) {
      playSong(queue.value[prevIdx], queue.value);
    } else {
      // Loop to end
      playSong(queue.value[queue.value.length - 1], queue.value);
    }
  }

  void setVolume(double val) {
    volume.value = val;
    _player.setVolume(val);
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}
