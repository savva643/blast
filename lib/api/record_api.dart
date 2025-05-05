import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waveform_recorder/waveform_recorder.dart';

import '../parts/bottomsheet_about_music.dart';

class Recorderi{
  final BuildContext context;
  final Function getaboutmus;
  final Function installmus;
  static Recorderi? _instance;

  factory Recorderi({
    required BuildContext context,
    required Function getaboutmus,
    required Function installmus,
  }) {
    return _instance ??= Recorderi._internal(
      context: context,
      getaboutmus: getaboutmus,
      installmus: installmus,
    );
  }

  Recorderi._internal({
    required this.context,
    required this.getaboutmus,
    required this.installmus,
  });

  final WaveformRecorderController waveformRecorder = WaveformRecorderController();
  bool _isRecording = false;
  String? _recognizedTrack;

  Future<void> startRecording() async {
    if (_isRecording) return;
    if(getStatus() == 'idle' && _isRecording){
      await waveformRecorder.stopRecording();
      _isRecording = false;
      return;
    }


    _isRecording = true;


    await waveformRecorder.startRecording();
    print("gbffvbcfvgbd"+waveformRecorder.isRecording.toString());
    showBottomSheet();
    setRcognizetype('recording');
    Timer(const Duration(seconds: 12), () async {
      print("gbffvbcfvgbd");
      await stopRecording();
    });
  }

  void showBottomSheet() {
    print("sfgdfdsa"+getStatus());
    if(!isBottomSheetOpena) {
      showModalBottomSheet(
        backgroundColor: Color.fromARGB(255, 15, 15, 16),
        context: context,
        isScrollControlled: true,
        builder: (_) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                setnewStatecs = setState;
                isBottomSheetOpena = true;
                return SafeArea(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: getBottomSheetContent(),
                    ),
                  ),
                );
              });
        },
      ).whenComplete(() {
        if (getStatus() != "processing"){
          setRcognizetype('idle');
        }
        isBottomSheetOpena = false; // Когда BottomSheet закрывается, сбрасываем флаг

      });
    }
  }

  Future<void> stopRecording() async {
    if (!_isRecording) return;

    await waveformRecorder.stopRecording();
    _isRecording = false;
  }

  Future<void> onRecordingStopped() async {
    final path = await waveformRecorder.file;
    _isRecording = false;


    if (path != null) {
      showBottomSheet();
      setRcognizetype('processing');
      print(File(path.path).path+"hjghgj");
      await _sendRecordingToServer(File(path.path));
    }
  }

  Future<void> _sendRecordingToServer(File file) async {
    if (getStatus() == 'idle' && _isRecording) {
      await waveformRecorder.stopRecording();
      _isRecording = false;
      return;
    }

    // Адрес вашего PHP-обработчика
    final uri = Uri.parse('https://kompot.keeppixel.store/recognize.php');
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
        _recognizedTrack = result; // Сохраняем результат в переменной


        // Обновляем интерфейс
        showBottomSheet();
        setRcognize(dsa["name"],dsa["message"],dsa["img"],dsa["idshaz"], dsa);
        setRcognizetype('result');
      } else {
        // Если ошибка
        _handleError('Ошибка сервера: ${response.statusCode}');
      }
    } catch (e) {
      // Ловим любые исключения
      _handleError('Ошибка соединения: $e');
    }
  }
  FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  void initializeNotifications() {


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
      showBottomSheet();
      setRcognizetype('result');
    }
  }

// Функция для обработки ошибок
  void _handleError(String message) {
    print(message);
    try {
      showBottomSheet();
      setRcognizetype('error');
      _sendNotification('Не удалось распознать трек.');
    } catch (e) {
      print('Ошибка уведомления: $e');
    }
  }

  late StateSetter setnewStatecs;

  bool isBottomSheetOpena = false;
  final ValueNotifier<String> statusNotifier = ValueNotifier<String>("idle");
  String songName = "Название песни";
  String artist = "Исполнитель";
  String musshazid = "0";
  String albumCoverUrl = "https://via.placeholder.com/150"; // Ссылка на обложку альбома
  dynamic lisa = {};

  String getStatus() {
    return statusNotifier.value;
  }

  void setRcognize(String fds1, String fds2, String fds3, String fds4, dynamic dsac){

    if(isBottomSheetOpena) {

        setnewStatecs(() {
          songName = fds1;
          artist = fds2;
          albumCoverUrl = fds3;
          musshazid = fds4;
          statusNotifier.value = "result";
          lisa = dsac;
        });
    }else{
        songName = fds1;
        artist = fds2;
        albumCoverUrl = fds3;
        musshazid = fds4;
        statusNotifier.value = "result";
        lisa = dsac;
    }
  }
  void setRcognizetype(String fds){
    if(fds == 'idle'){
      isBottomSheetOpena = false;
    }
      if (isBottomSheetOpena) {
        setnewStatecs(() {
          statusNotifier.value = fds;
        });
      } else {
        statusNotifier.value = fds;
      }
  }

  List<Widget> getBottomSheetContent() {
    switch (getStatus()) {
      case 'recording':
        return [
          const Icon(Icons.mic, size: 50, color: Colors.blue),
          const SizedBox(height: 20),
          const Text(
            'Слушаю...',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white ),
          ),
          const SizedBox(height: 20),
          // Визуализация аудиосигнала


          SizedBox(
            height: 160,
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 3),
                borderRadius: BorderRadius.circular(14),
              ),
              child: waveformRecorder.isRecording
                  ? WaveformRecorder(
                height: 60,
                waveColor: Colors.white,
                durationTextStyle: TextStyle(color: Colors.transparent),
                controller: waveformRecorder,
                onRecordingStopped: onRecordingStopped,
              )
                  : Text("no resp"),
            ),
          ),


          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[850]),
            onPressed: () {
              // Отменить запись
              Navigator.pop(context);
              setRcognizetype('idle');
              isBottomSheetOpena = false;
            },
            child: const Text('Отмена', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white ),),
          ),
        ];
      case 'error':
        return [
          Container(width: double.infinity,),
          const Icon(Icons.warning_rounded, size: 50, color: Colors.blue),
          const SizedBox(height: 20),
          const Text(
            'Не удалось распознать трек.',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 20),

          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[850]),
            onPressed: () {
              Navigator.pop(context);
              setRcognizetype('idle');
              isBottomSheetOpena = false;
            },
            child: const Text('Готово', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
          ),
        ];
      case 'processing':
        return [
          Container(width: double.infinity,),

          const CircularProgressIndicator(),
          const SizedBox(height: 20),
          const Icon(Icons.graphic_eq_rounded, size: 50, color: Colors.blue),
          const Text(
            'Распознаю...',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[850]),
            onPressed: () {
              // Отменить распознавание
              Navigator.pop(context);
              setRcognizetype('idle');
              isBottomSheetOpena = false;
            },
            child: const Text('Отмена', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
          ),
        ];
      case 'idle':
        return [
          Container(width: double.infinity,),
          const CircularProgressIndicator(),
          const SizedBox(height: 20),
          const Icon(Icons.graphic_eq_rounded, size: 50, color: Colors.blue),
          const Text(
            'Ожидание',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Отменить распознавание
              Navigator.pop(context);
              setRcognizetype('idle');
              isBottomSheetOpena = false;
            },
            child: const Text('Готово', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
          ),
        ];
      case 'result':
        return [
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20), // Закруглённые края
              child: Image.network(
                albumCoverUrl,
                width: 150,
                height: 150,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.music_note,
                  size: 100,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            songName,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white, // Белый текст
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            artist,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child:
              MaterialButton(
                onPressed: () {
                  // Прослушивание
                  Navigator.pop(context);
                  setRcognizetype('idle');
                  isBottomSheetOpena = false;
                  if(lisa["url"] != "0") {
                    getaboutmus(lisa["idshaz"], false, false, false, false);
                  }else{
                    installmus(lisa, true);
                  }
                },
                color: Colors.grey[850],
                height: 48,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                child: Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                  const Icon(Icons.play_arrow_rounded, color: Colors.white),
                  Text("Слушать",  style: TextStyle(color: Colors.white, fontSize: 18, ),)
                ],
                ),
              )),
              SizedBox(width: 10,),
              IconButton(
                onPressed: () {
                  // Добавить в любимое
                  toggleLike2(lisa['doi']);

                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[850],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                icon: Image(
                    color: Color.fromARGB(255, 255, 255, 255),
                    image: lisa['doi'] == "1" ? AssetImage(
                        'assets/images/loveyes.png') : AssetImage(
                        'assets/images/loveno.png'),
                    width: 26
                ),
              ),
              SizedBox(width: 10,),
              IconButton(
                onPressed: () {
                  showTrackOptionsBottomSheet(context, {"name": songName, "message": artist, "img": albumCoverUrl, "idshaz": musshazid});
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[850],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                icon: const Icon(Icons.more_vert_rounded, color: Colors.white,),

              )
            ],
          ),
          const SizedBox(height: 20),

        ];
      default:
        return [];
    }
  }
  bool isLoading = false;
  Future<void> toggleLike2(String type) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? ds = prefs.getString("token");
    if(ds != "") {
      if (isLoading) return; // Блокируем повторное нажатие во время запроса
      setnewStatecs(() {
        isLoading = true;
      });

      try {

        // Отправляем GET-запрос
        final response = await http.get(Uri.parse(
            'https://kompot.keeppixel.store/reactmusic?mus=' +
                lisa['id'].toString() + '&type=' + type.toString() + "&token="+ds!));

        if (response.statusCode == 200) {
          // Успешный ответ, меняем состояние лайка
          String dff = response.body.toString();
          var _fdsb = jsonDecode(dff);
          if (_fdsb['status'].toString()  == "true") {
              setnewStatecs(() {
                lisa['doi'] = _fdsb['type'].toString();
              });
          }
        } else {
          // Обработка ошибок
          print('Ошибка: ${response.statusCode}');
        }
      } catch (e) {
        print('Ошибка запроса: $e');
      } finally {
        setnewStatecs(() {
          isLoading = false;
        });
      }
    }else{

    }
  }

}
