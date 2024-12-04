
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
    if (ds != "") {
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
    var urli = Uri.parse("https://kompot.site/gettopmusic?lim=20&token=1");
    var response = await http.get(urli);
    String dff = response.body.toString();
    List langData = jsonDecode(dff)[0];
    langData = await showStatusInstall(langData);

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

  Future<List> getMusicInPlaylist(String id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? ds = prefs.getString("token");
    print("https://kompot.site/getmusfromplaylist?token="+ds!+"&playlst="+id);
    var urli = Uri.parse("https://kompot.site/getmusfromplaylist?token="+ds!+"&playlst="+id);
    var response = await http.get(urli);
    String dff = response.body.toString();
    List langData = jsonDecode(dff)[0];
    langData = await showStatusInstall(langData);
    return langData;
  }


  Future<List> getPlayLists() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? ds = prefs.getString("token");
    if(ds != "") {
      var urli = Uri.parse("https://kompot.site/getmusicplaylist?tokeni="+ds!);

      var response = await http.get(urli);
      String dff = response.body.toString();
      List langData = jsonDecode(dff)[0];
      langData = await showStatusInstall(langData);
      return langData;
    }else{
      return [];
    }
  }

  Future<List> getSearchHistory() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? sac = prefs.getStringList("historymusid");
    if(sac != null) {
      List langData = [];
      for (var num in sac) {
        var urli = Uri.parse("https://kompot.site/getaboutmus?sidi=" + num);
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
    if(text != '') {
      var urli = Uri.parse("https://kompot.site/getmusshazandr?token=1&nice=" + text);
      var response = await http.get(urli);
      String dff = response.body.toString();
      List langData = jsonDecode(dff);
      langData = await showStatusInstall(langData);
      return langData;
    }else{
      return [];
    }
  }

  Future<List> getVideosTop() async {
    var urli = Uri.parse("https://kompot.site/getvideomus");
    var response = await http.get(urli);
    String dff = response.body.toString();
    List langData = jsonDecode(dff);
    return langData;
  }

}

