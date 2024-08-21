import 'package:flutter/cupertino.dart';

class AudioManager extends ChangeNotifier {

  bool _isPlaying = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  bool get isPlaying => _isPlaying;
  Duration get position => _position;
  Duration get duration => _duration;

  void setPlaying(bool playing) {
    _isPlaying = playing;
    notifyListeners();
  }

  void setPosition(Duration position) {
    _position = position;
    notifyListeners();
  }

  void setDuration(Duration duration) {
    _duration = duration;
    notifyListeners();
  }


  @override
  void dispose() {
    super.dispose();
  }
}