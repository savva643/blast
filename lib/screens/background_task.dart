import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'AudioManager.dart';

class AudioPlayerTask extends BackgroundAudioTask {
  final _player = AudioPlayer();
  final AudioManager notifier = AudioManager();

  @override
  Future<void> onStart(Map<String, dynamic>? params) async {
    final url = params?['url'] as String?;
    if (url != null) {
      await _playNewTrack(url);
    }
  }

  Future<void> onPlayNewTrack(String url) async {
    // Stop current track if playing
    await _player.stop();
    notifier.setPlaying(false);
    print("ds");

    // Load the new track
    await _playNewTrack(url);
  }

  Future<void> _playNewTrack(String url) async {
    await _player.setUrl(url);
    notifier.setDuration(_player.duration ?? Duration.zero);
    _player.play();
    notifier.setPlaying(true);
    _broadcastState();
    print(url);

    // Listen for position updates
    _player.positionStream.listen((position) {
      notifier.setPosition(position);
      _broadcastState();
    });

    // Listen for duration updates (in case it's updated after the track starts playing)
    _player.durationStream.listen((duration) {
      notifier.setDuration(duration ?? Duration.zero);
    });
  }

  @override
  Future<void> onStop() async {
    await _player.stop();
    notifier.setPlaying(false);
    await super.onStop();
  }

  @override
  Future<void> onPlay() async {
    _player.play();
    notifier.setPlaying(true);
    _broadcastState();
  }

  @override
  Future<void> onPause() async {
    _player.pause();
    notifier.setPlaying(false);
    _broadcastState();
  }

  @override
  Future<void> onSeekTo(Duration position) async {
    _player.seek(position);
    notifier.setPosition(position);
    _broadcastState();
  }

  void _broadcastState() {
    AudioServiceBackground.setState(
      controls: [
        MediaControl.play,
        MediaControl.pause,
        MediaControl.stop,
      ],
      systemActions: [MediaAction.seek],
      processingState: AudioProcessingState.ready,
      playing: _player.playing,
      position: _player.position,
      bufferedPosition: _player.bufferedPosition,
    );
  }
}
