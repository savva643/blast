import 'dart:async';
import 'dart:convert';
import 'dart:io';


import 'package:blast/screens/mus_in_playlist.dart';
import 'package:blast/screens/profile_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../api/api_service.dart';
import '../parts/buttons.dart';
import 'login.dart';



const kBgColor = Color(0xFF1604E2);

class PlaylistScreen extends StatefulWidget {
  final  Function(dynamic) onCallback;
  final  Function(dynamic, dynamic, String) onCallbackt;
  final VoidCallback hie;
  final VoidCallback showlog;
  final VoidCallback resdf;
  const PlaylistScreen({Key? key, required this.onCallback, required this.hie, required this.showlog, required this.resdf, required this.onCallbackt}) : super(key: key);
  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState((dynamic input) {onCallback(input);}, hie,showlog,resdf,(dynamic input,dynamic inputi, String asdsa) {onCallbackt(input, inputi, asdsa);});




}

class _PlaylistScreenState extends State<PlaylistScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late VoidCallback showsearch;
  late Function(dynamic) onCallback;
  late Function(dynamic, dynamic, String) onCallbackrfdg;
  late VoidCallback showlog;
  late VoidCallback reseti;
  _PlaylistScreenState(Function(dynamic) onk, VoidCallback fg, VoidCallback dawsd, VoidCallback gbdfgb, Function(dynamic,dynamic inputi, String) onksd) {
    onCallback = onk;
    showsearch = fg;
    showlog = dawsd;
    reseti = gbdfgb;
    onCallbackrfdg = onksd;
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
    var langData = await apiService.getPlayLists(0);
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
  var player = AudioPlayer();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: Size.zero,
        child: AppBar(
          elevation: 0,
          backgroundColor: kBgColor,

          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: kBgColor,
            statusBarBrightness: Brightness.dark, // For iOS: (dark icons)
            statusBarIconBrightness: Brightness.light, // For Android: (dark icons)
          ),
        ),
      ),

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
          child:
          Column(
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
            Container(alignment: Alignment.topRight, margin: EdgeInsets.only(top: 18), child: IconButton(onPressed: () {showsearch();}, icon: Icon(Icons.search_rounded, size: 40, color: Colors.white,)),),
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
          Container(height: size.height, padding: EdgeInsets.only(top: 60), child: size.width > 800 ? _loadGridView() : _loadListView()),
        ],),


          ],
        ),
      ),

      ),
    );
  }


  List _searchedLangData = [];

  final _searchLanguageController = TextEditingController();

  String imgprofile = "";
  bool useri = false;



  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  void _openSearchPage(BuildContext context, String fds, String name, String img, bool imgnd) {

    // Navigator.of(context).push(_createSearchRoute(fds, name, img, imgnd));

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MusInPlaylistScreen(
          onCallback: (dynamic input) => onCallback(input),
          onCallbacki: fds,
          hie: showsearch,
          name: name,
          img: img,
          imgnd: imgnd,
          showlog: showlog,
          resre: reseti,
          onCallbackt: (dynamic input, dynamic inputi, String fds) =>
              onCallbackrfdg(input, inputi, fds),
        ),
      ),
    );

  }

  // Анимация открытия страницы поиска
  Route _createSearchRoute(String fds, String name, String img, bool imgnd) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => MusInPlaylistScreen(onCallback: (dynamic input) {
        onCallback(input);
      }, onCallbacki: fds, hie: showsearch, name: name, img: img, imgnd:imgnd, showlog: showlog, resre: reseti, onCallbackt: (dynamic input, dynamic inputi, String fgd) {
        onCallbackrfdg(input, inputi, fgd);
      }),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset(0.0, 0.0);
        const curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }



  Widget _loadListView() {
    Size size = MediaQuery.of(context).size;
    return ListView.builder(
      itemCount: _searchedLangData.length+2,
      itemBuilder: (BuildContext context, int idx)
      {
        return SizedBox(child: idx == 0 ?  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10,),
            Container(margin: EdgeInsets.only(left: 10), child:
            Text("Плейлисты",
              style: TextStyle(
                fontSize: 30,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),)),
            SizedBox(height: 10,),

          ],
        )
            : idx == 1 ?
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: Material(

            color: Color.fromARGB(0, 15, 15, 16),
            borderRadius: BorderRadius.circular(5),
            child: ListTile(
              contentPadding: EdgeInsets.only(
                  left: 0, right: 0, bottom: 4, top: 4),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              onTap: () async {
                _openSearchPage(context, "-1","История",'assets/images/history.png', false);
              },
              leadingAndTrailingTextStyle: TextStyle(),
              leading: SizedBox(width: 90,
                height: 60,
                child: Row(mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: OverflowBox(
                        maxWidth: double.infinity,
                        maxHeight: double.infinity,
                        child:  ClipRRect(
                          borderRadius: BorderRadius.circular(8.0), // Радиус закругления углов
                          child: Image(image: AssetImage('assets/images/history.png'), width: 60,)),
                      ),),
                  ],),),
              title: Text(
                "История",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 246, 244, 244)
                ),
              ),
              trailing: IconButton(icon: Icon(Icons.more_vert),
                color: Colors.white,
                onPressed: () {},),
            ),
          ),
        ) : idx == 2 ?
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: Material(

            color: Color.fromARGB(0, 15, 15, 16),
            borderRadius: BorderRadius.circular(5),
            child: ListTile(
              contentPadding: EdgeInsets.only(
                  left: 0, right: 0, bottom: 4, top: 4),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              onTap: () async {
                _openSearchPage(context, "0","Мне нравится", 'assets/images/loveplaylist.gif', false);
              },
              leadingAndTrailingTextStyle: TextStyle(),
              leading: SizedBox(width: 90,
                height: 60,
                child: Row(mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: OverflowBox(
                        maxWidth: double.infinity,
                        maxHeight: double.infinity,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0), // Радиус закругления углов
                          child: Image(image: AssetImage('assets/images/loveplaylist.gif'), width: 60,)),
                      ),),
                  ],),),
              title: Text(
                "Мне нравится",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 246, 244, 244)
                ),
              ),
              trailing: IconButton(icon: Icon(Icons.more_vert),
                color: Colors.white,
                onPressed: () {},),
            ),
          ),
        ) : idx == 3 ?
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: Material(

            color: Color.fromARGB(0, 15, 15, 16),
            borderRadius: BorderRadius.circular(5),
            child: ListTile(
              contentPadding: EdgeInsets.only(
                  left: 0, right: 0, bottom: 4, top: 4),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              onTap: () async {
                _openSearchPage(context, "install","Скаченное", 'assets/images/installmus.png', false);
              },
              leadingAndTrailingTextStyle: TextStyle(),
              leading: SizedBox(width: 90,
                height: 60,
                child: Row(mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: OverflowBox(
                        maxWidth: double.infinity,
                        maxHeight: double.infinity,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0), // Радиус закругления углов
                            child: Image(image: AssetImage('assets/images/installmus.png'), width: 60,)),
                      ),),
                  ],),),
              title: Text(
                "Скаченное",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 246, 244, 244)
                ),
              ),
              trailing: IconButton(icon: Icon(Icons.more_vert),
                color: Colors.white,
                onPressed: () {},),
            ),
          ),
        ) :
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: Material(

            color: Color.fromARGB(0, 15, 15, 16),
            borderRadius: BorderRadius.circular(5),
            child: ListTile(
              contentPadding: EdgeInsets.only(
                  left: 0, right: 0, bottom: 4, top: 4),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              onTap: () async {
                _openSearchPage(context, _searchedLangData[idx-2]['id'],_searchedLangData[idx-2]['name'], _searchedLangData[idx-2]['img'], true);
              },
              leadingAndTrailingTextStyle: TextStyle(),
              leading: SizedBox(width: 90,
                height: 60,
                child: Row(mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                     SizedBox(
                      width: 60,
                      height: 60,
                      child: OverflowBox(
                        maxWidth: double.infinity,
                        maxHeight: double.infinity,
                        child: CachedNetworkImage(
                          imageUrl: _searchedLangData[idx-2]['img'],
                          imageBuilder: (context, imageProvider) =>
                              Container(
                                padding: EdgeInsets.only(
                                    left: 0, right: 0, bottom: 0, top: 0),
                                width: 64.0,
                                height: 64.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(5),
                                  image: DecorationImage(
                                      image: imageProvider),
                                ),
                              ),
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        ),
                      ),),
                  ],),),
              title: Text(
                _searchedLangData[idx-2]['name'],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 246, 244, 244)
                ),
              ),
              trailing: IconButton(icon: Icon(Icons.more_vert),
                color: Colors.white,
                onPressed: () {},),
            ),
          ),
        )
        );
      },
    );
  }


  Widget _loadGridView() {
    Size size = MediaQuery.of(context).size;
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      SizedBox(height: 10,),
    Container(margin: EdgeInsets.only(left: 10), child:
    Text("Плейлисты",
    style: TextStyle(
    fontSize: 30,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w700,
    color: Colors.white,
    ),)),
    SizedBox(height: 10,),
    Container(height: size.height-123, child:
        GridView(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisExtent: size.width,
        crossAxisSpacing: 20,
        mainAxisSpacing: 10,
      ),
      children: List.generate(_searchedLangData.length+1, (idx) {
        return idx == 0 ?  CustomTile(title: "История", imageUrl: 'assets/images/history.png', wih: size.width, fd: true, hie: (){_openSearchPage(context, "-1","История",'assets/images/history.png', false);},) : idx == 1 ?  CustomTile(title: "Мне нравится", imageUrl: "assets/images/loveplaylist.gif", wih: size.width,fd: true, hie: (){_openSearchPage(context, "0","Мне нравится", 'assets/images/loveplaylist.gif', false);}) : idx == 2 ?  CustomTile(title: "Скаченное", imageUrl: "assets/images/installmus.png", wih: size.width,fd: true,hie: (){_openSearchPage(context, "install","Скаченное", 'assets/images/installmus.png', false);}) : CustomTile(title: _searchedLangData[idx-1]['name'], imageUrl: _searchedLangData[idx-1]['img'], wih: size.width,fd: false, hie: (){_openSearchPage(context, _searchedLangData[idx-2]['id'],_searchedLangData[idx-2]['name'], _searchedLangData[idx-2]['img'], true);});
      }),))]
    );
  }





  Widget hl(BuildContext co){
    return Container();
  }

}


class CustomTile extends StatelessWidget {
  final String title;
  final String imageUrl;
  final double wih;
  final bool fd;
  final VoidCallback hie;
  CustomTile({
    required this.title,
    required this.imageUrl,
    required this.wih,
    required this.fd,
    required this.hie,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child:  Stack( children: [ SizedBox(height: wih/2, width: wih/2,  child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [AspectRatio(aspectRatio: 1, child: fd ?  ClipRRect(
              borderRadius: BorderRadius.circular(18.0), // Радиус закругления углов
              child: Image(image: AssetImage(imageUrl), width: 200,)) :
          CachedNetworkImage(
            imageUrl: imageUrl,
            imageBuilder: (context, imageProvider) =>
                Container(
                  padding: EdgeInsets.only(
                      left: 0, right: 0, bottom: 0, top: 0),
                  width: wih,
                  height: wih,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(18),
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.contain),
                  ),
                ),
            placeholder: (context, url) =>
                CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),)
          ),
            SizedBox(height: 8),
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [Text(
              title,
              textAlign: TextAlign.start,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w500,
                  color: Color.fromARGB(255, 246, 244, 244)
              ),
            ),
              ],),

          ],
        )),SizedBox(height: wih/3.8, width: wih/4,  child:
        Stack(children: [ElevatedButton(
          onPressed: () {
            hie();
          },

          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18), // Скругленные углы
            ),
            backgroundColor: Colors.transparent, // Прозрачный фон
            shadowColor: Colors.transparent, // Убираем тень
            elevation: 0, // Убираем эффект возвышенности
          ), child: Container(width: wih,),
        ),
          Container(alignment: Alignment.bottomCenter, child:
          Row(mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.end, children: [
            IconButton(

              icon: Icon(Icons.more_vert),
              color: Colors.white,
              onPressed: () {},
            )],))
        ],)
        ),
        ],)
    );
  }





}

