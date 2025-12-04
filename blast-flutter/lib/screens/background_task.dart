import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import '../providers/queue_manager_provider.dart';
import 'AudioManager.dart';
// import '../api/smtc_windows_integration.dart' if (dart.library.html) '../api/smtc_stub.dart';
import '../api/smtc_stub.dart';


class AudioPlayerTask extends BackgroundAudioTask {
  final player = AudioPlayer();

  late WindowsSMTC smtc;
  final AudioManager notifier = AudioManager();




  LoopMode _repeatMode = LoopMode.off;
  bool _isShuffleEnabled = false;
  List<MediaItem> _shuffledQueue = [];

  void toggleRepeatMode() {
    _repeatMode = LoopMode.values[(_repeatMode.index + 1) % LoopMode.values.length];
    // player.setLoopMode(_repeatMode);
    print("repeatMode"+_repeatMode.name);
    AudioServiceBackground.sendCustomEvent({
      'repeatMode': _repeatMode.index,
      'skip': "fgbds",
      'canforward': canSkipToNext(),
      'canprevious': canSkipToPrevious(),
    });
    _broadcastState();
  }

  void getNextTrack() {
    // Проверяем, если очередь пуста или текущий индекс недействителен
    if (trackQueue.isEmpty || currentTrackIndex < 0) {
      print("No next track to send.");
      AudioServiceBackground.sendCustomEvent({
        'nextTrack': null,
      });
      return;
    }

    // Определяем очередь: перемешанная или стандартная
    final queue = _isShuffleEnabled ? _shuffledQueue : trackQueue;
    print("nextvid1");
    if (_repeatMode == LoopMode.one) {
      // Если режим повтора одного трека, следующий трек — это текущий
      final mediaItem = queue[currentTrackIndex];
      _sendTrackData('nextTrack', mediaItem);
      print("Repeating current track as next track: ${mediaItem.title}");
    } else if (_repeatMode == LoopMode.all && currentTrackIndex == queue.length - 1) {
      // Если конец плейлиста и включён режим повтора всего списка
      final mediaItem = queue.first;
      _sendTrackData('nextTrack', mediaItem);
      print("Looping to the first track: ${mediaItem.title}");
    } else if (currentTrackIndex < queue.length - 1) {
      // Обычный переход к следующему треку
      final mediaItem = queue[currentTrackIndex + 1];
      print("nextvid4");
      _sendTrackData('nextTrack', mediaItem);
      print("Next track sent: ${mediaItem.title}");
    } else {
      // Если в обычном режиме и текущий трек — последний, ничего не делаем
      print("No next track available.");
      AudioServiceBackground.sendCustomEvent({
        'nextTrack': null,
      });
    }
  }

  void getPreviousTrack() {
    // Проверяем, если очередь пуста или текущий индекс недействителен
    if (trackQueue.isEmpty || currentTrackIndex <= 0) {
      print("No previous track to send.");
      AudioServiceBackground.sendCustomEvent({
        'previousTrack': null,
      });
      return;
    }

    // Определяем индекс предыдущего трека
    final queue = _isShuffleEnabled ? _shuffledQueue : trackQueue;

    if (_repeatMode == LoopMode.one) {
      // Если режим повтора одного трека, текущий трек считается предыдущим
      final mediaItem = queue[currentTrackIndex];
      _sendTrackData('previousTrack', mediaItem);
      print("Repeating current track as previous track: ${mediaItem.title}");
    } else if (_repeatMode == LoopMode.all && currentTrackIndex == 0) {
      // Если начало плейлиста и включен режим повтора всего списка
      final mediaItem = queue.last;
      _sendTrackData('previousTrack', mediaItem);
      print("Looping to the last track: ${mediaItem.title}");
    } else if (currentTrackIndex > 0) {
      // Обычный переход к предыдущему треку
      final mediaItem = queue[currentTrackIndex - 1];
      _sendTrackData('previousTrack', mediaItem);
      print("Previous track sent: ${mediaItem.title}");
    }
  }

  /// Вспомогательная функция для отправки трека через Custom Event
  void _sendTrackData(String eventKey, MediaItem mediaItem) {
    dynamic trackData = {
      "id": mediaItem.id,
      "img": mediaItem.artUri?.toString(),
      "name": mediaItem.title,
      "message": mediaItem.artist,
      "url": mediaItem.extras?['url'],
      "elir": mediaItem.extras?['elir'],
      "idshaz": mediaItem.extras?['idshaz'],
      "messageimg": mediaItem.extras?['messageimg'],
      "short": mediaItem.extras?['short'],
      "txt": mediaItem.extras?['txt'],
      "vidos": mediaItem.extras?['vidos'],
      "bgvideo": mediaItem.extras?['bgvideo'],
    };
    print("nextvid5");
    AudioServiceBackground.sendCustomEvent({
      eventKey: trackData,
    });
  }

  List<Map<String, dynamic>> convertMediaItemListToJson(List<MediaItem> items) {
    return items.map((mediaItem) {
      return {
        "id": mediaItem.id,
        "img": mediaItem.artUri?.toString() ?? "",
        "name": mediaItem.title,
        "message": mediaItem.artist ?? "",
        "url": mediaItem.extras?["url"],
        "elir": mediaItem.extras?["elir"],
        "idshaz": mediaItem.extras?["idshaz"],
        "messageimg": mediaItem.extras?["messageimg"],
        "short": mediaItem.extras?["short"],
        "txt": mediaItem.extras?["txt"],
        "vidos": mediaItem.extras?["vidos"],
        "bgvideo": mediaItem.extras?["bgvideo"],
      };
    }).toList();
  }

  void toggleShuffle() {
    _isShuffleEnabled = !_isShuffleEnabled;

    if (_isShuffleEnabled) {
      _shuffledQueue = List.from(trackQueue)..shuffle();
      currentTrackIndex = _shuffledQueue.indexOf(trackQueue[currentTrackIndex]);
      final shuffledJson = convertMediaItemListToJson(_shuffledQueue);
      AudioServiceBackground.sendCustomEvent({
        'setqueue': shuffledJson,
      });
    } else {
      currentTrackIndex = trackQueue.indexOf(_shuffledQueue[currentTrackIndex]);
      _shuffledQueue.clear();
      final shuffledJson = convertMediaItemListToJson(trackQueue);
      AudioServiceBackground.sendCustomEvent({
        'setqueue': shuffledJson,
      });
    }
    AudioServiceBackground.sendCustomEvent({
      'isShuffleEnabled': _isShuffleEnabled,
    });
    _broadcastState();
  }

  @override
  Future<void> onSetShuffleMode(AudioServiceShuffleMode shuffleMode) {
    // TODO: implement onSetShuffleMode
    return super.onSetShuffleMode(shuffleMode);
  }

  @override
  Future<void> onStart(Map<String, dynamic>? params) async {
    final initialTrack = params?['track'] as MediaItem?;
    if (initialTrack != null) {
      await _playNewTrack(initialTrack, false);
    }
     smtc = WindowsSMTC();

     if (!kIsWeb && defaultTargetPlatform == TargetPlatform.windows) {
      smtc.initializeListeners(
        onNext: onSkipToNext,
        onPrevious: onSkipToPrevious,
        onPlay: player.play,
        onPause: player.pause,
      );
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
              duration: player.duration,
              extras: mediaItem.extras
          ));
          dynamic dsa = {"id": mediaItem.id, "img": mediaItem.artUri.toString(),"name": mediaItem.title,"message": mediaItem.artist,"url": mediaItem.extras?['url'],"elir": mediaItem.extras?['elir'],"idshaz": mediaItem.extras?['idshaz'], "messageimg": mediaItem.extras?['messageimg'],"short": mediaItem.extras?['short'],"txt": mediaItem.extras?['txt'],"vidos": mediaItem.extras?['vidos'],"bgvideo": mediaItem.extras?['bgvideo'],};
          AudioServiceBackground.sendCustomEvent({
            'currentTracki': dsa,
          });
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




  String canSkipToNext() {
    // Получаем текущий трек и его индекс
    final currentMediaItem = AudioService.currentMediaItem;
    if (currentMediaItem == null) return "false";

    final currentIndex = _isShuffleEnabled
        ? _shuffledQueue.indexWhere((item) => item.id == currentMediaItem.id)
        : trackQueue.indexWhere((item) => item.id == currentMediaItem.id);

    // Условия перехода на следующий трек
    final isLastTrack = currentIndex >= (trackQueue.length - 1);

    if (_repeatMode == LoopMode.all) {
      // В режиме повторения всего можно перейти (даже с последнего)
      return "true";
    } else {
      // По умолчанию — если текущий трек не последний
      return (!isLastTrack).toString();
    }
  }

  String canSkipToPrevious() {
    // Получаем текущий трек и его индекс
    final currentMediaItem = AudioService.currentMediaItem;
    if (currentMediaItem == null) return "false";

    final currentIndex = _isShuffleEnabled
        ? _shuffledQueue.indexWhere((item) => item.id == currentMediaItem.id)
        : trackQueue.indexWhere((item) => item.id == currentMediaItem.id);

    // Условия перехода на предыдущий трек
    final isFirstTrack = currentIndex <= 0;

    if (_repeatMode == LoopMode.all) {
      // Если активен режим loop 1, нельзя пропустить
      return "true";
    } else {
      // Если не первый трек, можно перейти
      return (!isFirstTrack).toString();
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
          if(_isShuffleEnabled){
            _shuffledQueue = List.from(trackQueue)..shuffle();
          }
          // Обновить очередь
          onQueueChanged();
          // Если передан индекс, воспроизвести трек с этим индексом
          final int? startIndex = params['startIndex'] as int?;
          final bool? needplay = params['needplay'] as bool?;
          final queue = _isShuffleEnabled ? _shuffledQueue : trackQueue;
          if(needplay != null && needplay) {
            if (startIndex != null && startIndex >= 0 &&
                startIndex < queue.length) {
              _playNewTrack(queue[startIndex], true);
            } else if (queue.isNotEmpty &&
                player.processingState != ProcessingState.ready) {
              // Если индекс не передан, воспроизвести первый трек
              _playNewTrack(queue.first, true);
            }
          }else{
            if (startIndex != null && startIndex >= 0 &&
                startIndex < queue.length) {
              currentTrackIndex =
                  queue.indexWhere((item) => item.id == queue[startIndex].id);
            } else if (queue.isNotEmpty &&
                player.processingState != ProcessingState.ready) {
              // Если индекс не передан, воспроизвести первый трек
              currentTrackIndex =
                  queue.indexWhere((item) => item.id == queue[queue.indexOf(queue.first)].id);
            }



          }
        }
        break;
      case 'getskip':
        AudioServiceBackground.sendCustomEvent({
          'skip': "fgbds",
          'canforward': canSkipToNext(),
          'canprevious': canSkipToPrevious(),
        });
        break;
      case 'next':
        await _playNextTrack(false);
        break;

      case 'previous':
        await _playPreviousTrack(false);
        break;

      case 'setindex':
        if (params != null && params['index'] != null) {
          print("hjgfghf"+params.toString());
          final int? startIndex = params['index'] as int?;
          final bool? vid = params['video'] as bool?;
          await _setIndex(startIndex!, vid!);
        }
        break;
      case 'toggleShuffle':
        toggleShuffle();
        break;
      case 'toggleRepeatMode':
        toggleRepeatMode();
        break;
      case 'sendnexttrack':
        print("nextvid2");
        getNextTrack();
        break;
      case 'sendprevioustrack':
        getPreviousTrack();
        break;
      default:
        break;
    }
    return super.onCustomAction(action, params);
  }


  Future<void> onQueueChanged() async {
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
            duration: player.duration,
            extras: mediaItem.extras

        ));
        if(!kIsWeb) {
           smtc.updatePlayerData(
            player,
            mediaItem,
            canSkipToNext,
              canSkipToPrevious
          );
        }
        dynamic dsa = {"id": mediaItem.id, "img": mediaItem.artUri.toString(),"name": mediaItem.title,"message": mediaItem.artist,"url": mediaItem.extras?['url'],"elir": mediaItem.extras?['elir'],"idshaz": mediaItem.extras?['idshaz'], "messageimg": mediaItem.extras?['messageimg'],"short": mediaItem.extras?['short'],"txt": mediaItem.extras?['txt'],"vidos": mediaItem.extras?['vidos'],"bgvideo": mediaItem.extras?['bgvideo'],};
        AudioServiceBackground.sendCustomEvent({
          'currentTracki': dsa,
        });

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


  Future<void> _playNextTrack(bool dsa) async {
    final queue = _isShuffleEnabled ? _shuffledQueue : trackQueue;

    if (_repeatMode == LoopMode.one && dsa) {
      await _playNewTrack(queue[currentTrackIndex], true);
      print("hgghnmghnghnhg"+currentTrackIndex.toString());
    } else if (currentTrackIndex < queue.length - 1) {
      // Следующий трек
      currentTrackIndex++;
      await _playNewTrack(queue[currentTrackIndex], true);
      print("Queue after advancing: $queue");
    } else if (_repeatMode == LoopMode.all) {
      // Повтор всего плейлиста
      currentTrackIndex = 0;
      await _playNewTrack(queue[currentTrackIndex], true);
      print("Repeating playlist: $queue");
    } else {
      // Конец очереди, останавливаем воспроизведение
      await player.stop();
      notifier.setPlaying(false);
      _broadcastState();
    }

    _sendTrackChangedEvent(false);
  }

  Future<void> _setIndex(int index, bool video) async {
    final queue = _isShuffleEnabled ? _shuffledQueue : trackQueue;
    if(video){
      if(index == 1) {
        currentTrackIndex =
            queue.indexWhere((item) => item.id == queue[currentTrackIndex+1].id);
      }else{
        currentTrackIndex =
            queue.indexWhere((item) => item.id == queue[currentTrackIndex-1].id);
      }
    }else {
      await _playNewTrack(queue[index], true);
    }
    _sendTrackChangedEvent(video);

  }




  Future<void> _playPreviousTrack(bool dsa) async {
    final queue = _isShuffleEnabled ? _shuffledQueue : trackQueue;

    if (queue.isEmpty) return; // Если очередь пуста, ничего не делаем.

    if (_repeatMode == LoopMode.one && dsa) {
      // Повтор текущего трека
      await _playNewTrack(queue[currentTrackIndex], true);
      print("Repeating current track.");
    } else if (_repeatMode == LoopMode.all && currentTrackIndex == 0) {
      // Переход на последний трек, если это начало плейлиста
      currentTrackIndex = queue.length - 1;
      await _playNewTrack(queue[currentTrackIndex], true);
      print("Looping back to the end of the playlist.");
    } else if (currentTrackIndex > 0) {
      // Переход на предыдущий трек
      currentTrackIndex--;
      await _playNewTrack(queue[currentTrackIndex], true);
      print("Playing previous track: ${queue[currentTrackIndex].title}");
    } else {
      // Если в обычном режиме и текущий трек — первый, ничего не делаем.
      print("No previous track to play.");
    }

    _sendTrackChangedEvent(false); // Отправка события об изменении трека
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
        'messageimg': trackData['messageimg'],
        'short': trackData['short'],
        'txt': trackData['txt'],
        'vidos': trackData['vidos'],
        'bgvideo': trackData['bgvideo'],
        'elir': trackData['elir'],
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
              duration: player.duration,
              extras: mediaItem.extras
          ));
          dynamic dsa = {"id": mediaItem.id, "img": mediaItem.artUri.toString(),"name": mediaItem.title,"message": mediaItem.artist,"url": mediaItem.extras?['url'],"elir": mediaItem.extras?['elir'],"idshaz": mediaItem.extras?['idshaz'], "messageimg": mediaItem.extras?['messageimg'],"short": mediaItem.extras?['short'],"txt": mediaItem.extras?['txt'],"vidos": mediaItem.extras?['vidos'],"bgvideo": mediaItem.extras?['bgvideo'],};
          AudioServiceBackground.sendCustomEvent({
            'currentTracki': dsa,
          });
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
        if (_repeatMode == LoopMode.one) {
          // Устанавливаем позицию в начало и воспроизводим текущий трек
          await player.seek(Duration.zero);
          await AudioService.play();
          print("Повтор трека (loop 1)");
        } else {
          // Иначе переходим к следующему треку
          await _playNextTrack(true);
          print("Воспроизведение следующего трека");
        }
      }
    });
  }


  void _sendTrackChangedEvent(bool vid) {
    final currentTrack = trackQueue[currentTrackIndex];
    Map<String, dynamic> trackData = {
      'id': currentTrack.id,
      'title': currentTrack.title,
      'artist': currentTrack.artist,
      'album': currentTrack.album,
      'artUri': currentTrack.artUri?.toString(),
      'extras': currentTrack.extras,
      'duration': currentTrack.duration?.inMilliseconds,
    };
    AudioServiceBackground.sendCustomEvent({
      'event': 'trackChanged',
      'currentTrack': trackData, // Преобразуем MediaItem в Map
      'video': vid
    });
    print("hhghngfvhngvm"+trackData.toString());
  }

  Future<void> _playNewTrack(MediaItem mediaItem, bool dfs) async {
    stopListening();
    final queue = _isShuffleEnabled ? _shuffledQueue : trackQueue;
    print("hhgm"+mediaItem.extras?['url']);


    try {

      await player.setUrl(mediaItem.extras?['url']);
      notifier.setDuration(player.duration ?? Duration.zero);
      currentTrackIndex = queue.indexWhere((item) => item.id == mediaItem.id);
      AudioServiceBackground.setMediaItem(mediaItem);
      player.processingStateStream.firstWhere((state) =>
      state == ProcessingState.ready).then((_) async {
        AudioServiceBackground.setMediaItem(
          mediaItem.copyWith(duration: player.duration),
        );
        if(!kIsWeb) {
          smtc.updatePlayerData(
              player,
              mediaItem,
              canSkipToNext,
              canSkipToPrevious
          );
        }
        dynamic dsa = {"id": mediaItem.id, "img": mediaItem.artUri.toString(),"name": mediaItem.title,"message": mediaItem.artist,"url": mediaItem.extras?['url'],"elir": mediaItem.extras?['elir'],"idshaz": mediaItem.extras?['idshaz'], "messageimg": mediaItem.extras?['messageimg'],"short": mediaItem.extras?['short'],"txt": mediaItem.extras?['txt'],"vidos": mediaItem.extras?['vidos'],"bgvideo": mediaItem.extras?['bgvideo'],};
        AudioServiceBackground.sendCustomEvent({
          'currentTracki': dsa,
        });
        _broadcastState();
        if(dfs){
          AudioService.play();
        }
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
  Future<void> onSkipToNext() async {
    if (canSkipToNext() == "false") {
      // Не делаем ничего
      return;
    }
    await _playNextTrack(false);
    return super.onSkipToNext();
  }


  @override
  Future<void> onSkipToPrevious() async {
    if (canSkipToPrevious() == "false") {
      // Не делаем ничего
      return;
    }
    await _playPreviousTrack(false);
    return super.onSkipToPrevious();
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


  AudioServiceRepeatMode _getAudioServiceRepeatMode() {
    switch (_repeatMode) {
      case LoopMode.one:
        return AudioServiceRepeatMode.one;
      case LoopMode.all:
        return AudioServiceRepeatMode.all;
      case LoopMode.off:
      default:
        return AudioServiceRepeatMode.none;
    }
  }

  /// Возвращает текущий режим перемешивания в формате AudioServiceShuffleMode
  AudioServiceShuffleMode _getAudioServiceShuffleMode() {
    return _isShuffleEnabled ? AudioServiceShuffleMode.all : AudioServiceShuffleMode.none;
  }

  void _broadcastState() {
    if(!kIsWeb) {
      smtc.updatePlayerTime(
          player,
          canSkipToNext,
          canSkipToPrevious
      );
    }
    AudioServiceBackground.setState(
      controls: [
        MediaControl.play,
        MediaControl.pause,
        if (canSkipToNext() == "true") MediaControl.skipToNext,
        if (canSkipToPrevious() == "true") MediaControl.skipToPrevious,
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
      repeatMode: _getAudioServiceRepeatMode(),
      shuffleMode: _getAudioServiceShuffleMode(),
    );


  }

}
