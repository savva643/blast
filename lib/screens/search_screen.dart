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
  SearchScreen({Key? key, required this.onCallback, required this.onCallbacki, required this.hie, required this.showlog, required this.dasd, required this.dfsfd, required this.reci}) : super(key: key);
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
  void load() async {
    var usera = await apiService.getUser();
    setState(() {
      if(usera['status'] != 'false') {
        useri = true;
        imgprofile = usera["img_kompot"];
      }else{
        useri = false;
      }
    });
    var langData = await apiService.getSearchHistory();
    setState(() {
      context.read<ListManagerProvider>().createList('historySearch', langData);
    });
  }

  @override
  void initState()
  {
    load();
    widget.reci.initializeNotifications();
    super.initState();
  }

  String musicUrl = ""; // Insert your music URL
  String thumbnailImgUrl = "";
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
            statusBarBrightness: Brightness.dark, // For iOS: (dark icons)
            statusBarIconBrightness: Brightness.light, // For Android: (dark icons)
          ),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 15, 15, 16),
      body: SafeArea(
        bottom: false,
        child:
        Container(
          height: size.height,
          decoration: new BoxDecoration(
              gradient: new LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(255, 15, 15, 16),
                  Color.fromARGB(255, 15, 15, 16),
                ],
              )),
          child: Column(
            children: [
              Stack(
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

                  Row(children: [
                    Container(padding: EdgeInsets.only(left: 12,top: 0),
                        child:
                        Text("blast!",
                          style: TextStyle(
                            fontSize: 40,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),)), Expanded(child: Container()),

                    Container(alignment: Alignment.topRight, margin: EdgeInsets.only(top: 18), child: IconButton(onPressed: useri ? () { Navigator.push(context, MaterialPageRoute(builder: (context) =>  ProfileScreen(reseti: reseti,))); } : showlog, icon: imgprofile!="" ? SizedBox(height: 44, width: 44, child: CachedNetworkImage(
                      imageUrl: imgprofile, // Replace with your image URL
                      imageBuilder: (context, imageProvider) => Container(
                        margin: EdgeInsets.only(right: 3, top: 3),
                        width: 100.0, // Set the width of the circular image
                        height: 100.0, // Set the height of the circular image
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover, // Adjusts the image inside the circle
                          ),
                        ),
                      ),
                      placeholder: (context, url) => CircularProgressIndicator(), // Placeholder while loading
                      errorWidget: (context, url, error) => Icon(Icons.error), // Error icon if image fails to load
                    )) : buttonlogin(showlog )),)
                  ],),
          Container(margin: EdgeInsets.only(top: 60), width: size.width, child: Row(children: [Container(margin: EdgeInsets.only(top: 16), child: IconButton(onPressed: (){ Navigator.pop(context); }, icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.white, size: 34,)),),Container(margin: EdgeInsets.only(top: 18), width: size.width-60, height: 40, child: SearchBar(hintText: 'Навзвание трека',  onChanged: onChencged, controller: _searchLanguageController, shadowColor: WidgetStatePropertyAll(Colors.transparent), side: WidgetStatePropertyAll(const BorderSide(color: Colors.white10, width: 2)), overlayColor: WidgetStatePropertyAll(Colors.white10), hintStyle: WidgetStatePropertyAll(TextStyle(
                    fontSize: 16,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                    color: Colors.white60,
                  )), textStyle: WidgetStatePropertyAll(TextStyle(
                    fontSize: 16,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  )), backgroundColor: WidgetStatePropertyAll(Color.fromARGB(255, 15, 15, 16)), leading: Icon(Icons.search, color: Colors.white60),)),],),),
                  Container(padding: EdgeInsets.only(top: 124), height: size.height,
                    child:
                    Stack(alignment: Alignment.center,
                      children: [
                        Container(width: size.width, child:  (showls ? (_searchLanguageController.text.isEmpty ? _loadListViewhist() : _loadListView()) :  Container(child: Center(child: CircularProgressIndicator(),),))

                        ),SafeArea(child: Container(padding: EdgeInsets.all(8),child: Align(alignment: Alignment.bottomRight,child:
    ValueListenableBuilder<String>(
    valueListenable: widget.reci.statusNotifier,
    builder: (context, tpik, child) {
    return RecognitionButton(
                          icon: tpik.contains("idle") ? Icons.mic_rounded : Icons.graphic_eq_rounded,
                          onTap: widget.reci.startRecording,
                          isRecognizing: tpik.contains("idle") ? false : true,
                        );}))))
                      ],),),

                ],),

            ],
          ),
        ),

      ),
    );
  }

  bool showls = false;

  List _searchedLangData = [
    {
      'id': '1',
      'img': 'https://kompot.site/img/music.jpg',
      'name': 'Название',
      'message': 'Имполнитель',
    },
    {
      'id': '2',
      'img': 'https://kompot.site/img/music.jpg',
      'name': 'Название',
      'message': 'Имполнитель',
    },
  ];
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
          }, context)
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
        }, context)
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




