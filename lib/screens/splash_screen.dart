import 'dart:async'; // Необходимо для Timer
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 0.0; // Для управления прозрачностью
  double _scale = 0.5; // Для управления масштабом
  List<Color> _lightColors = [
    Color(0xFFF44336), // Красный
    Color(0xFF4CAF50), // Зелёный
    Color(0xFF2196F3), // Синий
    Color(0xFFFFEB3B), // Жёлтый
  ];

  late List<int> _colorIndexes;
  Timer? _garlandTimer; // Таймер для анимации гирлянды

  Future<void> getlatloc() async {
    final prefs = await SharedPreferences.getInstance();
    final tk = prefs.getString('token') ?? "0";
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) =>
        const HomeScreen(),
        transitionDuration: const Duration(seconds: 0),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _colorIndexes = List.generate(4, (_) => 0); // Изначальные индексы цветов

    // Запуск анимации
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _opacity = 1.0; // Плавное появление
        _scale = 1.0; // Увеличение до исходного размера
      });
    });

    // Анимация гирлянды
    _garlandTimer = Timer.periodic(const Duration(milliseconds: 400), (timer) {
      setState(() {
        _colorIndexes = _colorIndexes.map((index) => (index + 1) % _lightColors.length).toList();
      });
    });

    // Переход на следующий экран через 3 секунды
    Future.delayed(const Duration(seconds: 3), () {
      getlatloc();
    });
  }

  @override
  void dispose() {
    _garlandTimer?.cancel(); // Остановка таймера при выходе
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(255, 15, 15, 16),
            Color.fromARGB(255, 15, 15, 16),
          ],
        ),
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                child: Image.asset(
                  'assets/images/circlebg.png',
                  width: 420,
                  height: 420,
                ),
                top: -280,
                left: -196,
              ),

              // Анимация текста с гирляндой
              AnimatedOpacity(
                opacity: _opacity,
                duration: const Duration(seconds: 2),
                curve: Curves.easeIn,
                child: TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0.5, end: _scale),
                  duration: const Duration(seconds: 2),
                  curve: Curves.easeOutBack,
                  builder: (context, double scale, child) {
                    return Transform.scale(
                      scale: scale,
                      child: Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.center,
                        children: [

                          // Мишура
                          Positioned(
                            top: -53,
                            child: Image.asset(
                              'assets/images/tinsel.png',
                              width: 250,
                            ),
                          ),
                          // Текст "blast!"
                      Container(padding: EdgeInsets.only(left: 12,top: 12),
                        child:const Text(
                            "blast!",
                            style: TextStyle(
                              fontSize: 40,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                        )),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


}




