import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen>
    with SingleTickerProviderStateMixin {
  late MobileScannerController controller;
  late AnimationController _animationController;
  bool _hasError = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      facing: CameraFacing.back,
      torchEnabled: false,
    );
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Основной сканер
          Positioned.fill(
            child: MobileScanner(
              controller: controller,
              fit: BoxFit.cover,
              onDetect: (capture) {
                final List<Barcode> barcodes = capture.barcodes;
                if (barcodes.isNotEmpty) {
                  final String? code = barcodes.first.rawValue;
                  if (code != null && code.startsWith('blast://')) {
                    Navigator.pop(context, code.substring(8));
                  } else {
                    setState(() => _hasError = true);
                    Future.delayed(const Duration(seconds: 2), () {
                      if (mounted) setState(() => _hasError = false);
                    });
                  }
                }
              },
            ),
          ),

          // Затемнение по краям
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 0.9,
                  colors: [
                    Colors.black.withOpacity(0.1),
                    Colors.black.withOpacity(0.9),
                  ],
                  stops: const [0.1, 0.5],
                ),
              ),
            ),
          ),

          // Анимированная рамка сканера
          Center(
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return CustomPaint(
                  painter: _ScannerBorderPainter(
                    progress: _animationController.value,
                    color: _hasError ? Colors.red : Colors.blueAccent,
                  ),
                  size: const Size(250, 250),
                );
              },
            ),
          ),

          // Анимированная линия сканирования
          Center(
            child: Container(
              height: 250,
              width: 250,
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return CustomPaint(
                    painter: _ScannerLinePainter(
                      position: _animationController.value,
                      color: _hasError ? Colors.red : Colors.blueAccent,
                    ),
                  );
                },
              ),
            ),
          ),

          // Инструкция
          const Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 100),
              child: Text(
                'Наведите камеру на QR-код',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          // Кнопка закрытия
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            right: 16,
            child: FloatingActionButton(
              backgroundColor: Colors.black54,
              mini: true,
              onPressed: () => Navigator.pop(context),
              child: const Icon(Icons.close, color: Colors.white),
            ),
          ),

          // Индикатор ошибки
          if (_hasError)
            const Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(top: 100),
                child: Text(
                  'Неверный QR-код',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// Классы _ScannerBorderPainter и _ScannerLinePainter остаются без изменений

class _ScannerBorderPainter extends CustomPainter {
  final double progress;
  final Color color;

  _ScannerBorderPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    final borderLength = 20.0;
    final cornerLength = 30.0 * (0.5 + 0.5 * sin(progress * 2 * pi));

    // Левый верхний угол
    canvas.drawLine(
      Offset(0, cornerLength),
      Offset(0, 0),
      paint,
    );
    canvas.drawLine(
      Offset(0, 0),
      Offset(cornerLength, 0),
      paint,
    );

    // Правый верхний угол
    canvas.drawLine(
      Offset(size.width - cornerLength, 0),
      Offset(size.width, 0),
      paint,
    );
    canvas.drawLine(
      Offset(size.width, 0),
      Offset(size.width, cornerLength),
      paint,
    );

    // Правый нижний угол
    canvas.drawLine(
      Offset(size.width, size.height - cornerLength),
      Offset(size.width, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(size.width, size.height),
      Offset(size.width - cornerLength, size.height),
      paint,
    );

    // Левый нижний угол
    canvas.drawLine(
      Offset(cornerLength, size.height),
      Offset(0, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(0, size.height),
      Offset(0, size.height - cornerLength),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _ScannerBorderPainter oldDelegate) {
    return progress != oldDelegate.progress || color != oldDelegate.color;
  }
}

class _ScannerLinePainter extends CustomPainter {
  final double position;
  final Color color;

  _ScannerLinePainter({required this.position, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final lineHeight = 10.0;
    final lineY = position * (size.height - lineHeight);

    final paint = Paint()
      ..color = color.withOpacity(0.6)
      ..style = PaintingStyle.fill;

    final shadowPaint = Paint()
      ..color = color.withOpacity(0.2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    // Рисуем тень
    canvas.drawRect(
      Rect.fromLTWH(20, lineY, size.width - 40, lineHeight),
      shadowPaint,
    );

    // Рисуем саму линию
    canvas.drawRect(
      Rect.fromLTWH(30, lineY, size.width - 60, lineHeight),
      paint,
    );

    // Добавляем градиент к линии
    final gradient = LinearGradient(
      colors: [
        color.withOpacity(0),
        color,
        color.withOpacity(0),
      ],
      stops: const [0.0, 0.5, 1.0],
    );

    final gradientPaint = Paint()
      ..shader = gradient.createShader(
        Rect.fromLTWH(30, lineY, size.width - 60, lineHeight),
      );

    canvas.drawRect(
      Rect.fromLTWH(30, lineY, size.width - 60, lineHeight),
      gradientPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _ScannerLinePainter oldDelegate) {
    return position != oldDelegate.position || color != oldDelegate.color;
  }
}