import 'dart:convert';
import 'dart:io';

import 'package:blast/api/api_share.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/api_install.dart';
import '../screens/need_install_app.dart';
import 'bottomsheet_music_info.dart';
import 'bottomsheet_text_music.dart';

void showTrackOptionsBottomSheet(BuildContext context, dynamic listok) {
  final downloadManager = Provider.of<DownloadManager>(context, listen: false);

  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
    backgroundColor: Colors.black87,
    isScrollControlled: true,
    builder: (context) {
      return StreamBuilder<List<DownloadModel>>(
          stream: downloadManager.downloadStream,
          builder: (context, snapshot) {
            final activeDownloads = snapshot.data ?? [];
            final isDownloading = activeDownloads.any((d) => d.id == listok['id'] && !d.isCompleted);
            final isDownloaded = listok['install'] == "1";

            return DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.45,
              minChildSize: 0.45,
              maxChildSize: 0.9,
              builder: (context, scrollController) {
                return _buildBottomSheetContent(
                    context,
                    listok,
                    scrollController,
                    isDownloading,
                    isDownloaded,
                    downloadManager
                );
              },
            );
          }
      );
    },
  );
}

Widget _buildBottomSheetContent(
    BuildContext context,
    dynamic listok,
    ScrollController scrollController,
    bool isDownloading,
    bool isDownloaded,
    DownloadManager downloadManager
    ) {
  final artists = listok['message'] is List ? listok['message'] : [listok['message']];
  final artistImages = listok['messageimg'] is List ? listok['messageimg'] : [listok['messageimg']];
  final albumName = listok['album_name'] ?? 'Неизвестный альбом';

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Верхняя палка для захвата
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Center(
          child: Container(
            width: 40,
            height: 6,
            decoration: BoxDecoration(
              color: Colors.grey[700],
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),

      // Фиксированная верхняя часть
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    listok["img"],
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        listok["name"],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        albumName,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  ),
                ),
              ],
            ),

            // Список артистов
            const SizedBox(height: 12),
            Text(
              'Артисты',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: artists.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Переход к артисту: ${artists[index]}')),
                        );
                      },
                      borderRadius: BorderRadius.circular(30),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundImage: NetworkImage(
                              artistImages[index] ?? 'https://via.placeholder.com/150',
                            ),
                            child: artistImages[index] == null
                                ? const Icon(Icons.person, color: Colors.white)
                                : null,
                          ),
                          const SizedBox(width: 4),
                          SizedBox(
                            width: 200,
                            child: Text(
                              artists[index],
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      const Divider(color: Colors.grey, thickness: 0.5, indent: 16, endIndent: 16),

      // Прокручиваемая часть с кнопками
      Expanded(
        child: ListView(
          controller: scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          children: _buildRoundedButtons(context, listok, isDownloading, isDownloaded, downloadManager),
        ),
      ),
    ],
  );
}

List<Widget> _buildRoundedButtons(
    BuildContext context,
    dynamic listok,
    bool isDownloading,
    bool isDownloaded,
    DownloadManager downloadManager
    ) {
  List<Map<String, dynamic>> options = [];

  if(listok['txt'] != "0") {
    options = [
      {"icon": Icons.radio_button_checked, "label": "Джем по песне"},
      {"icon": Icons.stars, "label": "Эссенция по песне"},
      {
        "icon": isDownloading ? Icons.cancel : isDownloaded ? Icons.delete : Icons.download,
        "label": isDownloading ? "Отменить загрузку" : isDownloaded ? "Удалить" : "Скачать",
        "type": "install"
      },
      {"icon": Icons.playlist_add, "label": "Добавить в плейлист"},
      {"icon": Icons.lyrics, "label": "Показать текст песни", "type": "text"},
      {"icon": Icons.share, "label": "Поделиться", "type": "share"},
      {"icon": Icons.cast, "label": "Транслировать на"},
      {"icon": Icons.album, "label": "Перейти к альбому"},
      {"icon": Icons.info, "label": "О треке", "type": "about"},
    ];
  } else {
    options = [
      {"icon": Icons.radio_button_checked, "label": "Джем по песне"},
      {"icon": Icons.stars, "label": "Эссенция по песне"},
      {
        "icon": isDownloading ? Icons.cancel : isDownloaded ? Icons.delete : Icons.download,
        "label": isDownloading ? "Отменить загрузку" : isDownloaded ? "Удалить" : "Скачать",
        "type": "install"
      },
      {"icon": Icons.playlist_add, "label": "Добавить в плейлист"},
      {"icon": Icons.share, "label": "Поделиться", "type": "share"},
      {"icon": Icons.cast, "label": "Транслировать на"},
      {"icon": Icons.album, "label": "Перейти к альбому"},
      {"icon": Icons.info, "label": "О треке", "type": "about"},
    ];
  }

  return options.map((option) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.white.withOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        ),
        onPressed: () async {
          Navigator.pop(context);

          if(option["type"] == "share") {
            shareContent('music', listok["idshaz"]);
          } else if(option["type"] == "about") {
            showTrackInfoBottomSheet(context, listok);
          } else if(option["type"] == "text") {
            showLyricsBottomSheet(context, listok['txt'].toString(), listok['name'].toString());
          } else if(option["type"] == "install") {
            if (kIsWeb) {
              // Откладываем навигацию до следующего кадра
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => WebVersionScreen(),
                  ),
                );
              });
              return; // Прекращаем дальнейшую инициализацию
            }else {
              if (isDownloading) {
                // Отмена загрузки
                downloadManager.cancelDownload(listok['id']);
              } else if (isDownloaded) {
                // Удаление трека
                await _deleteDownloadedTrack(context, listok);
              } else {
                // Начало загрузки
                final downloadModel = DownloadModel(
                  id: listok['id'],
                  idshaz: listok['idshaz'],
                  name: listok['name'],
                  url: listok['short'],
                  // URL для скачивания
                  img: listok['img'],
                  message: listok['message'],
                  txt: listok['txt'],
                  messageimg: listok['messageimg'],
                  short: listok['short'],
                  vidos: listok['vidos'],
                  bgvideo: listok['bgvideo'],
                  elir: listok['elir'],
                );
                downloadManager.addToQueue(downloadModel);
              }
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Скоро добавим функцию: ${option["label"]}')),
            );
          }
        },
        child: Row(
          children: [
            Icon(
              option["icon"],
              color: option["type"] == "install" && isDownloading
                  ? Colors.red
                  : option["type"] == "install" && isDownloaded
                  ? Colors.orange
                  : Colors.white,
              size: 28,
            ),
            const SizedBox(width: 16),
            Text(
              option["label"],
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: option["type"] == "install" && isDownloading
                    ? Colors.red
                    : option["type"] == "install" && isDownloaded
                    ? Colors.orange
                    : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }).toList();
}

Future<void> _deleteDownloadedTrack(BuildContext context, dynamic track) async {
  final prefs = await SharedPreferences.getInstance();
  final savedTracks = prefs.getStringList('downloaded_tracks') ?? [];

  // Удаляем из SharedPreferences
  savedTracks.removeWhere((item) {
    final json = jsonDecode(item);
    return json['id'] == track['id'];
  });

  // Удаляем файл
  try {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/${track['id']}.mp3');
    if (await file.exists()) {
      await file.delete();
    }
  } catch (e) {
    print('Ошибка при удалении файла: $e');
  }

  // Обновляем состояние
  track['install'] = "0";

  await prefs.setStringList('downloaded_tracks', savedTracks);

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Трек "${track['name']}" удален')),
  );
}