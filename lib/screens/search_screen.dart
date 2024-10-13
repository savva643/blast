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
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'login.dart';



const kBgColor = Color(0xFF1604E2);

class SearchScreen extends StatefulWidget {
  final  Function(dynamic) onCallback;
  final VoidCallback onCallbacki;
  final VoidCallback hie;
  final VoidCallback showlog;
  final VoidCallback dasd;
  final  Function(dynamic) dfsfd;
  SearchScreen({Key? key, required this.onCallback, required this.onCallbacki, required this.hie, required this.showlog, required this.dasd, required this.dfsfd}) : super(key: key);
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
  List _langData = [
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
  var player;

  SearchScreenState(Function(dynamic) onk,VoidCallback onki,VoidCallback gf,VoidCallback sda, VoidCallback gbdfgb, Function(dynamic) fvvc){
    onCallback = onk;
    onCallbacki = onki;
    closesearch = gf;
    showlog = sda;
    reseti = gbdfgb;
    installmus = fvvc;
  }

  @override
  void initState()
  {
    getpr();
    historyplaylists();
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
                children: [
                  SizedBox(
                    height: 80,width: 220,
                    child: OverflowBox(
                      maxWidth: double.infinity,
                      maxHeight: double.infinity,
                      child:
                      Container(
                        padding: EdgeInsets.only(top: 140),
                        child:
                        Image.asset('assets/images/kol.png',width: 220, height: 220, fit: BoxFit.cover,),),
                    ),),

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
                    )) : Icon(Icons.circle, size: 46, color: Colors.white,)),)
                  ],),
          Container(margin: EdgeInsets.only(top: 60), width: size.width, child: Row(children: [Container(margin: EdgeInsets.only(top: 16), child: IconButton(onPressed: (){ Navigator.pop(context); }, icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.white, size: 34,)),),Container(margin: EdgeInsets.only(top: 18), width: size.width-60, height: 40, child: SearchBar(hintText: 'Навзвание трека',  onChanged: (text){postRequest(text);}, controller: _searchLanguageController, shadowColor: WidgetStatePropertyAll(Colors.transparent), side: WidgetStatePropertyAll(const BorderSide(color: Colors.white10, width: 2)), overlayColor: WidgetStatePropertyAll(Colors.white10), hintStyle: WidgetStatePropertyAll(TextStyle(
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
                        Container(width: size.width, child: !showno ? (showls ? (_searchLanguageController.text == "" ? _loadListViewhist() : _loadListView()) :  Container(child: Center(child: CircularProgressIndicator(),),)) :
                            Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: [Text("История поиска пуста",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 30,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),),],)
                        )
                      ],),)
                ],),

            ],
          ),
        ),

      ),
    );
  }

  bool showls = false;
  bool showno = false;

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
  List _historysearch = [
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

  _loadSearchedLanguages(String? textVal) {
    if(textVal != null && textVal.isNotEmpty) {
      final data = _langData.where((lang) {
        return lang['name'].toLowerCase().contains(textVal.toLowerCase());
      }).toList();
      setState(() => _searchedLangData = data);
    } else {
      setState(() => _searchedLangData = _langData);
    }
  }



  String imgprofile = "";
  String tokenbf = "";
  bool useri = false;
  Future<void> getpr () async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? ds = prefs.getString("token");
    if(ds != ""){
      print("object"+ds!);
      var urli = Uri.parse("https://kompot.site/getabout?token="+ds);

      var response = await http.get(urli);
      String dff = response.body.toString();

      setState(() {
        var _langData = jsonDecode(dff);
        tokenbf = ds;
        useri = true;
        imgprofile = _langData["img_kompot"];
        print("object"+imgprofile);
      });
    }
  }

  _clearSearch() {
    _searchLanguageController.clear();
    setState(() => _searchedLangData = _langData);
  }

  Widget _loadListViewhist() {
    Size size = MediaQuery.of(context).size;
    return ListView.builder(
      itemCount: _historysearch.length+1,
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
                onCallback(_historysearch[idx-1]['idshaz']);
                final SharedPreferences prefs = await SharedPreferences.getInstance();
                List<String>? sac = prefs.getStringList("historymusid");
                List<String> fsaf = [];
                if (sac != null) {
                  fsaf = sac;
                }
                if(fsaf.length >= 20){
                  fsaf.removeLast();
                }
                fsaf.add(_historysearch[idx-1]['idshaz']);
                await prefs.setStringList("historymusid", fsaf);
              },
              leadingAndTrailingTextStyle: TextStyle(),
              leading: SizedBox(width: 90,
                height: 60,
                child: Row(mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [SizedBox(
                    width: 60,
                    height: 60,
                    child: OverflowBox(
                      maxWidth: double.infinity,
                      maxHeight: double.infinity,
                      child: CachedNetworkImage(
                        imageUrl: _historysearch[idx-1]['img'],
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
                _historysearch[idx-1]['name'],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 246, 244, 244)
                ),
              ),
              subtitle: Text(
                _historysearch[idx-1]['message'],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w300,
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
                if(_searchedLangData[idx-1]["url"]!="0") {
                  onCallback(_searchedLangData[idx - 1]['idshaz']);
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
                }else{
                  installmus(_searchedLangData[idx-1]);
                }

              },
              leadingAndTrailingTextStyle: TextStyle(),
              leading: SizedBox(width: 90,
                height: 60,
                child: Row(mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [SizedBox(
                      width: 60,
                      height: 60,
                      child: OverflowBox(
                        maxWidth: double.infinity,
                        maxHeight: double.infinity,
                        child: CachedNetworkImage(
                          imageUrl: _searchedLangData[idx-1]['img'],
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
                _searchedLangData[idx-1]['name'],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 246, 244, 244)
                ),
              ),
              subtitle: Text(
                _searchedLangData[idx-1]['message'],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w300,
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




  Future<void> historyplaylists() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? sac = prefs.getStringList("historymusid");

    print("dfrd");
    if(sac != null) {
      _historysearch.clear();
      for (var num in sac) {
        var urli = Uri.parse("https://kompot.site/getaboutmus?sidi=" + num);
        var response = await http.get(urli);
        String dff = response.body.toString();
        print("jhghjg");
        print(dff);
        setState(() {
          _historysearch.add(jsonDecode(dff));
        });
      }
      showls = true;
    }else{
      showno = true;
    }
  }

  bool cscs = false;

  Future<void> postRequest (String text) async {
    if(text != '') {
      var urli = Uri.parse("https://kompot.site/getmusshazandr?token=1&nice=" + text);
      var response = await http.get(urli);
      String dff = response.body.toString();
      print(dff);
      setState(() {
        _langData = jsonDecode(dff);
        _searchedLangData = _langData;
        showls = true;
        cscs = showno;
        showno = false;
      });
    }else{
      _searchLanguageController.clear();
      showno = cscs;
    }

  }




}




