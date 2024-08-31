import 'dart:async';

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


  @override
  Future<void> onPlayMediaItem(MediaItem mediaItem) async {
    // When a new media item is requested, load and play it
    await player.setUrl(mediaItem.id); // Assuming mediaItem.id contains the URL
    player.processingStateStream.firstWhere((state) => state == ProcessingState.ready).then((_) async {
      await player.play();
      notifier.setPlaying(true);
      _broadcastState();
      await player.positionStream.listen((position) {
        notifier.setPosition(position);
        AudioServiceBackground.sendCustomEvent({
          'position': position.inMilliseconds,
          'duration': player.duration?.inMilliseconds ?? 0,
        });
        _broadcastState();
      });

      player.processingStateStream.firstWhere((state) => state == ProcessingState.completed).then((_) async {
        await player.pause();
      });
      // Listen for duration updates (in case it's updated after the track starts playing)
      await player.durationStream.listen((duration) {
        notifier.setDuration(duration ?? Duration.zero);
        print("jkh"+duration!.inSeconds.toString());
      });
    });
  }

  Future<void> _playNewTrack(String url) async {
    await player.setUrl(url);
    notifier.setDuration(player.duration ?? Duration.zero);
    player.processingStateStream.firstWhere((state) => state == ProcessingState.ready).then((_) async {
      _broadcastState();
      await player.positionStream.listen((position) {
        notifier.setPosition(position);
        AudioServiceBackground.sendCustomEvent({
          'position': position.inMilliseconds,
          'duration': player.duration?.inMilliseconds ?? 0,
        });
        _broadcastState();
      });

      // Listen for duration updates (in case it's updated after the track starts playing)
      await player.durationStream.listen((duration) {
        notifier.setDuration(duration ?? Duration.zero);
        print("jkh"+duration!.inSeconds.toString());
      });
    });
    print(url);

    // Listen for position updates



  }

  @override
  Future<void> onStop() async {
    await player.stop();
    notifier.setPlaying(false);
    await super.onStop();
  }

  @override
  Future<void> onPlay() async {
    await player.play();
    notifier.setPlaying(true);
    _broadcastState();
  }

  @override
  Future<void> onPause() async {
    await player.pause();
    notifier.setPlaying(false);
    _broadcastState();
  }

  @override
  Future<void> onSeekTo(Duration position) async {
    await player.seek(position);
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
