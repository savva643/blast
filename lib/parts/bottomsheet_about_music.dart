import 'package:flutter/material.dart';

void showTrackOptionsBottomSheet(BuildContext context, dynamic listok) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    backgroundColor: Colors.black87,
    isScrollControlled: true, // Позволяет растягивать на весь экран
    builder: (context) {
      return DraggableScrollableSheet(
        expand: false, // Не открывается сразу на весь экран
        initialChildSize: 0.4, // Начальный размер (40% от экрана)
        minChildSize: 0.4, // Минимальный размер
        maxChildSize: 0.9, // Максимальный размер (90% экрана)
        builder: (context, scrollController) {
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
              // Фиксированная верхняя часть с обложкой, названием и автором
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        listok["img"],
                        width: 64,
                        height: 64,
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
                          ),
                          const SizedBox(height: 4),
                          Text(
                            listok["message"],
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
              ),
              const Divider(color: Colors.grey, thickness: 0.5),
              // Прокручиваемая часть с кнопками
              Expanded(
                child: ListView(
                  controller: scrollController, // Контроллер для прокрутки
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  children: _buildRoundedButtons(context),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}

// Построение закругленных и увеличенных кнопок
List<Widget> _buildRoundedButtons(BuildContext context) {
  final List<Map<String, dynamic>> options = [
    {"icon": Icons.radio_button_checked, "label": "Джем по песне"},
    {"icon": Icons.stars, "label": "Эссенция песни"},
    {"icon": Icons.download, "label": "Скачать"},
    {"icon": Icons.playlist_add, "label": "Добавить в плейлист"},
    {"icon": Icons.lyrics, "label": "Показать текст песни"},
    {"icon": Icons.share, "label": "Поделиться"},
    {"icon": Icons.cast, "label": "Транслировать на"},
    {"icon": Icons.person, "label": "Перейти к артисту"},
    {"icon": Icons.album, "label": "Перейти к альбому"},
    {"icon": Icons.info, "label": "О треке"},
  ];

  return options.map((option) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.white.withOpacity(0.1), // Цвет текста
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // Закругление кнопки
          ),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16), // Увеличенная высота кнопки
        ),
        onPressed: () {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Вы выбрали: ${option["label"]}')),
          );
        },
        child: Row(
          children: [
            Icon(option["icon"], color: Colors.white, size: 28), // Увеличенный размер иконки
            const SizedBox(width: 16),
            Text(
              option["label"],
              style: const TextStyle(
                fontSize: 18, // Увеличенный размер текста
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }).toList();
}
