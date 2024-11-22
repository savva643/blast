import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'AudioManager.dart';
class AudioPlayerTask extends BackgroundAudioTask {
  final player = AudioPlayer();
  final AudioManager notifier = AudioManager();
  @override
  Future<void> onStart(Map<String, dynamic>? params) async {
    final initialTrack = params?['track'] as MediaItem?;
    if (initialTrack != null) {
      await _playNewTrack(initialTrack);

    }
  }

  bool newstart = false;


  Future<void> loopstarta(MediaItem mediaItem) async {
    stopListening();
    if(newstart){
      try {
        await player.setUrl(getCacheBustedUrl(mediaItem.extras?['url'])); // Assuming mediaItem.id contains the URL

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


          startListening();
        });
      }catch (e){
        print("Ошибка загрузки: $e.");
        newstart = true;
        loopstarta(mediaItem);
      }
    }
  }


  MediaItem mediaItemFromJson(Map<String, dynamic> json) {
    return MediaItem(
      id: json['id'] as String,
      album: json['album'] as String?,
      title: json['title'] as String,
      artist: json['artist'] as String?,
      genre: json['genre'] as String?,
      duration: json['duration'] != null ? Duration(milliseconds: json['duration']) : null,
      artUri: json['artUri'] != null ? Uri.parse(json['artUri']) : null,
      extras: json['extras'] as Map<String, dynamic>?,
    );
  }



  @override
  Future<dynamic> onCustomAction(String action, dynamic params) async {
    switch (action) {
      case 'addToQueue':
        if (params != null && params['track'] != null) {
          final track = mediaItemFromJson(params['track'] as Map<String, dynamic>);
          trackQueue.add(track);
          onQueueChanged();
        }
        break;

      case 'removeFromQueue':
        if (params != null && params['trackId'] != null) {
          trackQueue.removeWhere((item) => item.id == params['trackId']);
          onQueueChanged();
        }
        break;

      case 'setQueue':
        if (params != null && params['playlist'] != null) {
          trackQueue.clear();

          // Парсинг плейлиста
          final playlist = (params['playlist'] as List)
              .map((track) => mediaItemFromJson(track as Map<String, dynamic>))
              .toList();
          trackQueue.addAll(playlist);

          // Обновить очередь
          onQueueChanged();

          // Если передан индекс, воспроизвести трек с этим индексом
          final int? startIndex = params['startIndex'] as int?;
          if (startIndex != null && startIndex >= 0 && startIndex < trackQueue.length) {
            _playNewTrack(trackQueue[startIndex]);
          } else if (trackQueue.isNotEmpty && player.processingState != ProcessingState.ready) {
            // Если индекс не передан, воспроизвести первый трек
            _playNewTrack(trackQueue.first);
          }
        }
        break;
      case 'next':
        await _playNextTrack();
        break;

      case 'previous':
        await _playPreviousTrack();
        break;
      default:
        break;
    }
    return super.onCustomAction(action, params);
  }


  void onQueueChanged() {
    AudioServiceBackground.setQueue(trackQueue);
  }




  @override
  Future<void> onPlayMediaItem(MediaItem mediaItem) async {
    stopListening();
    // When a new media item is requested, load and play it
      newstart = false;
    try {
      await player.setUrl(
          mediaItem.extras?['url']); // Assuming mediaItem.id contains the URL

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
        startListening();



      });
    }catch (e){
      print("Ошибка загрузки: $e.");
      newstart = true;
      loopstarta(mediaItem);
    }
  }


  Future<void> _playNextTrack() async {
    print("hgghnmghnghnhg"+currentTrackIndex.toString());
    if (currentTrackIndex < trackQueue.length - 1) {
      currentTrackIndex++;
      await _playNewTrack(trackQueue[currentTrackIndex]);

      print("csdvfdsvvsdfv"+trackQueue.toString());
    } else {
      await player.stop();
      notifier.setPlaying(false);
      _broadcastState();
    }
  }

  Future<void> _playPreviousTrack() async {
    if (currentTrackIndex > 0) {
      currentTrackIndex--;
      await _playNewTrack(trackQueue[currentTrackIndex]);
    }
  }

  void addTrackToQueue(Map<String, dynamic> trackData) {
    final mediaItem = _createMediaItem(trackData);
    trackQueue.add(mediaItem);
  }

  List<MediaItem> trackQueue = [];
  int currentTrackIndex = 0;



  MediaItem _createMediaItem(Map<String, dynamic> trackData) {
    return MediaItem(
      id: trackData['id'] as String,
      title: trackData['name'] as String,
      artist: trackData['artist'] as String,
      artUri: Uri.parse(trackData['img'] as String),
      extras: {
        'idshaz': trackData['idshaz'],
        'url': trackData['url'],
      },
    );
  }

  Future<void> loopstartb(MediaItem mediaItem) async {
    stopListening();
    if(newstart){
      try {
        print("hhgm"+mediaItem.id);
        await player.setUrl(getCacheBustedUrl(mediaItem.extras?['url']));
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
        startListening();
        print(mediaItem);
      }catch (e){
        print("Ошибка загрузки: $e.");
        newstart = true;
        loopstartb(mediaItem);
      }
    }
  }
  void stopListening() {
    processingStateSubscription?.cancel();
    processingStateSubscription = null; // Убираем ссылку для избежания утечек памяти.
  }
  StreamSubscription? processingStateSubscription;

  void startListening() {
    processingStateSubscription = player.processingStateStream.listen((state) async {
      if (state == ProcessingState.completed) {
        await _playNextTrack();
        print("bgcfgbbgfcgbcccccccccccccccccccccccccccccchi");
      }
    });
  }
  Future<void> _playNewTrack(MediaItem mediaItem) async {
    stopListening();
    print("hhgm"+mediaItem.extras?['url']);
    try {

      await player.setUrl(mediaItem.extras?['url']);
      notifier.setDuration(player.duration ?? Duration.zero);
      currentTrackIndex = trackQueue.indexWhere((item) => item.id == mediaItem.id);
      AudioServiceBackground.setMediaItem(mediaItem);
      player.processingStateStream.firstWhere((state) =>
      state == ProcessingState.ready).then((_) async {
        _broadcastState();
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

      startListening();
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
        MediaControl.skipToNext,
        MediaControl.skipToPrevious,
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
