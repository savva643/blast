/* import 'package:smtc_windows/smtc_windows.dart';
import 'package:flutter/foundation.dart';

class WindowsSMTC {
  late SMTCWindows smtc;

  WindowsSMTC() {
    smtc = SMTCWindows(
      metadata: const MusicMetadata(
        title: 'Название',
        artist: 'Исполнитель',
        thumbnail: 'https://kompot.keeppixel.store/img/music.jpg',
      ),
      timeline: const PlaybackTimeline(
        startTimeMs: 0,
        endTimeMs: 1000,
        positionMs: 0,
      ),
      config: const SMTCConfig(
        fastForwardEnabled: false,
        nextEnabled: false,
        pauseEnabled: true,
        playEnabled: true,
        rewindEnabled: false,
        prevEnabled: false,
        stopEnabled: false,
      ),
    );
  }

  void initializeListeners({
    required Function onPlay,
    required Function onPause,
    required Function onNext,
    required Function onPrevious,
  }) {
    smtc.buttonPressStream.listen((event) {
      switch (event) {
        case PressedButton.play:
          onPlay();
          break;
        case PressedButton.pause:
          onPause();
          break;
        case PressedButton.next:
          onNext();
          break;
        case PressedButton.previous:
          onPrevious();
          break;
        case PressedButton.stop:
          smtc.setPlaybackStatus(PlaybackStatus.stopped);
          smtc.disableSmtc();
          break;
        default:
          break;
      }
    });
  }

  void updatePlayerData(
      dynamic player,
      dynamic mediaItem,
      Function canSkipToNext,
      Function canSkipToPrevious,
      ) {
    if (!kIsWeb) {
      smtc.setPosition(player.position);
      smtc.setEndTime(player.duration!);
      smtc.setIsNextEnabled(canSkipToNext() == "true");
      smtc.setIsPrevEnabled(canSkipToPrevious() == "true");
      smtc.setPlaybackStatus(
          player.playing ? PlaybackStatus.playing : PlaybackStatus.paused);

      smtc.updateMetadata(
        MusicMetadata(
          title: mediaItem.title,
          artist: mediaItem.artist,
          thumbnail: mediaItem.artUri?.toString(),
        ),
      );
    }
  }


  void updatePlayerTime(
      dynamic player,
      Function canSkipToNext,
      Function canSkipToPrevious,
      ) {
    if (!kIsWeb) {
      smtc.setPosition(player.position);
      smtc.setEndTime(player.duration!);
      smtc.setIsNextEnabled(canSkipToNext() == "true");
      smtc.setIsPrevEnabled(canSkipToPrevious() == "true");
      smtc.setPlaybackStatus(
          player.playing ? PlaybackStatus.playing : PlaybackStatus.paused);

    }
  }
  void dispose() {
    smtc.disableSmtc();
  }
}
*/