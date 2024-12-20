import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListManagerProvider with ChangeNotifier {
  // Хранилище списков (временное)
  final Map<String, List<dynamic>> _lists = {};

  // Получение всех списков
  Map<String, List<dynamic>> get lists => _lists;

  /// Загрузка данных из SharedPreferences
  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final savedData = prefs.getString('saved_lists');
    if (savedData != null) {
      final decoded = json.decode(savedData) as Map<String, dynamic>;
      _lists.clear();
      decoded.forEach((key, value) {
        _lists[key] = List<dynamic>.from(value);
      });
      notifyListeners();
    }
  }

  /// Сохранение данных в SharedPreferences
  Future<void> saveData() async {
    final prefs = await SharedPreferences.getInstance();
    final encodedData = json.encode(_lists);
    await prefs.setString('saved_lists', encodedData);
  }

  /// Получить список по ключу
  List<dynamic> getList(String key) {
    return _lists[key] ?? [];
  }

  /// Создать новый список (пустой или с заранее заданными элементами)
  Future<void> createList(String key, [List<dynamic>? initialData]) async {
    if (!_lists.containsKey(key)) {
      _lists[key] = initialData ?? [];
      await saveData();
      notifyListeners();
    }
  }

  /// Удалить список по ключу
  Future<void> deleteList(String key) async {
    if (_lists.containsKey(key)) {
      _lists.remove(key);
      await saveData();
      notifyListeners();
    }
  }

  /// Добавить элемент в список
  Future<void> addItem(String key, Map<String, dynamic> item) async {
    if (_lists.containsKey(key)) {
      _lists[key]!.add(item);
      await saveData();
      notifyListeners();
    }
  }

  /// Удалить элемент из списка по индексу
  Future<void> removeItemByIndex(String key, int index) async {
    if (_lists.containsKey(key) && index >= 0 && index < _lists[key]!.length) {
      _lists[key]!.removeAt(index);
      await saveData();
      notifyListeners();
    }
  }

  /// Обновить элемент в списке по `idshaz`
  Future<void> updateItemById(String key, Map<String, dynamic> newItem) async {
    final idshaz = newItem['idshaz'];
    if (idshaz == null || !_lists.containsKey(key)) return;

    bool updated = false;

    for (int i = 0; i < _lists[key]!.length; i++) {
      if (_lists[key]![i]['idshaz'] == idshaz) {
        _lists[key]![i] = newItem; // Обновляем элемент
        updated = true;
        break;
      }
    }

    if (updated) {
      await saveData();
      notifyListeners();
    }
  }
}
