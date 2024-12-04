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
    // Запускаем анимацию через небольшую задержку
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _opacity = 1.0; // Плавное появление
        _scale = 1.0; // Увеличение до исходного размера
      });
    });

    // Переход на следующий экран через 3 секунды
    Future.delayed(const Duration(seconds: 3), () {
      getlatloc();
    });
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


              // Анимация текста
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
                      child: Container(
                        padding: const EdgeInsets.only(left: 12, top: 12),
                        child: const Text(
                          "blast!",
                          style: TextStyle(
                            fontSize: 40,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
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
