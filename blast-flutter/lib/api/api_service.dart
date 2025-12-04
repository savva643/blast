
import 'dart:convert';
import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart' show TargetPlatform, defaultTargetPlatform, kIsWeb;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'api_install.dart';

const String _apiBase = 'https://bladt.keep-pixel.ru';
const String _authBase = 'https://auth.keep-pixel.ru/api/auth';

enum AuthStatus { success, requiresTwoFactor, failure }
class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  dynamic user = {};
  final Random _random = Random();
  String? _cachedUserToken;
  String? _pendingTwoFactorGlobalId;

  Future<String> _ensureDeviceFingerprint() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? fingerprint = prefs.getString("device_fingerprint");
    if (fingerprint == null || fingerprint.isEmpty) {
      fingerprint =
          "blast-${DateTime.now().millisecondsSinceEpoch}-${_random.nextInt(1 << 32)}";
      await prefs.setString("device_fingerprint", fingerprint);
    }
    return fingerprint;
  }

  String _resolvePlatform() {
    if (kIsWeb) return "web";
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return "android";
      case TargetPlatform.iOS:
        return "ios";
      case TargetPlatform.macOS:
        return "macos";
      case TargetPlatform.windows:
        return "windows";
      case TargetPlatform.linux:
        return "linux";
      case TargetPlatform.fuchsia:
        return "fuchsia";
    }
  }

  String _resolveDeviceType() {
    final platform = _resolvePlatform();
    if (platform == "android" || platform == "ios") {
      return "mobile";
    }
    if (platform == "web") {
      return "web";
    }
    return "desktop";
  }

  Map<String, String> _deviceHeaders(String fingerprint) {
    return {
      "device-fingerprint": fingerprint,
      "platform": _resolvePlatform(),
      "device-type": _resolveDeviceType(),
      "app-version": "blast-alpha"
    };
  }

  Future<Map<String, String>> _authRequestHeaders() async {
    final fingerprint = await _ensureDeviceFingerprint();
    return {
      "Content-Type": "application/json",
      ..._deviceHeaders(fingerprint),
    };
  }

  Future<bool> _refreshIfNeeded() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final refreshToken = prefs.getString("refresh_token");
    if (refreshToken == null || refreshToken.isEmpty) {
      return false;
    }

    final headers = await _authRequestHeaders();
    final uri = Uri.parse("$_authBase/refresh");
    final response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode({"refreshToken": refreshToken}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await _applyAuthPayload(data, true);
      return true;
    } else {
      // невалидный refresh — чистим локальные токены
      await prefs.remove("token");
      await prefs.remove("refresh_token");
      _cachedUserToken = null;
      return false;
    }
  }

  Future<http.Response> _authorizedGet(
    Uri uri, {
    bool requireAuth = false,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    if (requireAuth && (token == null || token.isEmpty)) {
      return http.Response('Unauthorized', 401);
    }

    Map<String, String> headers = {};
    if (token != null && token.isNotEmpty) {
      headers["Authorization"] = "Bearer $token";
    }

    var response = await http.get(uri, headers: headers);
    if (response.statusCode == 401 && await _refreshIfNeeded()) {
      token = prefs.getString("token");
      headers = {};
      if (token != null && token.isNotEmpty) {
        headers["Authorization"] = "Bearer $token";
      }
      response = await http.get(uri, headers: headers);
    }

    return response;
  }

  Future<http.Response> _authorizedPost(
    Uri uri, {
    Map<String, String>? extraHeaders,
    Object? body,
    bool requireAuth = true,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    if (requireAuth && (token == null || token.isEmpty)) {
      return http.Response('Unauthorized', 401);
    }

    Map<String, String> headers = {};
    if (token != null && token.isNotEmpty) {
      headers["Authorization"] = "Bearer $token";
    }
    if (extraHeaders != null) {
      headers.addAll(extraHeaders);
    }

    var response = await http.post(uri, headers: headers, body: body);
    if (response.statusCode == 401 && await _refreshIfNeeded()) {
      token = prefs.getString("token");
      headers = {};
      if (token != null && token.isNotEmpty) {
        headers["Authorization"] = "Bearer $token";
      }
      if (extraHeaders != null) {
        headers.addAll(extraHeaders);
      }
      response = await http.post(uri, headers: headers, body: body);
    }

    return response;
  }

  Future<void> _persistTokens({
    required String token,
    required String refreshToken,
    required bool rememberUser,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("token", token);
    await prefs.setString("refresh_token", refreshToken);
    _cachedUserToken = token;
    if (rememberUser) {
      await prefs.remove("logout_on_restart");
    } else {
      await prefs.setBool("logout_on_restart", true);
    }
  }

  Future<void> _applyAuthPayload(Map<String, dynamic> data, bool rememberUser) async {
    final token = data['token']?.toString();
    final refreshToken = data['refreshToken']?.toString() ?? '';
    if (token != null && refreshToken.isNotEmpty) {
      await _persistTokens(
        token: token,
        refreshToken: refreshToken,
        rememberUser: rememberUser,
      );
    }
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (data['globalId'] != null) {
      await prefs.setString("necsoura_global_id", data['globalId'].toString());
    }
    if (data['login'] != null) {
      await prefs.setString("necsoura_login", data['login'].toString());
    }
  }

  Future<void> saveNecsouraSession(Map<String, dynamic> data, {bool rememberUser = true}) async {
    await _applyAuthPayload(data, rememberUser);
  }

  Future<void> _dropSession() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("token");
    await prefs.remove("refresh_token");
    _cachedUserToken = null;
  }

  Future<String?> _getStoredToken() async {
    if (_cachedUserToken != null && _cachedUserToken!.isNotEmpty) {
      return _cachedUserToken;
    }
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    if (token != null && token.isNotEmpty) {
      _cachedUserToken = token;
      return token;
    }
    return null;
  }

  Future<bool> _refreshAccessToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final refreshToken = prefs.getString("refresh_token");
    if (refreshToken == null || refreshToken.isEmpty) {
      return false;
    }

    final headers = await _authRequestHeaders();
    final uri = Uri.parse("$_authBase/refresh");
    final response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode({"refreshToken": refreshToken}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await _applyAuthPayload(
        {
          "token": data['token'],
          "refreshToken": data['refreshToken'] ?? refreshToken,
          "globalId": prefs.getString("necsoura_global_id"),
          "login": prefs.getString("necsoura_login"),
        },
        true,
      );
      return true;
    }

    await _dropSession();
    return false;
  }

  Future<http.Response?> _authorizedRequest(
      Future<http.Response> Function(String token) executor) async {
    String? token = await _getStoredToken();
    if (token == null || token.isEmpty) {
      return null;
    }

    http.Response response = await executor(token);
    if (response.statusCode == 401) {
      final refreshed = await _refreshAccessToken();
      if (refreshed) {
        token = await _getStoredToken();
        if (token != null && token.isNotEmpty) {
          response = await executor(token);
        }
      }
    }
    return response;
  }

  Future<bool> refreshSession() => _refreshAccessToken();

  void clearPendingTwoFactor() {
    _pendingTwoFactorGlobalId = null;
  }

  Future<bool> verifyTwoFactorCode(String code, bool rememberUser) async {
    final pendingId = _pendingTwoFactorGlobalId;
    if (pendingId == null || code.isEmpty) {
      return false;
    }

    final headers = await _authRequestHeaders();
    final uri = Uri.parse("$_authBase/login/2fa");
    final response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode({
        "globalId": pendingId,
        "code": code,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await _applyAuthPayload(data, rememberUser);
      clearPendingTwoFactor();
      return true;
    }

    return false;
  }

  Future<bool> verifyBackupCode(String code, bool rememberUser) async {
    final pendingId = _pendingTwoFactorGlobalId;
    if (pendingId == null || code.isEmpty) {
      return false;
    }

    final headers = await _authRequestHeaders();
    final uri = Uri.parse("$_authBase/login/backup-code");
    final response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode({
        "globalId": pendingId,
        "backupCode": code,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await _applyAuthPayload(data, rememberUser);
      clearPendingTwoFactor();
      return true;
    }

    return false;
  }

  Future getUser() async {
    final response = await _authorizedRequest((token) {
      final uri = Uri.parse("$_apiBase/user/me");
      return http.get(uri, headers: {"Authorization": "Bearer $token"});
    });

    if (response != null && response.statusCode == 200) {
      user = jsonDecode(response.body.toString());
      return user;
    }

    return {'status': 'false'};
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
    final uri = Uri.parse("$_apiBase/music/top?lim=20");
    final response = await http.get(
      uri,
      headers: ds != null && ds.isNotEmpty ? {"Authorization": "Bearer $ds"} : {},
    );
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
    if (id == "0") {
      final response = await _authorizedRequest((token) {
        final uri = Uri.parse("$_apiBase/music/favorites?count=$count");
        return http.get(uri, headers: {"Authorization": "Bearer $token"});
      });
      if (response == null || response.statusCode != 200) {
        return [];
      }
      List langData = jsonDecode(response.body.toString())[0];
      return await showStatusInstall(langData);
    } else {
      final response = await _authorizedRequest((token) {
        final uri = Uri.parse("$_apiBase/playlists/$id");
        return http.get(uri, headers: {"Authorization": "Bearer $token"});
      });
      if (response == null || response.statusCode != 200) {
        return [];
      }
      List langData = jsonDecode(response.body.toString())[0];
      return await showStatusInstall(langData);
    }
  }


  Future<List> getPlayLists(int count) async {
    final response = await _authorizedRequest((token) {
      final uri = Uri.parse("$_apiBase/playlists?count=$count");
      return http.get(uri, headers: {"Authorization": "Bearer $token"});
    });
    if (response == null || response.statusCode != 200) {
      return [];
    }
    List langData = jsonDecode(response.body.toString())[0];
    return await showStatusInstall(langData);
  }

  Future<List> getAlbum(int count) async {
    final response = await _authorizedRequest((token) {
      final uri = Uri.parse("$_apiBase/albums?count=$count");
      return http.get(uri, headers: {"Authorization": "Bearer $token"});
    });
    if (response == null || response.statusCode != 200) {
      return [];
    }
    List langData = jsonDecode(response.body.toString())[0];
    return await showStatusInstall(langData);
  }

  Future<bool> getLoggedAccount() async {
    final profile = await getUser();
    return profile is Map && profile["status"] == "true";
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
      final uri = Uri.parse("$_apiBase/music/batch").replace(queryParameters: {
        "ids": ids,
      });

      try {
        http.Response? response;
        if (ds != null && ds.isNotEmpty) {
          response = await _authorizedRequest((token) {
            return http.get(uri, headers: {"Authorization": "Bearer $token"});
          });
        } else {
          response = await http.get(uri);
        }

        if (response == null) {
          return [];
        }

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
    print("searchikngh $text");
    if (text != '') {
      final uri = Uri.parse("$_apiBase/search/tracks").replace(queryParameters: {
        "q": text,
        "limit": "50",
      });
      var response = await http.get(uri);
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
    var uri = Uri.parse("$_apiBase/videos/top");
    var response = await http.get(uri);
    String dff = response.body.toString();
    List langData = jsonDecode(dff);
    return langData;
  }

  Future<dynamic> getEssensionRandom() async {
    var uri = Uri.parse("$_apiBase/essence/random");
    var response = await http.get(uri);
    String dff = response.body.toString();
    return jsonDecode(dff);
  }

  Future<String> getJemRandom() async {
    var uri = Uri.parse("$_apiBase/jem/random");
    var response = await http.get(uri);
    String dff = response.body.toString();
    return dff;
  }


  Future<dynamic> getAboutMusic(String idshaz) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? ds = prefs.getString("token");
    final uri = Uri.parse("$_apiBase/music/$idshaz");
    http.Response? response;
    if (ds != null && ds.isNotEmpty) {
      response = await _authorizedRequest((token) {
        return http.get(uri, headers: {"Authorization": "Bearer $token"});
      });
    } else {
      response = await http.get(uri);
    }
    if (response == null) {
      return {};
    }
    String dff = response.body.toString();
    return jsonDecode(dff);
  }


  Future<Map<String, dynamic>> getSimilarTracks({
    required String currentTrackId,
    required int count,
    List<String> playedIds = const [],
    String? token,
  }) async {
    final String baseUrl = "$_apiBase/recommendations/next";
    final Map<String, String> queryParams = {
      'nice': currentTrackId,
      'count': count.toString(),
      if (playedIds.isNotEmpty) 'playedIds': playedIds.join(','),
      if (token != null && token.isNotEmpty) 'token': token,
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
    final response = await _authorizedRequest((token) {
      final uri = Uri.parse("$_apiBase/music/$id/reaction");
      return http.post(
        uri,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"type": type}),
      );
    });

    if (response == null || response.statusCode != 200) {
      return "3";
    }

    final data = jsonDecode(response.body.toString());
    if (data['status'].toString() == "true") {
      return data['type'].toString();
    }
    return "3";
  }



  Future<String> installMusic(String idshaz) async {
    var uri = Uri.parse("$_apiBase/music/$idshaz/install");
    final response = await _authorizedRequest((token) {
      return http.post(
        uri,
        headers: {"Authorization": "Bearer $token"},
      );
    });
    if (response == null) {
      return "unauthorized";
    }
    return response.body.toString();
  }

  Future<AuthStatus> toLogin(String login, String password, bool isRemember) async {
    if (login == '' || password == '') {
      return AuthStatus.failure;
    }

    final uri = Uri.parse("$_authBase/login");
    final headers = await _authRequestHeaders();
    final response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode({
        "login": login,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      final langData = jsonDecode(response.body);
      await _applyAuthPayload(langData, isRemember);
      clearPendingTwoFactor();
      return AuthStatus.success;
    } else if (response.statusCode == 202) {
      final data = jsonDecode(response.body);
      _pendingTwoFactorGlobalId = data['globalId']?.toString();
      return AuthStatus.requiresTwoFactor;
    } else {
      print("Necsoura login error ${response.statusCode}: ${response.body}");
      return AuthStatus.failure;
    }
  }

  Future<bool> toRegister(String login, String nick, String email, String password, bool isRemember) async {
    if (login == '' || password == '') {
      return false;
    }

    final uri = Uri.parse("$_authBase/register");
    final headers = await _authRequestHeaders();

    final response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode({
        "login": login,
        "email": email,
        "password": password,
        "gameNickname": nick.isNotEmpty ? nick : login,
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final langData = jsonDecode(response.body);
      await _applyAuthPayload(langData, isRemember);
      clearPendingTwoFactor();
      return true;
    } else {
      print("Necsoura register error ${response.statusCode}: ${response.body}");
      return false;
    }
  }

  Future<bool> loginWithGoogle(String idToken, {bool isRemember = true}) async {
    if (idToken.isEmpty) {
      return false;
    }

    final headers = await _authRequestHeaders();
    final uri = Uri.parse("$_authBase/google");
    final response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode({"idToken": idToken}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await _applyAuthPayload(data, isRemember);
      clearPendingTwoFactor();
      return true;
    } else {
      print("Necsoura google login error ${response.statusCode}: ${response.body}");
      return false;
    }
  }

}

