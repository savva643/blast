import 'package:flutter/material.dart';

void showTrackInfoBottomSheet(BuildContext context, dynamic trackInfo) {
  // Подготовка данных
  final artists = trackInfo['message'] is List ? trackInfo['message'] : [trackInfo['message']];
  final artistImages = trackInfo['messageimg'] is List ? trackInfo['messageimg'] : [trackInfo['messageimg']];
  final releaseDate = trackInfo['release_date'] ?? 'Дата неизвестна';
  final duration = trackInfo['duration'] != null
      ? '${(trackInfo['duration'] / 60).floor()}:${(trackInfo['duration'] % 60).toString().padLeft(2, '0')}'
      : '--:--';
  final albumName = trackInfo['album_name'] ?? 'Неизвестный альбом';
  final genre = trackInfo['genre'] ?? 'Жанр не указан';

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.black87,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) {
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        builder: (context, scrollController) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Хэндл для перетаскивания
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
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

              // Фиксированная верхняя часть с обложкой и информацией
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Обложка трека
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            trackInfo["img"] ?? 'https://via.placeholder.com/150',
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: 80,
                              height: 80,
                              color: Colors.grey[800],
                              child: const Icon(Icons.music_note, color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                trackInfo['name'] ?? 'Без названия',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                albumName,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    // Горизонтальный список артистов
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




              // Дополнительная информация (прокручиваемая)
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  children: [
                    _buildInfoRow(Icons.album_outlined, 'Альбом', albumName),
                    _buildInfoRow(Icons.calendar_today_outlined, 'Дата выхода', releaseDate),
                    _buildInfoRow(Icons.timer_outlined, 'Длительность', duration),
                    _buildInfoRow(Icons.music_note_outlined, 'Жанр', genre),
                   

                    const Divider(color: Colors.grey, thickness: 0.5, indent: 16, endIndent: 16),
                    const Text(
                      'О треке',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      trackInfo['description'] ?? 'Описание отсутствует',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    if (trackInfo['lyrics'] != null) ...[
                      const SizedBox(height: 24),
                      const Text(
                        'Текст песни',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        trackInfo['lyrics'],
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          );
        },
      );
    },
  );
}

Widget _buildInfoRow(IconData icon, String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      children: [
        Icon(icon, color: Colors.grey, size: 24),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _buildActionButton(BuildContext context, IconData icon, String label, Color color) {
  return Column(
    children: [
      Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color),
      ),
      const SizedBox(height: 4),
      Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: color,
        ),
      ),
    ],
  );
}
