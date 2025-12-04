import 'dart:ui';

import 'package:blast/providers/list_manager_provider.dart';
import 'package:blast/providers/queue_manager_provider.dart';
import 'package:blast/screens/AudioManager.dart';
import 'package:blast/screens/splash_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:provider/provider.dart';
import 'package:audio_session/audio_session.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api/api_install.dart';
// import 'package:smtc_windows/smtc_windows.dart';


Future<void> checkAuthOnStart() async {
  final prefs = await SharedPreferences.getInstance();

  // Если стоит флаг "выйти при перезапуске"
  if (prefs.getBool('logout_on_restart') == true) {
    await prefs.remove('token'); // Удаляем токен
    await prefs.remove('logout_on_restart'); // Удаляем флаг
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  //await SMTCWindows.initialize(); // для винды
  final listManager = ListManagerProvider();
  await listManager.loadData();
  final queueManager = QueueManagerProvider();
  await queueManager.loadFromCache();
  MediaKit.ensureInitialized();
  await checkAuthOnStart();
  runApp(
      MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => DownloadManager()),
            ChangeNotifierProvider(create: (_) => listManager),
            ChangeNotifierProvider(create: (_) => queueManager),
            ChangeNotifierProvider(create: (_) => AudioManager())
          ],
  child: EasyLocalization(
    supportedLocales: [
      Locale('en', 'US'),
      Locale('ru', 'RU')
    ],
    path: 'assets/translations',
    saveLocale: true,
    fallbackLocale: Locale('en', 'US'),
    child: MyApp(),
  )));
}

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
  };
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: AppScrollBehavior(),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      color: Color.fromARGB(255, 15, 15, 16),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
