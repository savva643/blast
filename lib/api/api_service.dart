
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
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
        var urli = Uri.parse("https://kompot.site/getabout?token=" + ds);

        var response = await http.get(urli);
        String dff = response.body.toString();

        user = jsonDecode(dff);

        return user;
      }
    }
    return {'status':'false'};
  }

  Future<List> showStatusInstall(List da) async {
    List langData = da;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? sac = prefs.getStringList("installmusid");
    for (var i = 0; i < langData.length; i++) {
      if (sac != null) {
        if (!sac.isEmpty) {
          if (sac.contains(langData[i]["idshaz"])) {
            (langData[i] as Map<String, dynamic>)["install"] = "1";
          } else {
            (langData[i] as Map<String, dynamic>)["install"] = "0";
          }
        } else {
          (langData[i] as Map<String, dynamic>)["install"] = "0";
        }
      } else {
        (langData[i] as Map<String, dynamic>)["install"] = "0";
      }
    }
    return da;
  }


  Future<List> getTopMusic() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? ds = prefs.getString("token");
    Uri urli;
    if(ds != null) {
      if (ds != "") {
        urli = Uri.parse("https://kompot.site/gettopmusic?lim=20&token="+ds!);
      } else {
        urli = Uri.parse("https://kompot.site/gettopmusic?lim=20");
      }
    }else{
      urli = Uri.parse("https://kompot.site/gettopmusic?lim=20");
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
      var urli = Uri.parse("https://kompot.site/getlovemus?token=" + ds! + "&count=" + count.toString());
      var response = await http.get(urli);
      String dff = response.body.toString();
      List langData = jsonDecode(dff)[0];
      langData = await showStatusInstall(langData);
      return langData;
    }else{
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? ds = prefs.getString("token");
      print(
          "https://kompot.site/getmusfromplaylist?token=" + ds! + "&playlst=" +
              id);
      var urli = Uri.parse(
          "https://kompot.site/getmusfromplaylist?token=" + ds! + "&playlst=" +
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
      var urli = Uri.parse("https://kompot.site/getmusicplaylist?getplaylist="+ds!+"&count"+count.toString());

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
      var urli = Uri.parse("https://kompot.site/getmusicplaylist?getalbum="+ds!+"&count"+count.toString());

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
        var urli = Uri.parse("https://kompot.site/getabout?token=" + ds);
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
    if(sac != null) {
      List langData = [];
      for (var num in sac) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        String? ds = prefs.getString("token");
        Uri urli;
        if(ds != null) {
          if (ds != "") {
            print("https://kompot.site/getaboutmus?sidi=" + num! + "&tokeni=" + ds!);
            urli = Uri.parse(
                "https://kompot.site/getaboutmus?sidi=" + num! + "&tokeni=" + ds!);
          } else {
            urli = Uri.parse("https://kompot.site/getaboutmus?sidi=" + num!);
          }
        }else{
          urli = Uri.parse("https://kompot.site/getaboutmus?sidi=" + num!);
        }
        var response = await http.get(urli);
        String dff = response.body.toString();
        print("jhghjg");
        print(dff);
        try {
          langData.add(jsonDecode(dff));
        }catch (e) {
          print("Ошибка: $e");
        }
      }
      langData = await showStatusInstall(langData);
      return langData;
    }else{
      return [];
    }
  }

  Future<List> getSearchMusic(String text) async {
    print("searchikngh "+text);
    if(text != '') {
      var urli = Uri.parse("https://kompot.site/getmusshazandr?token=1&nice=" + text);
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
    var urli = Uri.parse("https://kompot.site/getvideomus");
    var response = await http.get(urli);
    String dff = response.body.toString();
    List langData = jsonDecode(dff);
    return langData;
  }

  Future<dynamic> getEssensionRandom() async {
    var urli = Uri.parse("https://kompot.site/getesemus");
    var response = await http.get(urli);
    String dff = response.body.toString();
    return jsonDecode(dff);
  }

  Future<String> getJemRandom() async {
    var urli = Uri.parse("https://kompot.site/getjemmus");
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
        print("https://kompot.site/getaboutmus?sidi=" + idshaz! + "&tokeni=" + ds!);
        urli = Uri.parse(
            "https://kompot.site/getaboutmus?sidi=" + idshaz! + "&tokeni=" + ds!);
      } else {
        urli = Uri.parse("https://kompot.site/getaboutmus?sidi=" + idshaz!);
      }
    }else{
      urli = Uri.parse("https://kompot.site/getaboutmus?sidi=" + idshaz!);
    }
    var response = await http.get(urli);
    String dff = response.body.toString();
    return jsonDecode(dff);
  }


  Future<String> setMusicReaction(String id, int type) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? ds = prefs.getString("token");
    if(ds != "") {
      final response = await http.get(Uri.parse(
          'https://kompot.site/reactmusic?mus=' +id + '&type=' + type.toString() + "&token="+ds!));
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
    var urli = Uri.parse("https://kompot.site/installmusapple?nice=" + idshaz);
    var response = await http.get(urli);
    String dff = response.body.toString();
    print("dvsxv"+dff);
    return dff;
  }



}

