import 'dart:async';
import 'dart:convert';


import 'package:blast/screens/login.dart';
import 'package:blast/screens/profile_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../api/api_service.dart';
import '../parts/music_cell.dart';



const kBgColor = Color(0xFF1604E2);

class MusInPlaylistScreen extends StatefulWidget {
  final  Function(dynamic) onCallback;
  final String onCallbacki;
  final  Function(dynamic, dynamic) onCallbackt;
  final String name;
  final String img;
  final bool imgnd;
  final VoidCallback hie;
  final VoidCallback showlog;
  final VoidCallback resre;
  MusInPlaylistScreen({Key? key, required this.onCallback, required this.onCallbacki, required this.hie, required this.name, required this.img, required this.imgnd, required this.showlog, required this.resre, required this.onCallbackt}) : super(key: key);
  @override
  State<MusInPlaylistScreen> createState() => MusInPlaylistScreenState((dynamic input) {onCallback(input);},onCallbacki, hie, name, img, imgnd,showlog,resre,(dynamic input, dynamic inputi) {onCallbackt(input, inputi);});




}

class MusInPlaylistScreenState extends State<MusInPlaylistScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  var iconpla = Icon(Icons.play_arrow_rounded, size: 64, color: Colors.white,);
  void updateIcon(Icon newIcon) {
    setState(() {
      iconpla = newIcon;
    });
  }
  late  Function(dynamic) onCallback;
  late  Function(dynamic,dynamic) dfv;
  late String palylsitid;
  late String palylsitname;
  late String palylsitimg;
  late bool palylsitimgnd;
  late VoidCallback showsearch;
  late VoidCallback showlog;
  late VoidCallback reset;
  var player;

  MusInPlaylistScreenState(Function(dynamic) onk,String onki, VoidCallback fg,String erfw,String fdcdsc,bool fdsfad, VoidCallback dawsd, VoidCallback fgdfxg, Function(dynamic, dynamic) onkhngf){
    onCallback = onk;
    palylsitid = onki;
    showsearch = fg;
    palylsitname = erfw;
    palylsitimg = fdcdsc;
    palylsitimgnd = fdsfad;
    showlog = dawsd;
    reset = fgdfxg;
    dfv = onkhngf;
  }


  final ApiService apiService = ApiService();
  void load() async {
    late var langData;
    var usera = await apiService.getUser();
    setState(() {
      if(usera['status'] != 'false') {
        useri = true;
        imgprofile = usera["img_kompot"];
      }else{
        useri = false;
      }
    });
    if(palylsitid != "install") {
       langData = await apiService.getMusicInPlaylist(palylsitid);
    }else{
      langData = await apiService.getInstalledMusic();
    }
    print(usera.toString()+'kighj');
    setState(() {
      _searchedLangData = langData;
    });
  }

  @override
  void initState()
  {
    load();
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
          decoration: new BoxDecoration(
              gradient: new LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(255, 15, 15, 16),
                  Color.fromARGB(255, 15, 15, 16),
                ],
              )),
          child: size.width > 600 ? _loadListViewmore() : _loadListView(),
        ),

      ),
    );
  }


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


  @override
  void dispose() {
    super.dispose();
  }



  Widget _loadListViewmore() {
    Size size = MediaQuery.of(context).size;
    return ListView.builder(
      itemCount: _searchedLangData.length+1,
      itemBuilder: (BuildContext context, int idx)
      {
        if (idx == 0) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  AnimatedContainer(
                      margin: EdgeInsets
                          .only(
                          left: 0,
                          right: 0,
                          top: 0),
                      height: size.width/3,
                      width: size.width/3,
                      decoration: BoxDecoration(
                        shape: BoxShape
                            .rectangle,
                        borderRadius: BorderRadius
                            .only(bottomRight: Radius.circular(20) ),
                      ),

                      clipBehavior: Clip
                          .hardEdge,
                      duration: Duration(
                          milliseconds: 0),
                      child: AspectRatio(
                          aspectRatio: 1,
                          // Сохранение пропорций 1:1
                          child: palylsitimgnd ? Image
                              .network(
                            palylsitimg,
                            height: size.width,
                            width: size.width,
                            fit: BoxFit
                                .cover, // Изображ
                          ) : Image(image: AssetImage(palylsitimg), width: size.width,))),
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
                          ),)),
                    Expanded(child: Container()),
                    Container(alignment: Alignment.topRight, margin: EdgeInsets.only(top: 18), child: IconButton(onPressed: () {showsearch();}, icon: Icon(Icons.search_rounded, size: 40, color: Colors.white,)),),
                    Container(alignment: Alignment.topRight, margin: EdgeInsets.only(top: 18), child: IconButton(onPressed: useri ? () { Navigator.push(context, MaterialPageRoute(builder: (context) =>  ProfileScreen(reseti: reset,))); } : showlog, icon: imgprofile!="" ? SizedBox(height: 44, width: 44, child: CachedNetworkImage(
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
                    )) : Icon(Icons.circle, size: 46, color: Colors.white,)),)
                  ],),
                  Container(margin: EdgeInsets.only(left: size.width/3 + 10, top: 20), child:
                  Row(children: [Container(margin: EdgeInsets.only(top: 0), child: IconButton(onPressed: (){ Navigator.pop(context); }, icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.white, size: 34,)),),
                    Text(palylsitname,
                      style: TextStyle(
                        fontSize: 30,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),)],)),
                ],),

            ],
          );
        }else{

          return MussicCell( _searchedLangData[idx-1], (){onCallback(_searchedLangData[idx-1]['idshaz']);});
        }
      },
    );
  }


  Widget _loadListView() {
    Size size = MediaQuery.of(context).size;
    return ListView.builder(
      itemCount: _searchedLangData.length+1,
      itemBuilder: (BuildContext context, int idx)
      {
        if (idx == 0) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  AnimatedContainer(
                      margin: EdgeInsets
                          .only(
                          left: 0,
                          right: 0,
                          top: 0),
                      height: size.width,
                      width: size.width,
                      decoration: BoxDecoration(
                        shape: BoxShape
                            .rectangle,
                        borderRadius: BorderRadius
                            .only(
                            bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20) ),
                      ),

                      clipBehavior: Clip
                          .hardEdge,
                      duration: Duration(
                          milliseconds: 0),
                      child: AspectRatio(
                          aspectRatio: 1,
                          // Сохранение пропорций 1:1
                          child: palylsitimgnd ? Image
                              .network(
                            palylsitimg,
                            height: size.width,
                            width: size.width,
                            fit: BoxFit
                                .cover, // Изображ
                          ) : Image(image: AssetImage(palylsitimg), width: size.width,))),
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
                          ),)),
                   Expanded(child: Container()),
                    Container(alignment: Alignment.topRight, margin: EdgeInsets.only(top: 18), child: IconButton(onPressed: () {showsearch();}, icon: Icon(Icons.search_rounded, size: 40, color: Colors.white,)),),
                    Container(alignment: Alignment.topRight, margin: EdgeInsets.only(top: 18), child: IconButton(onPressed: useri ? () { Navigator.push(context, MaterialPageRoute(builder: (context) =>  ProfileScreen(reseti: reset,))); } : showlog, icon: imgprofile!="" ? SizedBox(height: 44, width: 44, child: CachedNetworkImage(
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
                    )) : Icon(Icons.circle, size: 46, color: Colors.white,)),)
                  ],),
                ],),
              Container(margin: EdgeInsets.only(left: 10), child:
              Row(children: [Container(margin: EdgeInsets.only(top: 0), child: IconButton(onPressed: (){ Navigator.pop(context); }, icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.white, size: 34,)),),
                Text(palylsitname,
                style: TextStyle(
                  fontSize: 30,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),)],)),
            ],
          );
        }else{
          return MussicCell( _searchedLangData[idx-1], (){onCallback(_searchedLangData[idx-1]['idshaz']);});
        }
      },
    );
  }

  void sendpalulit(var fdsvds){
    dfv(_searchedLangData,fdsvds);
  }



  String imgprofile = "";
  bool useri = false;


}




