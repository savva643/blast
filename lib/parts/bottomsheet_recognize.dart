import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:record/record.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SongRecognitionScreen extends StatefulWidget {
  final BuildContext prtct;
  final Function showProcessingBottomSheet;
  final Function settype;
  final Function setrecog;
  final Function ff;
  final Function ffd;
  final Function tpik;
  const SongRecognitionScreen({
    super.key,
    required this.prtct,
    required this.showProcessingBottomSheet,
    required this.settype,
    required this.setrecog,
    required this.ff,
    required this.ffd,
    required this.tpik,
  });

  @override
  _SongRecognitionScreenState createState() => _SongRecognitionScreenState();
}

class _SongRecognitionScreenState extends State<SongRecognitionScreen> {
  FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();
  final AudioRecorder _recorder = AudioRecorder();

  bool _isRecording = false;
  String? _recognizedTrack;

  @override
  void initState() {
    super.initState();

    _initializeNotifications();
  }

  void _initializeNotifications() {


    const androidInitializationSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettings = InitializationSettings(android: androidInitializationSettings);

    _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _handleNotificationTap,
    );
  }

  Future<void> _sendNotification(String track) async {
    const androidDetails = AndroidNotificationDetails(
      'song_channel',
      'Song Recognition',
      importance: Importance.high,
      priority: Priority.high,
    );
    const notificationDetails = NotificationDetails(android: androidDetails);

    try {
      await _notificationsPlugin.show(
        0,
        'Распознавание завершено',
        track,
        notificationDetails,
      );
    } catch (e) {
      debugPrint('Error showing notification: $e');
    }
  }

  void _handleNotificationTap(NotificationResponse response) {
    if (_recognizedTrack != null) {
      widget.showProcessingBottomSheet();
      widget.settype('result');
    }
  }



  Future<void> _startRecording() async {

    if (_isRecording) return;
    if(widget.tpik == 'idle' && _isRecording){
      await _recorder.stop();
      _isRecording = false;
      return;
    }
    print("hiiire");
    final hasPermission = await _recorder.hasPermission();
    if (!hasPermission) {
      ScaffoldMessenger.of(widget.prtct).showSnackBar(
        const SnackBar(content: Text('Нет разрешения на запись')),
      );
      return;
    }

    setState(() {
      _isRecording = true;
    });
    widget.showProcessingBottomSheet();
    widget.settype('recording');
    print("gooods");
    try {
      widget.ffd;
    } catch (e) {
      // Обработайте ошибку
      debugPrint('Error starting recording: $e');
    }
    final path = 'audio_${DateTime.now().millisecondsSinceEpoch}.m4a';
    await _recorder.start(RecordConfig(encoder: AudioEncoder.aacLc,
      bitRate: 128000,
      sampleRate: 44100,), path: path);

    Timer(const Duration(seconds: 12), () async {
      print("gbffvbcfvgbd");
      await _stopAndSendRecording();
    });
  }

  Future<void> _stopAndSendRecording() async {
    print("gbffvbcfvgbd2");
    if (!_isRecording) return;
    print("gbffvbcfvgbd3");

    print("gbffvbcfvgbd5");
    try {
      widget.ff;
    } catch (e) {
      debugPrint('Error stopping recording: $e');
    }
    final path = await _recorder.stop();
    print(path);
    setState(() {
      _isRecording = false;
    });

    if (path != null) {
      widget.showProcessingBottomSheet();
      widget.settype('processing');
      print(File(path).path+"hjghgj");
      await _sendRecordingToServer(File(path));
    }
  }

  Future<void> _sendRecordingToServer(File file) async {
    if (widget.tpik == 'idle' && _isRecording) {
      await _recorder.stop();
      _isRecording = false;
      return;
    }

    // Адрес вашего PHP-обработчика
    final uri = Uri.parse('https://kompot.keep-pixel.ru/recognize.php');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? ds = prefs.getString("token");
    try {
      // Создаём запрос с файлом
      final request = http.MultipartRequest('POST', uri)
        ..files.add(await http.MultipartFile.fromPath('audio', file.path))..fields['token'] = ds ?? ''; // 'audio' соответствует PHP-скрипту

      // Отправляем запрос
      final response = await request.send();

      if (response.statusCode == 200) {
        // Получаем результат
        final result = await response.stream.bytesToString();
        print(result);
        dynamic dsa = jsonDecode(result);
        setState(() {
          _recognizedTrack = result; // Сохраняем результат в переменной
        });

        // Обновляем интерфейс
        widget.showProcessingBottomSheet();
        widget.setrecog(dsa["name"],dsa["message"],dsa["img"],dsa["idshaz"], dsa);
        widget.settype('result');
      } else {
        // Если ошибка
        _handleError('Ошибка сервера: ${response.statusCode}');
      }
    } catch (e) {
      // Ловим любые исключения
      _handleError('Ошибка соединения: $e');
    }
  }

// Функция для обработки ошибок
  void _handleError(String message) {
    print(message);
    try {
      widget.showProcessingBottomSheet();
      widget.settype('error');
      _sendNotification('Не удалось распознать трек.');
    } catch (e) {
      print('Ошибка уведомления: $e');
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Распознавание песни')),
      body: Center(
        child: ElevatedButton(
          onPressed: _startRecording,
          child: const Text('Начать запись'),
        ),
      ),
    );
  }
}
