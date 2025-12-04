import 'package:blast/screens/settings/qrscanner_screen.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ConnectedDevicesScreen extends StatefulWidget {
  const ConnectedDevicesScreen({super.key});

  @override
  State<ConnectedDevicesScreen> createState() => _ConnectedDevicesScreenState();
}

class _ConnectedDevicesScreenState extends State<ConnectedDevicesScreen> {
  MobileScannerController cameraController = MobileScannerController();
  bool isScanning = false;
  String? lastScannedHash;

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F10),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F0F10),
        title: const Text(
          'Подключенные устройства',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.qr_code, color: Colors.white),
              label: const Text('Войти по QR-коду', style: TextStyle(color: Colors.white)),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const QRScannerScreen()),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
            if (lastScannedHash != null) ...[
              const SizedBox(height: 20),
              Text(
                'Последний отсканированный код:',
                style: TextStyle(color: Colors.grey.shade300),
              ),
              Text(
                lastScannedHash!,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
            const SizedBox(height: 20),
            const Text(
              'Текущие устройства',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: 3,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.phone_android, color: Colors.white),
                    title: Text(
                      'Устройство ${index + 1}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: const Text(
                      'Последний вход: сегодня',
                      style: TextStyle(color: Colors.grey),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.logout, color: Colors.red),
                      onPressed: () {},
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showQRScanner(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black,
      isScrollControlled: true,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.8,
        child: Stack(
          children: [
            MobileScanner(
              controller: cameraController,
              onDetect: (capture) {
                final List<Barcode> barcodes = capture.barcodes;
                for (final barcode in barcodes) {
                  if (barcode.rawValue != null) {
                    _processScannedCode(barcode.rawValue!);
                    Navigator.pop(context);
                    break;
                  }
                }
              },
            ),
            Positioned(
              top: 20,
              right: 20,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 32),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: ShapeDecoration(
                  shape: _ScannerOverlayShape(
                    borderColor: Colors.blue.shade400,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _processScannedCode(String rawValue) {
    if (rawValue.startsWith('blast://')) {
      final hash = rawValue.substring(8); // Извлекаем часть после blast://
      setState(() {
        lastScannedHash = hash;
      });

      // Здесь можно добавить логику обработки hash
      // Например, отправить на сервер для подтверждения устройства
      _showSuccessDialog(hash);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Неверный QR-код: $rawValue'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showSuccessDialog(String hash) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text(
          'Устройство подключено',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Код авторизации: $hash\n\nУстройство успешно добавлено в ваш аккаунт.',
          style: const TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }
}

class _ScannerOverlayShape extends ShapeBorder {
  final Color borderColor;

  const _ScannerOverlayShape({required this.borderColor});

  @override
  EdgeInsetsGeometry get dimensions => const EdgeInsets.all(0);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) => Path();

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return Path()..addRect(rect);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    const width = 240.0;
    const height = 240.0;
    final centerX = rect.center.dx;
    final centerY = rect.center.dy - 50;
    final scanRect = Rect.fromCenter(
      center: Offset(centerX, centerY),
      width: width,
      height: height,
    );

    final backgroundPaint = Paint()..color = Colors.black.withOpacity(0.6);
    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    // Рисуем затемненный фон
    canvas.drawRect(rect, backgroundPaint);
    // Оставляем прозрачное окно для сканирования
    canvas.drawRect(
      scanRect,
      Paint()..blendMode = BlendMode.clear,
    );
    // Рисуем рамку сканера
    canvas.drawRect(scanRect, borderPaint);
  }

  @override
  ShapeBorder scale(double t) => this;
}