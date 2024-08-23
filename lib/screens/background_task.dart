import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'AudioManager.dart';

class AudioPlayerTask extends BackgroundAudioTask {
  final player = AudioPlayer();
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
    await player.stop();
    notifier.setPlaying(false);
    print("ds");

    // Load the new track
    await _playNewTrack(url);
  }

  @override
  Future<void> onPlayMediaItem(MediaItem mediaItem) async {
    // When a new media item is requested, load and play it
    await player.setUrl(mediaItem.id); // Assuming mediaItem.id contains the URL
    player.play();
  }

  Future<void> _playNewTrack(String url) async {
    await player.setUrl(url);
    notifier.setDuration(player.duration ?? Duration.zero);
    player.play();
    notifier.setPlaying(true);
    _broadcastState();
    print(url);

    // Listen for position updates
    player.positionStream.listen((position) {
      notifier.setPosition(position);
      _broadcastState();
    });

    // Listen for duration updates (in case it's updated after the track starts playing)
    player.durationStream.listen((duration) {
      notifier.setDuration(duration ?? Duration.zero);
      print("jkh"+duration!.inSeconds.toString());
    });
  }

  @override
  Future<void> onStop() async {
    await player.stop();
    notifier.setPlaying(false);
    await super.onStop();
  }

  @override
  Future<void> onPlay() async {
    player.play();
    notifier.setPlaying(true);
    _broadcastState();
  }

  @override
  Future<void> onPause() async {
    player.pause();
    notifier.setPlaying(false);
    _broadcastState();
  }

  @override
  Future<void> onSeekTo(Duration position) async {
    player.seek(position);
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
      systemActions: [
        MediaAction.seek,
        MediaAction.play,
        MediaAction.pause,
        MediaAction.stop,
      ],
      processingState: AudioProcessingState.ready,
      playing: player.playing,
      position: player.position,
      bufferedPosition: player.bufferedPosition,
    );
  }
}
