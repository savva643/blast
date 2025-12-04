import 'dart:async';
import 'dart:convert';
import 'dart:io';


import 'package:blast/screens/profile_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:record/record.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../api/api_service.dart';
import '../api/record_api.dart';
import '../parts/bottomsheet_recognize.dart';
import '../parts/buttons.dart';
import '../parts/music_cell.dart';
import '../providers/list_manager_provider.dart';
import 'login.dart';



const kBgColor = Color(0xFF1604E2);

class SearchScreen extends StatefulWidget {
  final  Function(dynamic) onCallback;
  final VoidCallback onCallbacki;
  final VoidCallback hie;
  final VoidCallback showlog;
  final VoidCallback dasd;
  final  Function(dynamic) dfsfd;
  final Recorderi reci;
  final VoidCallback oniBack;
  final BuildContext prtctx;
  SearchScreen({Key? key, required this.onCallback, required this.onCallbacki, required this.hie, required this.showlog, required this.dasd, required this.dfsfd, required this.reci, required this.oniBack, required this.prtctx}) : super(key: key);
  @override
  State<SearchScreen> createState() => SearchScreenState((dynamic input) {onCallback(input);},onCallbacki, hie,showlog,dasd,(dynamic input) {dfsfd(input);});




}

class SearchScreenState extends State<SearchScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  var iconpla = Icon(Icons.play_arrow_rounded, size: 64, color: Colors.white,);
  void updateIcon(Icon newIcon) {
    setState(() {
      iconpla = newIcon;
    });
  }
  late  Function(dynamic) onCallback;
  late  Function(dynamic) installmus;
  late VoidCallback onCallbacki;
  late VoidCallback closesearch;
  late VoidCallback showlog;
  late VoidCallback reseti;
  var player;

  SearchScreenState(Function(dynamic) onk,VoidCallback onki,VoidCallback gf,VoidCallback sda, VoidCallback gbdfgb, Function(dynamic) fvvc){
    onCallback = onk;
    onCallbacki = onki;
    closesearch = gf;
    showlog = sda;
    reseti = gbdfgb;
    installmus = fvvc;
  }





  final ApiService apiService = ApiService();
// Добавляем переменные для управления состоянием
  bool _isLoading = false;
  bool _hasError = false;
  List _historyData = [];

  void load() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      var usera = await apiService.getUser();
      var langData = await apiService.getSearchHistory();

      setState(() {
        if(usera['status'] != 'false') {
          useri = true;
          imgprofile = usera["img_kompot"];
        } else {
          useri = false;
        }

        _historyData = langData;
        context.read<ListManagerProvider>().createList('historySearch', langData);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
      print("Ошибка загрузки: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    load();
    widget.reci.initializeNotifications();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: Size.zero,
        child: AppBar(
          elevation: 0,
          backgroundColor: const Color.fromARGB(255, 15, 15, 16),
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: kBgColor,
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.light,
          ),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 15, 15, 16),
      body: SafeArea(
        bottom: false,
        child: Container(
          height: size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 15, 15, 16),
                Color.fromARGB(255, 15, 15, 16),
              ],
            ),
          ),
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 0),
                    width: size.width,
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 16),
                          child: IconButton(
                            onPressed: () {
                              widget.oniBack;
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.white, size: 34),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 18,),
                          width: size.width-60,
                          height: 40,
                          child: SearchBar(
                            hintText: 'Название трека',
                            onChanged: onChencged,
                            controller: _searchLanguageController,
                            shadowColor: WidgetStatePropertyAll(Colors.transparent),
                            side: WidgetStatePropertyAll(const BorderSide(color: Colors.white10, width: 2)),
                            overlayColor: WidgetStatePropertyAll(Colors.white10),
                            hintStyle: WidgetStatePropertyAll(TextStyle(
                              fontSize: 16,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w500,
                              color: Colors.white60,
                            )),
                            textStyle: WidgetStatePropertyAll(TextStyle(
                              fontSize: 16,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            )),
                            backgroundColor: WidgetStatePropertyAll(Color.fromARGB(255, 15, 15, 16)),
                            leading: Icon(Icons.search, color: Colors.white60),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 80),
                    height: size.height,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        if (_isLoading)
                          Center(child: CircularProgressIndicator())
                        else if (_hasError)
                          Center(child: Text("Ошибка загрузки", style: TextStyle(color: Colors.white)))
                        else
                          Container(
                            width: size.width,
                            child: _searchLanguageController.text.isEmpty
                                ? _buildHistoryContent()
                                : _buildSearchContent(),
                          ),
                        SafeArea(
                          child: Container(
                            padding: EdgeInsets.all(8),
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: ValueListenableBuilder<String>(
                                valueListenable: widget.reci.statusNotifier,
                                builder: (context, tpik, child) {
                                  return RecognitionButton(
                                    icon: tpik.contains("idle") ? Icons.mic_rounded : Icons.graphic_eq_rounded,
                                    onTap: widget.reci.startRecording,
                                    isRecognizing: tpik.contains("idle") ? false : true,
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryContent() {
    if (_historyData.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "История поиска пуста",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ],
      );
    }
    return _loadListViewhist();
  }

  Widget _buildSearchContent() {
    if (_searchedLangData.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Ничего не найдено",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ],
      );
    }
    return _loadListView();
  }





  bool showls = true;

  List _searchedLangData = [];
  final _searchLanguageController = TextEditingController();


  @override
  void dispose() {
    super.dispose();
  }

  String imgprofile = "";
  bool useri = false;


  Widget _loadListViewhist() {
    Size size = MediaQuery.of(context).size;
    return Consumer<ListManagerProvider>(
        builder: (context, listManager, child)
        {
          final list = listManager.getList(
              'historySearch'); // Получить список из провайдера

          if (list.isEmpty) {
            return Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: [Text("История поиска пуста",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),),],);
          }

          return ListView.builder(
            itemCount: list.length+1,
            itemBuilder: (BuildContext context, int idx)
            {
              return SizedBox(child: idx == 0 ?  Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10,),
                  Container(margin: EdgeInsets.only(left: 10), child:
                  Text("История поиска",
                    style: TextStyle(
                      fontSize: 30,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),)),
                  SizedBox(height: 10,),

                ],
              )
                  :
              MussicCell( list[idx-1], () async {

                onCallback(list[idx-1]['idshaz']);

                final SharedPreferences prefs = await SharedPreferences.getInstance();
                List<String>? sac = prefs.getStringList("historymusid");
                List<String> fsaf = [];
                if (sac != null) {
                  fsaf = sac;
                }
                if(fsaf.length >= 20){
                  fsaf.removeLast();
                }
                fsaf.add(list[idx-1]['idshaz']);
                await prefs.setStringList("historymusid", fsaf);
              }, widget.prtctx)
              );
            },
          );
        });
  }

  Widget _loadListView() {
    Size size = MediaQuery.of(context).size;
    return ListView.builder(
      itemCount: _searchedLangData.length+1,
      itemBuilder: (BuildContext context, int idx)
      {
        return SizedBox(child: idx == 0 ?  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10,),
            Container(margin: EdgeInsets.only(left: 10), child:
            Text("Треки",
              style: TextStyle(
                fontSize: 30,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),)),
            SizedBox(height: 10,),

          ],
        )
            :

        MussicCell( _searchedLangData[idx-1], () async {
          print("gfdfgdfg"+_searchedLangData[idx-1]['url'].toString());
          if(_searchedLangData[idx-1]['url'].toString() != "0") {
            onCallback(_searchedLangData[idx - 1]['idshaz']);
          }else{
            installmus(_searchedLangData[idx - 1]);
          }
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          List<String>? sac = prefs.getStringList("historymusid");
          List<String> fsaf = [];
          if (sac != null) {
            fsaf = sac;
          }
          if(fsaf.length >= 20){
            fsaf.removeLast();
          }
          fsaf.add(_searchedLangData[idx-1]['idshaz']);
          await prefs.setStringList("historymusid", fsaf);
        }, widget.prtctx)
        );
      },
    );
  }



  Future<void> onChencged(String text) async {
    setState(() {
      showls = false;
    });
    List langData = await apiService.getSearchMusic(text);
    setState(() {
      if(langData.isNotEmpty) {
        _searchedLangData = langData;
        showls = true;
      }else{
        _searchLanguageController.clear();
        showls = false;
      }
    });
  }

}




