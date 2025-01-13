import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class RecognitionButton extends StatefulWidget {
  final VoidCallback onTap; // Действие при нажатии
  final IconData icon;
  final bool isRecognizing;
  const RecognitionButton({
    Key? key,
    required this.onTap,
    required this.icon,
    required this.isRecognizing,
  }) : super(key: key);

  @override
  _RecognitionButtonState createState() => _RecognitionButtonState();
}

class _RecognitionButtonState extends State<RecognitionButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          color: widget.isRecognizing ? Colors.green : Colors.blue,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 4),
              blurRadius: 10,
            ),
          ],
        ),
        child: Center(
          child: Icon(
            widget.icon,
            color: Colors.white,
            size: 30,
          ),
        ),
      ),
    );
  }
}


Widget buttonlogin(Function open) {
  return GestureDetector(
    onTap: (){open();},
    child: Container(
      height: 44,
      width: 44,
      decoration: BoxDecoration(
        color: Colors.blue, // Цвет кнопки
        shape: BoxShape.circle, // Круглая форма
      ),
      child: Center(
        child: Icon(
          Icons.login_rounded,
          color: Colors.white,
          size: 24,
        ),
      ),
    ),
  );
}

Widget buttonWithImg(String name, Function sac, BuildContext context, String img) {
  return Container(
    height: 70, // Точная высота всего элемента
    margin: const EdgeInsets.symmetric(vertical: 5), // Отступы
    decoration: BoxDecoration(
      color: const Color.fromARGB(0, 15, 15, 16),
      borderRadius: BorderRadius.circular(6),
    ),
    child: InkWell(
      borderRadius: BorderRadius.circular(6),
      onTap: () => sac(),
      child: Row(
        children: [
          // Картинка
          Container(
            width: 60,
            height: 60,
            margin: const EdgeInsets.all(5), // Внутренние отступы
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
            ),
            clipBehavior: Clip.hardEdge,
            child: Image.asset(
              img,
              fit: BoxFit.cover, // Масштабирование без искажений
            ),
          ),
          // Текст
          Expanded(
            child: Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 16,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w500,
                color: Color.fromARGB(255, 246, 244, 244),
              ),
            ),
          ),
          // Иконка "вправо"
          const Padding(
            padding: EdgeInsets.only(right: 10),
            child: Icon(
              Icons.chevron_right_rounded,
              color: Colors.white,
            ),
          ),
        ],
      ),
    ),
  );
}


