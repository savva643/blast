import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DownloadModel {
  final String id;
  final String idshaz;
  final String name;
  String url;
  final String img;
  final String message;
  final String txt;
  final String messageimg;
  final String short;
  final String vidos;
  final String bgvideo;
  final String elir;

  double progress;
  bool isDownloading;
  bool isCompleted;
  bool isCancelled;
  bool isFailed;

  DownloadModel({
    required this.id,
    required this.idshaz,
    required this.name,
    required this.url,
    required this.img,
    required this.message,
    required this.txt,
    required this.messageimg,
    required this.short,
    required this.vidos,
    required this.bgvideo,
    required this.elir,
    this.progress = 0.0,
    this.isDownloading = false,
    this.isCompleted = false,
    this.isCancelled = false,
    this.isFailed = false,
  });

  MediaItem get mediaItem => MediaItem(
    id: id,
    artUri: Uri.parse(img),
    artist: message,
    title: name,
    extras: {
      'idshaz': idshaz,
      'url': url,
      'messageimg': messageimg,
      'short': short,
      'txt': txt,
      'vidos': vidos,
      'bgvideo': bgvideo,
      'elir': elir,
    },
  );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idshaz': idshaz,
      'name': name,
      'url': url,
      'img': img,
      'message': message,
      'txt': txt,
      'messageimg': messageimg,
      'short': short,
      'vidos': vidos,
      'bgvideo': bgvideo,
      'elir': elir,
      'progress': progress,
      'isCompleted': isCompleted,
      'date': DateFormat('yyyyMMddHHmmss').format(DateTime.now()),
    };
  }

  factory DownloadModel.fromJson(Map<String, dynamic> json) {
    return DownloadModel(
      id: json['id'],
      idshaz: json['idshaz'],
      name: json['name'],
      url: json['url'],
      img: json['img'],
      message: json['message'],
      txt: json['txt'],
      messageimg: json['messageimg'],
      short: json['short'],
      vidos: json['vidos'],
      bgvideo: json['bgvideo'],
      elir: json['elir'],
      progress: json['progress'] ?? 0.0,
      isCompleted: json['isCompleted'] ?? false,
    );
  }
}

class DownloadManager extends ChangeNotifier{
  static final DownloadManager _instance = DownloadManager._internal();
  factory DownloadManager() => _instance;
  DownloadManager._internal();

  final List<DownloadModel> _downloadQueue = [];
  final Map<String, StreamSubscription<List<int>>> _activeSubscriptions = {};
  final Map<String, http.Client> _activeClients = {};
  final StreamController<List<DownloadModel>> _downloadStreamController =
  StreamController.broadcast();

  Stream<List<DownloadModel>> get downloadStream => _downloadStreamController.stream;

  Future<void> addToQueue(DownloadModel track) async {
    if (_downloadQueue.any((item) => item.id == track.id)) return;

    _downloadQueue.add(track);
    _notifyListeners();

    if (!_activeSubscriptions.containsKey(track.id)) {
      await _startDownload(track);
    }
  }

  Future<List<DownloadModel>> getActiveDownloads() async {
    return _downloadQueue.where((d) => !d.isCompleted).toList();
  }

  Future<void> _startDownload(DownloadModel track) async {
    track.isDownloading = true;
    _notifyListeners();

    final client = http.Client();
    _activeClients[track.id] = client;

    try {
      final request = http.Request('GET', Uri.parse(track.url));
      final response = await client.send(request);

      final contentLength = response.contentLength ?? 0;
      final bytes = <int>[];
      final file = await _getTempFile(track.id);

      final subscription = response.stream.listen(
            (List<int> chunk) async {
          bytes.addAll(chunk);
          await file.writeAsBytes(chunk, mode: FileMode.append);
          track.progress = bytes.length / contentLength;
          _notifyListeners();
        },
        onDone: () async {
          await _finalizeDownload(track, file);
          _cleanupDownload(track.id);
        },
        onError: (e) {
          track.isFailed = true;
          _cleanupDownload(track.id);
        },
        cancelOnError: true,
      );

      _activeSubscriptions[track.id] = subscription;
    } catch (e) {
      track.isFailed = true;
      _cleanupDownload(track.id);
    }
  }

  Future<File> _getTempFile(String id) async {
    final dir = await getTemporaryDirectory();
    return File('${dir.path}/$id.tmp');
  }

  Future<void> _finalizeDownload(DownloadModel track, File tempFile) async {
    final dir = await getApplicationDocumentsDirectory();
    final finalFile = File('${dir.path}/${track.id}.mp3');

    if (await tempFile.exists()) {
      await tempFile.rename(finalFile.path);
    }

    track.url = finalFile.uri.toString();
    track.isDownloading = false;
    track.isCompleted = true;

    final prefs = await SharedPreferences.getInstance();
    final savedTracks = prefs.getStringList('downloaded_tracks') ?? [];
    savedTracks.add(jsonEncode(track.toJson()));
    await prefs.setStringList('downloaded_tracks', savedTracks);
  }

  void _cleanupDownload(String id) {
    _activeSubscriptions[id]?.cancel();
    _activeClients[id]?.close();
    _activeSubscriptions.remove(id);
    _activeClients.remove(id);
    _notifyListeners();
  }

  void _notifyListeners() {
    _downloadStreamController.add([..._downloadQueue]);
  }

  Future<void> cancelDownload(String id) async {
    final track = _downloadQueue.firstWhere((item) => item.id == id);
    track.isCancelled = true;
    track.isDownloading = false;

    _cleanupDownload(id);

    // Удаляем временный файл
    try {
      final tempFile = await _getTempFile(id);
      if (await tempFile.exists()) await tempFile.delete();
    } catch (e) {
      print('Error deleting temp file: $e');
    }
  }

  Future<List<DownloadModel>> getDownloadedTracks() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTracks = prefs.getStringList('downloaded_tracks') ?? [];
    return savedTracks.map((e) => DownloadModel.fromJson(jsonDecode(e))).toList();
  }

  Future<void> clearCompletedDownloads() async {
    _downloadQueue.removeWhere((item) => item.isCompleted);
    _notifyListeners();
  }
}