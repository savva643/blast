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
