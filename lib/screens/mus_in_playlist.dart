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
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../api/api_service.dart';
import '../parts/buttons.dart';
import '../parts/music_cell.dart';
import '../providers/list_manager_provider.dart';



const kBgColor = Color(0xFF1604E2);

class MusInPlaylistScreen extends StatefulWidget {
  final  Function(dynamic) onCallback;
  final String onCallbacki;
  final  Function(dynamic, dynamic, String) onCallbackt;
  final String name;
  final String img;
  final bool imgnd;
  final VoidCallback hie;
  final VoidCallback showlog;
  final VoidCallback resre;
  MusInPlaylistScreen({Key? key, required this.onCallback, required this.onCallbacki, required this.hie, required this.name, required this.img, required this.imgnd, required this.showlog, required this.resre, required this.onCallbackt}) : super(key: key);
  @override
  State<MusInPlaylistScreen> createState() => MusInPlaylistScreenState((dynamic input) {onCallback(input);},onCallbacki, hie, name, img, imgnd,showlog,resre,(dynamic input, dynamic inputi, String sdazc) {onCallbackt(input, inputi, sdazc);});




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
  late  Function(dynamic,dynamic, String) dfv;
  late String palylsitid;
  late String palylsitname;
  late String palylsitimg;
  late bool palylsitimgnd;
  late VoidCallback showsearch;
  late VoidCallback showlog;
  late VoidCallback reset;
  var player;

  MusInPlaylistScreenState(Function(dynamic) onk,String onki, VoidCallback fg,String erfw,String fdcdsc,bool fdsfad, VoidCallback dawsd, VoidCallback fgdfxg, Function(dynamic, dynamic, String) onkhngf){
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
    setState(() {
      isRefreshing = true;
      showRefreshButton = true;
    });
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
      langData = await apiService.getMusicInPlaylist(palylsitid, 0);
      setState(() {
        showRefreshButton = false;
        context.read<ListManagerProvider>().createList('playlistid'+palylsitid.toString(), langData);
      });
    }else{
      langData = await apiService.getInstalledMusic();
      setState(() {
        showRefreshButton = false;
        context.read<ListManagerProvider>().createList('installedmusic', langData);
      });
    }
    await Future.delayed(Duration(milliseconds: 301));
    setState(() {
      isRefreshing = false;
      isDragging = false;
    });
    print(usera.toString()+'kighj');
  }

  @override
  void initState()
  {
    _scrollController.addListener(_checkScrollPosition);
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




  void _checkScrollPosition() {
    if (_scrollController.offset <= 0 && !isRefreshing) {
      load();
    }
  }
  bool showRefreshButton = false;
  bool isRefreshing = false;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  bool isDragging = false;
  final ScrollController _scrollController = ScrollController();

  Widget _loadListViewmore() {
    Size size = MediaQuery.of(context).size;
    return Consumer<ListManagerProvider>(
        builder: (context, listManager, child)
        {
          late var list;
          if(palylsitid != "install") {
            list = listManager.getList(
                'playlistid'+palylsitid.toString()); // Получить список из провайдера
          }else{
            list = listManager.getList(
                'installedmusic');
          }
          if (list.isEmpty) {
            return Center(child: Text('Нету треков', style: TextStyle(color: Colors.white, fontSize: 28),));
          }

          return NotificationListener<ScrollNotification>(
              onNotification: (notification) {
            if (notification is OverscrollNotification && !isRefreshing) {
              setState(() => isDragging = true);
            }
            if (notification is ScrollEndNotification && isDragging) {
              load();
            }
            return false;
          },
          child: ListView.builder(
      controller: _scrollController,
      itemCount: list.length+1,
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
                    )) : buttonlogin(showlog )),)
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

          return MussicCell( list[idx-1], (){sendpalulit(idx-1, list);}, context);
        }
      },
    ));
        });
  }


  Widget _loadListView() {
    Size size = MediaQuery.of(context).size;
    return Consumer<ListManagerProvider>(
        builder: (context, listManager, child)
        {
          late var list;
          if(palylsitid != "install") {
            list = listManager.getList(
                'playlistid'+palylsitid.toString()); // Получить список из провайдера
          }else{
            list = listManager.getList(
                'installedmusic');
          }

          if (list.isEmpty) {
            return Center(child: Text('Нету треков', style: TextStyle(color: Colors.white, fontSize: 28),));
          }

          return NotificationListener<ScrollNotification>(
              onNotification: (notification) {
            if (notification is OverscrollNotification && !isRefreshing) {
              setState(() => isDragging = true);
            }
            if (notification is ScrollEndNotification && isDragging) {
              load();
            }
            return false;
          },
          child: ListView.builder(
            controller: _scrollController,
      itemCount: list.length+1,
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
                    )) : buttonlogin(showlog )),)
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
          return MussicCell( list[idx-1], (){sendpalulit(idx-1, list);}, context);
        }
      },
    )
          );
        });
  }

  void sendpalulit(var fdsvds, dynamic list){
    print(list.toString() + fdsvds.toString() + palylsitname+ "ghfghnf");
    dfv(list,fdsvds, palylsitname);
  }



  String imgprofile = "";
  bool useri = false;


}




