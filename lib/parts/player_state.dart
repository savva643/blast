import 'package:flutter/material.dart';

class PlayerState extends ChangeNotifier {

  String _songTitle = "Default Song Title";

  String get songTitle => _songTitle;

  void updateSongTitle(String newTitle) {
    _songTitle = newTitle;
    notifyListeners(); // Notify widgets to rebuild
  }
}

