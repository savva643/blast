import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QueueManagerProvider with ChangeNotifier {
  // Хранилище списков (временное)
  List<dynamic> _queue = [];

  // Текущий трек
  Map<String, dynamic>? _currentTrack =
  {
    'id': '1',
    'img': 'https://bladt.keep-pixel.ru/static/img/music.jpg',
    'name': 'Название',
    'message': 'Имполнитель',
    'idshaz': '423432'
  };

  // Текущий альбом
  String? _currentAlbum;

  List<dynamic> get queue => _queue;

  Map<String, dynamic>? get currentTrack => _currentTrack;
  String? get currentAlbum => _currentAlbum;

  // Установка текущего трека
  Future<void> setCurrentTrack(Map<String, dynamic> track) async {
    _currentTrack = track;
    await saveToCache();
    notifyListeners();
  }

  // Установка текущего альбома
  Future<void> setCurrentAlbum(String album) async {
    _currentAlbum = album;
    await saveToCache();
    notifyListeners();
  }


  void addToQueue(dynamic track) {
    _queue.add(track);
    notifyListeners();
  }

  void removeFromQueue(int index) {
    if (index >= 0 && index < _queue.length) {
      _queue.removeAt(index);
      notifyListeners();
    }
  }

  Future<void> clear() async {
    _queue.clear();
    await saveToCache();
    notifyListeners();
  }

  void setQueue(List<dynamic> queue) {
    _queue = queue;
    notifyListeners();
  }

  Future<void> removeItemByIndex(String key, int index) async {
    if (index >= 0 && index < _queue.length) {
      _queue.removeAt(index);
      await saveToCache();
      notifyListeners();
    }
  }


  Future<int> getItemByIndex(Map<String, dynamic> newItem) async {
    final idshaz = newItem['idshaz'];
    if (idshaz == null) return 0;
      notifyListeners();
      int fv = 0;
      for (int i = 0; i < _queue.length; i++) {
        if (_queue[i]['idshaz'] == idshaz) {
          fv = i;
          break;
        }
      }
      return fv;
  }

  Future<void> loadFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    final savedData = prefs.getString('queue_list');
    if (savedData != null) {
      final decoded = json.decode(savedData) as List<dynamic>;
      _queue.clear();
      _queue = List<dynamic>.from(decoded);
      notifyListeners();
    }
  }

  Future<void> saveToCache() async {
    final prefs = await SharedPreferences.getInstance();
    final encodedData = json.encode(_queue);
    await prefs.setString('queue_list', encodedData);
  }
}
