import 'package:flutter/material.dart';

class NeedLoginScreen extends StatefulWidget {
  final LoginType type;
  final bool showBackButton; // Новая необязательная переменная
  final VoidCallback showlog;
  NeedLoginScreen({
    required this.type,
    this.showBackButton = true, required this.showlog, // По умолчанию true
  });

  @override
  _NeedLoginScreenState createState() => _NeedLoginScreenState();
}

class _NeedLoginScreenState extends State<NeedLoginScreen> with SingleTickerProviderStateMixin {
  late final Map<String, dynamic> featureDetails;
  bool showContent = false;
  late ScrollController _scrollController;
  late AnimationController _animationController;

  Widget _buildIconicBackground() {
    return AnimatedBuilder(
      animation: Listenable.merge([_scrollController, _animationController]),
      builder: (context, child) {
        double offset = _scrollController.hasClients
            ? _scrollController.offset
            : 0.0;
        return Stack(
          children: [
            // Большие иконки с низкой прозрачностью
            Positioned(
              top: 50 - offset * 0.1,
              left: -30 + offset * 0.05,
              child: Transform.rotate(
                angle: _animationController.value * 0.2,
                child: Icon(
                  Icons.music_note,
                  size: 150,
                  color: Colors.blue.withOpacity(0.1),
                ),
              ),
            ),
            Positioned(
              bottom: 100 + offset * 0.15,
              right: -50 - offset * 0.08,
              child: Transform.scale(
                scale: 1.0 + 0.1 * _animationController.value,
                child: Icon(
                  Icons.headphones,
                  size: 180,
                  color: Colors.pink.withOpacity(0.1),
                ),
              ),
            ),
            Positioned(
              top: 200 - offset * 0.05,
              right: 30 + offset * 0.02,
              child: Transform.translate(
                offset: Offset(0, -10 * _animationController.value),
                child: Icon(
                  Icons.equalizer,
                  size: 120,
                  color: Colors.purple.withOpacity(0.2),
                ),
              ),
            ),
            Positioned(
              bottom: 20 + offset * 0.1,
              left: 60 - offset * 0.03,
              child: Transform.translate(
                offset: Offset(10 * _animationController.value, 0),
                child: Icon(
                  Icons.star,
                  size: 100,
                  color: Colors.orange.withOpacity(0.15),
                ),
              ),
            ),
            // Маленькие иконки для детализации
            for (int i = 0; i < 15; i++)
              Positioned(
                  top: (i * 50).toDouble() - offset * 0.05 * (i % 3 + 1),
                  left: (i * 40) % MediaQuery.of(context).size.width +
                      offset * 0.02 * (i % 2 == 0 ? 1 : -1),
                  child: Transform.scale(
                    scale: 0.8 + 0.2 * (_animationController.value),
                    child: Icon(
                      Icons.circle,
                      size: 20,
                      color: Colors.white.withOpacity(0.05 * (i % 5 + 1)),
                    ),
                  )
              ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    featureDetails = _getFeatureDetails(widget.type);
    Future.delayed(Duration(milliseconds: 300), () {
      setState(() {
        showContent = true;
      });
    });
    _scrollController = ScrollController();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0F0F10),
      body: SafeArea(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            _buildIconicBackground(),
            SingleChildScrollView(
              controller: _scrollController,
              child: Container(
                height: 1000,
                color: Colors.transparent,
              ),
            ),
            if (widget.showBackButton) // Показываем кнопку назад только если showBackButton = true
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 16.0),
                  child: IconButton(
                    icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                Text(
                  'blast!',
                  style: TextStyle(
                    fontSize: 32,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                AnimatedOpacity(
                  opacity: showContent ? 1 : 0,
                  duration: Duration(seconds: 1),
                  curve: Curves.easeInOut,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.blue,
                        child: Icon(
                          featureDetails['icon'] as IconData,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        featureDetails['title'] as String,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        featureDetails['description'] as String,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[400],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: Duration(seconds: 2),
                  curve: Curves.easeOut,
                  builder: (context, value, child) => Transform.translate(
                    offset: Offset(0, 100 * (1 - value)),
                    child: Opacity(
                      opacity: value,
                      child: ElevatedButton(
                        onPressed: () {
                          // Обработчик входа
                          widget.showlog();
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 10),
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Войти',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> _getFeatureDetails(LoginType type) {
    switch (type) {
      case LoginType.likes:
        return {
          'icon': Icons.favorite,
          'title': 'Ставить лайки',
          'description': 'Добавляйте любимые треки в избранное.',
        };
      case LoginType.playlists:
        return {
          'icon': Icons.playlist_add,
          'title': 'Создавать плейлисты',
          'description': 'Собирайте коллекции треков для любого настроения.',
        };
      case LoginType.devices:
        return {
          'icon': Icons.devices,
          'title': 'Управлять устройствами',
          'description': 'Слушайте музыку на любом устройстве.',
        };
      case LoginType.musicTransfer:
        return {
          'icon': Icons.cloud_upload,
          'title': 'Переносить музыку',
          'description': 'Импортируйте музыку из других сервисов.',
        };
      case LoginType.library:
        return {
          'icon': Icons.library_music,
          'title': 'Доступ к библиотеке',
          'description': 'Просматривайте свою музыкальную коллекцию.',
        };
      default:
        return {
          'icon': Icons.music_note,
          'title': 'Получите больше возможностей',
          'description': 'Войдите в приложение и наслаждайтесь музыкой.',
        };
    }
  }
}

enum LoginType {
  likes,
  playlists,
  devices,
  musicTransfer,
  library
}