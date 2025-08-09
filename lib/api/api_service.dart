
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'api_install.dart';
class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  dynamic user = {};

  Future getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? ds = prefs.getString("token");
    if (ds != null && ds != "") {
      if (user['token'] != ds || user == null) {
        print("object" + ds!);
        var urli = Uri.parse("https://kompot.keep-pixel.ru/getabout?token=" + ds);

        var response = await http.get(urli);
        String dff = response.body.toString();

        user = jsonDecode(dff);

        return user;
      }
    }
    return {'status':'false'};
  }

  Future<List> showStatusInstall(List da, {DownloadManager? downloadManager}) async {
    List langData = da;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedIds = prefs.getStringList("installmusid");

    // Получаем активные загрузки, если передан менеджер
    List<DownloadModel> activeDownloads = [];
    if (downloadManager != null) {
      activeDownloads = await downloadManager.getActiveDownloads();
    }

    for (var i = 0; i < langData.length; i++) {
      final track = langData[i] as Map<String, dynamic>;
      final trackId = track["idshaz"];

      // Проверяем активные загрузки
      final isDownloading = activeDownloads.any((d) => d.idshaz == trackId && !d.isCompleted);

      if (isDownloading) {
        // Если трек в процессе загрузки
        track["install"] = "2"; // 2 - статус "в процессе загрузки"
        track["download_progress"] = activeDownloads
            .firstWhere((d) => d.idshaz == trackId && !d.isCompleted)
            .progress;
      } else if (savedIds != null && savedIds.contains(trackId)) {
        // Если трек уже скачан
        track["install"] = "1"; // 1 - статус "скачан"
      } else {
        // Если трек не скачан
        track["install"] = "0"; // 0 - статус "не скачан"
      }
    }

    return langData;
  }


  Future<List> getTopMusic() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? ds = prefs.getString("token");
    Uri urli;
    if(ds != null) {
      if (ds != "") {
        urli = Uri.parse("https://kompot.keep-pixel.ru/gettopmusic?lim=20&token="+ds!);
      } else {
        urli = Uri.parse("https://kompot.keep-pixel.ru/gettopmusic?lim=20");
      }
    }else{
      urli = Uri.parse("https://kompot.keep-pixel.ru/gettopmusic?lim=20");
    }
    var response = await http.get(urli);
    String dff = response.body.toString();
    List langData = jsonDecode(dff)[0];
    langData = await showStatusInstall(langData);
    print(langData);
    return langData;
  }


  Future<List> getInstalledMusic() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? dfrd = prefs.getString("installmus");
    print(jsonDecode(dfrd!));
    List langData = jsonDecode(jsonDecode(dfrd).toString());
    langData = await showStatusInstall(langData);

    return langData;
  }

  Future<List> getMusicInPlaylist(String id, int count) async {
    if(id=="0") {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? ds = prefs.getString("token");
      var urli = Uri.parse("https://kompot.keep-pixel.ru/getlovemus?token=" + ds! + "&count=" + count.toString());
      var response = await http.get(urli);
      String dff = response.body.toString();
      List langData = jsonDecode(dff)[0];
      langData = await showStatusInstall(langData);
      return langData;
    }else{
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? ds = prefs.getString("token");
      print(
          "https://kompot.keep-pixel.ru/getmusfromplaylist?token=" + ds! + "&playlst=" +
              id);
      var urli = Uri.parse(
          "https://kompot.keep-pixel.ru/getmusfromplaylist?token=" + ds! + "&playlst=" +
              id);
      var response = await http.get(urli);
      String dff = response.body.toString();
      List langData = jsonDecode(dff)[0];
      langData = await showStatusInstall(langData);
      return langData;
    }
  }


  Future<List> getPlayLists(int count) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? ds = prefs.getString("token");
    if(ds != null && ds != "") {
      var urli = Uri.parse("https://kompot.keep-pixel.ru/getmusicplaylist?getplaylist="+ds!+"&count"+count.toString());

      var response = await http.get(urli);
      String dff = response.body.toString();
      List langData = jsonDecode(dff)[0];
      langData = await showStatusInstall(langData);
      return langData;
    }else{
      return [];
    }
  }

  Future<List> getAlbum(int count) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? ds = prefs.getString("token");
    if(ds != null && ds != "") {
      var urli = Uri.parse("https://kompot.keep-pixel.ru/getmusicplaylist?getalbum="+ds!+"&count"+count.toString());

      var response = await http.get(urli);
      String dff = response.body.toString();
      List langData = jsonDecode(dff)[0];
      langData = await showStatusInstall(langData);
      return langData;
    }else{
      return [];
    }
  }

  Future<bool> getLoggedAccount() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? ds = prefs.getString("token");
    if(ds != null) {
      if (ds != "") {
        var urli = Uri.parse("https://kompot.keep-pixel.ru/getabout?token=" + ds);
        var response = await http.get(urli);
        String dff = response.body.toString();

        user = jsonDecode(dff);
        if(user["status"]=="true"){
          return true;
        }else{
          return false;
        }
      }else{
        return false;
      }
    }else{
      return false;
    }
  }

  Future<List> getSearchHistory() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? sac = prefs.getStringList("historymusid");

    if (sac != null && sac.isNotEmpty) {
      // Получаем токен (один раз, а не в цикле)
      final String? ds = prefs.getString("token");

      // Формируем строку с ID через запятую
      String ids = sac.join(',');

      // Формируем URL
      String url = "https://kompot.keep-pixel.ru/getaboutmus?sidis=$ids";
      if (ds != null && ds.isNotEmpty) {
        url += "&tokeni=$ds";
      }

      print("Request URL: $url");

      try {
        // Делаем один запрос для всех ID
        var response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          // Парсим ответ (ожидаем массив данных)
          List<dynamic> result = jsonDecode(response.body);

          // Обрабатываем статусы (если нужно)
          result = await showStatusInstall(result);

          return result;
        } else {
          print("Ошибка запроса: ${response.statusCode}");
          return [];
        }
      } catch (e) {
        print("Ошибка: $e");
        return [];
      }
    } else {
      return [];
    }
  }

  Future<List> getSearchMusic(String text) async {
    print("searchikngh "+text);
    if(text != '') {
      var urli = Uri.parse("https://kompot.keep-pixel.ru/getmusshazandr?token=1&nice=" + text);
      var response = await http.get(urli);
      String dff = response.body.toString();
      print("searchikngh"+dff);
      List langData = jsonDecode(dff);
      langData = await showStatusInstall(langData);
      return langData;
    }else{
      return List.empty();
    }
  }

  Future<List> getVideosTop() async {
    var urli = Uri.parse("https://kompot.keep-pixel.ru/getvideomus");
    var response = await http.get(urli);
    String dff = response.body.toString();
    List langData = jsonDecode(dff);
    return langData;
  }

  Future<dynamic> getEssensionRandom() async {
    var urli = Uri.parse("https://kompot.keep-pixel.ru/getesemus");
    var response = await http.get(urli);
    String dff = response.body.toString();
    return jsonDecode(dff);
  }

  Future<String> getJemRandom() async {
    var urli = Uri.parse("https://kompot.keep-pixel.ru/getjemmus");
    var response = await http.get(urli);
    String dff = response.body.toString();
    return dff;
  }


  Future<dynamic> getAboutMusic(String idshaz) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? ds = prefs.getString("token");
    Uri urli;
    if(ds != null) {
      if (ds != "") {
        print("https://kompot.keep-pixel.ru/getaboutmus?sidi=" + idshaz! + "&tokeni=" + ds!);
        urli = Uri.parse(
            "https://kompot.keep-pixel.ru/getaboutmus?sidi=" + idshaz! + "&tokeni=" + ds!);
      } else {
        urli = Uri.parse("https://kompot.keep-pixel.ru/getaboutmus?sidi=" + idshaz!);
      }
    }else{
      urli = Uri.parse("https://kompot.keep-pixel.ru/getaboutmus?sidi=" + idshaz!);
    }
    var response = await http.get(urli);
    String dff = response.body.toString();
    return jsonDecode(dff);
  }


  Future<Map<String, dynamic>> getSimilarTracks({
    required String currentTrackId,
    required int count,
    List<String> playedIds = const [],
    String? token,
  }) async {
    final String baseUrl = "https://kompot.keep-pixel.ru/nextmus";
    final Map<String, String> queryParams = {
      'nice': currentTrackId,
      'count': count.toString(),
      if (playedIds.isNotEmpty) 'playedIds': playedIds.join(','),
      if (token != null && token.isNotEmpty) 'tokan': token,
    };

    final Uri uri = Uri.parse(baseUrl).replace(queryParameters: queryParams);
    print("Request URL: ${uri.toString()}");

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return {
          'downloadedTracks': List<String>.from(data['downloadedTracks'] ?? []),
          'playedIds': List<String>.from(data['playedIds'] ?? []),
        };
      } else {
        throw Exception('Failed to load similar tracks: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching similar tracks: $e');
      throw Exception('Failed to load similar tracks');
    }
  }


  Future<String> setMusicReaction(String id, int type) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? ds = prefs.getString("token");
    if(ds != "") {
      final response = await http.get(Uri.parse(
          'https://kompot.keep-pixel.ru/reactmusic?mus=' +id + '&type=' + type.toString() + "&token="+ds!));
      if (response.statusCode == 200) {
        // Успешный ответ, меняем состояние лайка
        String dff = response.body.toString();
        var _fdsb = jsonDecode(dff);

        if (_fdsb['status'].toString() == "true") {
          return _fdsb['type'].toString();
        }else{
          return "3";
        }
      }else{
        return "3";
      }
    }else{
      return "3";
    }
  }



  Future<String> installMusic(String idshaz) async {
    var urli = Uri.parse("https://kompot.keep-pixel.ru/installmusapple?nice=" + idshaz);
    var response = await http.get(urli);
    String dff = response.body.toString();
    print("dvsxv"+dff);
    return dff;
  }

  Future<bool> toLogin(String login, String password, bool isRemember) async {
    if(login != '' && password != '') {
      var urli = Uri.parse(
          "https://kompot.keep-pixel.ru/anlog?login="+login+"&password=" + password);

      var response = await http.get(urli);
      String dff = response.body.toString();

      var langData = jsonDecode(dff);
      print(langData);
      if(langData['status'] == "true"){
        if(isRemember) {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString("token", langData['token']);
        } else {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          // Сохраняем токен, но ставим флаг для выхода при перезапуске
          await prefs.setString("token", langData['token']);
          await prefs.setBool("logout_on_restart", true);
        }
        print("gkjhjk"+langData['token']);
        return true;
      }else{
        return false;
      }
    }else{
      return false;
    }
  }

  Future<bool> toRegister(String login, String nick, String email, String password, bool isRemember) async {
    if(login != '' && password != '') {
      var urli = Uri.parse(
          "https://kompot.keep-pixel.ru/anlog?login="+login+"&password=" + password);

      var response = await http.get(urli);
      String dff = response.body.toString();

      var langData = jsonDecode(dff);
      print(langData);
      if(langData['status'] == "true"){
        if(isRemember) {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString("token", langData['token']);
        }else {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          // Сохраняем токен, но ставим флаг для выхода при перезапуске
          await prefs.setString("token", langData['token']);
          await prefs.setBool("logout_on_restart", true);
        }
        print("gkjhjk"+langData['token']);
        return true;
      }else{
        return false;
      }
    }else{
      return false;
    }
  }

}

