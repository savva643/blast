import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'AudioManager.dart';
import 'dart:html' as html;
import 'dart:html';
class AudioPlayerTask extends BackgroundAudioTask {
  final player = AudioPlayer();
  final AudioManager notifier = AudioManager();
  @override
  Future<void> onStart(Map<String, dynamic>? params) async {
    final url = params?['url'] as MediaItem?;
    if (url != null) {
      await _playNewTrack(url);
    }
  }

  bool newstart = false;


  Future<void> loopstarta(MediaItem mediaItem) async {
    if(newstart){
      try {
        await player.setUrl(getCacheBustedUrl(mediaItem.id)); // Assuming mediaItem.id contains the URL

        bool firstsartn = false;

        player.processingStateStream.firstWhere((state) =>
        state == ProcessingState.ready).then((_) async {
          notifier.setPlaying(true);
          _broadcastState();
          AudioServiceBackground.setMediaItem(MediaItem(
              id: mediaItem.id,
              artUri: mediaItem.artUri,
              artist: mediaItem.artist,
              title: mediaItem.title,
              duration: player.duration

          ));
          newstart = false;
          await player.positionStream.listen((position) {
            notifier.setPosition(position);
            AudioServiceBackground.sendCustomEvent({
              'position': position.inMilliseconds,
              'duration': player.duration?.inMilliseconds ?? 0,
            });
            _broadcastState();
            if (!firstsartn) {
              _fadeTimer?.cancel();
              player.play();
              firstsartn = true;
              notifier.setPlaying(true);
              _broadcastState();
              const duration = Duration(milliseconds: 20);
              _fadeTimer = Timer.periodic(duration, (timer) {
                if (_volume < 1.0) {
                  _volume += 0.05;
                  player.setVolume(_volume);
                } else {
                  _volume = 1.0;
                  player.setVolume(_volume);
                  timer.cancel();
                }
              });
            }
          });


          player.processingStateStream.firstWhere((state) =>
          state == ProcessingState.completed).then((_) async {
            await player.pause();
          });

        });
      }catch (e){
        print("Ошибка загрузки: $e.");
        newstart = true;
        loopstarta(mediaItem);
      }
    }
  }

    @override
  Future<void> onPlayMediaItem(MediaItem mediaItem) async {
    // When a new media item is requested, load and play it
      newstart = false;
    try {
      await player.setUrl(
          mediaItem.id); // Assuming mediaItem.id contains the URL

      bool firstsartn = false;

      player.processingStateStream.firstWhere((state) =>
      state == ProcessingState.ready).then((_) async {
        notifier.setPlaying(true);
        _broadcastState();
        AudioServiceBackground.setMediaItem(MediaItem(
            id: mediaItem.id,
            artUri: mediaItem.artUri,
            artist: mediaItem.artist,
            title: mediaItem.title,
            duration: player.duration

        ));
        await player.positionStream.listen((position) {
          notifier.setPosition(position);
          print("fdvfvsdz"+(player.duration?.inMilliseconds ?? 0).toString());
          AudioServiceBackground.sendCustomEvent({
            'position': position.inMilliseconds,
            'duration': player.duration?.inMilliseconds ?? 0,
          });
          _broadcastState();
          if (!firstsartn) {
            _fadeTimer?.cancel();
            player.play();
            firstsartn = true;
            notifier.setPlaying(true);
            _broadcastState();
            const duration = Duration(milliseconds: 20);
            _fadeTimer = Timer.periodic(duration, (timer) {
              if (_volume < 1.0) {
                _volume += 0.05;
                player.setVolume(_volume);
              } else {
                _volume = 1.0;
                player.setVolume(_volume);
                timer.cancel();
              }
            });

          }
        });


        player.processingStateStream.firstWhere((state) =>
        state == ProcessingState.completed).then((_) async {
          await player.pause();
        });

      });
    }catch (e){
      print("Ошибка загрузки: $e.");
      newstart = true;
      loopstarta(mediaItem);
    }
  }






  Future<void> loopstartb(MediaItem mediaItem) async {
    if(newstart){
      try {
        print("hhgm"+mediaItem.id);
        await player.setUrl(getCacheBustedUrl(mediaItem.id));
        notifier.setDuration(player.duration ?? Duration.zero);
        player.processingStateStream.firstWhere((state) => state == ProcessingState.ready).then((_) async {
          _broadcastState();
          AudioServiceBackground.setMediaItem(MediaItem(
              id: mediaItem.id,
              artUri: mediaItem.artUri,
              artist: mediaItem.artist,
              title: mediaItem.title,
              duration: player.duration
          ));
          await player.positionStream.listen((position) {
            notifier.setPosition(position);
            AudioServiceBackground.sendCustomEvent({
              'position': position.inMilliseconds,
              'duration': player.duration?.inMilliseconds ?? 0,
            });
            _broadcastState();
          });


        });
        print(mediaItem);
      }catch (e){
        print("Ошибка загрузки: $e.");
        newstart = true;
        loopstartb(mediaItem);
      }
    }
  }

  Future<void> _playNewTrack(MediaItem mediaItem) async {
    print("hhgm"+mediaItem.id);
    try {
      await player.setUrl(mediaItem.id);
      notifier.setDuration(player.duration ?? Duration.zero);
      player.processingStateStream.firstWhere((state) =>
      state == ProcessingState.ready).then((_) async {
        _broadcastState();
        AudioServiceBackground.setMediaItem(MediaItem(
            id: mediaItem.id,
            artUri: mediaItem.artUri,
            artist: mediaItem.artist,
            title: mediaItem.title,
            duration: player.duration
        ));
        await player.positionStream.listen((position) {
          notifier.setPosition(position);
          print("fbfgfxgb"+(player.duration?.inMilliseconds ?? 0).toString());
          print("nhgfghdgn"+position.inMilliseconds.toString());
          print("fbgdghdgh"+player.position.inMilliseconds.toString());
          AudioServiceBackground.sendCustomEvent({
            'position': position.inMilliseconds,
            'duration': player.duration?.inMilliseconds ?? 0,
          });
          _broadcastState();
        });

      });
      print(mediaItem);

      // Listen for position updates
    }catch (e){
      print("Ошибка загрузки: $e.");
      newstart = true;
      loopstartb(mediaItem);
    }

  }

  String getCacheBustedUrl(String url) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return "$url?timestamp=$timestamp";
  }




  double _volume = 1.0; // начальная громкость
  Timer? _fadeTimer;

  @override
  Future<void> onStop() async {
    await player.stop();
    notifier.setPlaying(false);
    await super.onStop();
  }

  double _clampVolume(double volume) {
    return volume.clamp(0.0, 1.0);
  }

  Timer? _progressTimer;



  void _updateMediaSession(MediaItem mediaItem) {
    if (html.window.navigator.mediaSession != null) {
      final mediaSession = html.window.navigator.mediaSession!;

      // Установить метаданные текущего трека
      mediaSession.metadata = html.MediaMetadata({
        'title': mediaItem.title,
        'artist': mediaItem.artist,
        'album': 'Album', // Добавьте альбом, если он доступен
        'artwork': [
          {
            'src': mediaItem.artUri?.toString() ?? '',
            'sizes': '512x512',
            'type': 'image/png',
          }
        ],
      });

      // Установить действия управления
      mediaSession.setActionHandler('play', () {
        onPlay();
      });

      mediaSession.setActionHandler('pause', () {
        onPause();
      });

      mediaSession.setActionHandler('seekbackward', () {
        final currentPosition = player.position;
        onSeekTo(currentPosition - const Duration(seconds: 10));
      });

      mediaSession.setActionHandler('seekforward', () {
        final currentPosition = player.position;
        onSeekTo(currentPosition + const Duration(seconds: 10));
      });

      mediaSession.setActionHandler('seekto', (dynamic details) {
        if (details.seekTime != null) {
          onSeekTo(Duration(seconds: details.seekTime!.toInt()));
        }
      } as html.MediaSessionActionHandler?);

      // Установить состояние воспроизведения
      mediaSession.playbackState = player.playing ? 'playing' : 'paused';
    }
  }




  @override
  Future<void> onPlay() async {
    _fadeTimer?.cancel();
    await player.play();
    notifier.setPlaying(true);
    _broadcastState();
    const duration = Duration(milliseconds: 20);
    _fadeTimer = Timer.periodic(duration, (timer) {
      if (_volume < 1.0) {
        _volume = (_volume + 0.05); // Обновляем громкость
        player.setVolume(_volume);
      } else {
        _volume = 1.0;
        player.setVolume(_volume);
        timer.cancel();
      }
    });
  }

  @override
  Future<void> onPause() async {
    _fadeTimer?.cancel();

    // Плавное уменьшение громкости
    const duration = Duration(milliseconds: 10);
    _fadeTimer = Timer.periodic(duration, (timer) async {
      if (_volume > 0.0) {
        _volume = (_volume - 0.05); // Обновляем громкость
        player.setVolume(_volume);
      } else {
        _volume = 0.0;
        player.setVolume(_volume);
        timer.cancel();
        await player.pause();
      }
    });
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
      ],
      systemActions: [
        MediaAction.seek,
        MediaAction.play,
        MediaAction.pause,
      ],
      processingState: AudioProcessingState.ready,
      playing: player.playing,
      position: player.position,
      bufferedPosition: player.bufferedPosition,
    );


  }

}
