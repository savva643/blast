import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class WebVersionScreen extends StatelessWidget {
  const WebVersionScreen({Key? key}) : super(key: key);

  Future<void> _launchStore(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _buildDownloadButton(String platform, String iconAsset, String storeUrl, bool needwhite) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        backgroundColor: Colors.blue[800],
        iconColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: () => _launchStore(storeUrl),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          needwhite ? Image.asset(iconAsset, width: 30, height: 30, color: Colors.white,) : Image.asset(iconAsset, width: 24, height: 24,),
          const SizedBox(width: 12),
          Text('Скачать для $platform', style: TextStyle(color: Colors.white),),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: Color(0xFF0F0F10),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 800),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  Text(
                    'Вы используете веб-версию',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Icon(
                    Icons.language,
                    size: 100,
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 40),
                  _buildFeatureTile(
                    Icons.download,
                    'Скачивание треков',
                    'Сохраняйте музыку для прослушивания без интернета',
                  ),
                  _buildFeatureTile(
                    Icons.offline_bolt,
                    'Оффлайн-режим',
                    'Слушайте любимые треки даже без подключения',
                  ),
                  _buildFeatureTile(
                    Icons.phone_android,
                    'Удобство использования',
                    'Оптимизированный интерфейс для вашего устройства',
                  ),
                  const SizedBox(height: 40),
                  Text(
                    'Скачайте приложение для лучшего опыта',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  if (isMobile) ...[
                    // Мобильные платформы
                    _buildDownloadButton(
                      'Android',
                      'assets/images/android.png',
                      'https://play.google.com/store',
                      false
                    ),
                    const SizedBox(height: 16),
                    _buildDownloadButton(
                      'iOS',
                      'assets/images/ios.png',
                      'https://apps.apple.com',
                      true
                    ),
                  ] else ...[
                    // Десктопные платформы
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      alignment: WrapAlignment.center,
                      children: [
                        _buildDownloadButton(
                          'Windows',
                          'assets/images/windows.png',
                          'https://www.microsoft.com/store',
                          true
                        ),
                        _buildDownloadButton(
                          'macOS',
                          'assets/images/macos.png',
                          'https://www.apple.com/macos',
                          true
                        ),
                        _buildDownloadButton(
                          'Linux',
                          'assets/images/linux.png',
                          'https://www.linux.org',
                          false
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 40),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'Продолжить в веб-версии',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureTile(IconData icon, String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 40, color: Colors.blue),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}