import 'dart:async';
import 'dart:convert';
import 'dart:io';


import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;



const kBgColor = Color(0xFF1604E2);

class MusicScreen extends StatefulWidget {
  final  Function(dynamic) onCallback;
  final VoidCallback onCallbacki;
  MusicScreen({Key? key, required this.onCallback, required this.onCallbacki}) : super(key: key);
  @override
  State<MusicScreen> createState() => MusicScreenState((dynamic input) {onCallback(input);},onCallbacki);




}

class MusicScreenState extends State<MusicScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  var iconpla = Icon(Icons.play_arrow_rounded, size: 64, color: Colors.white,);
  void updateIcon(Icon newIcon) {
    setState(() {
      iconpla = newIcon;
    });
  }
  late  Function(dynamic) onCallback;
  late VoidCallback onCallbacki;

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

  MusicScreenState(Function(dynamic) onk,VoidCallback onki){
    onCallback = onk;
    onCallbacki = onki;
  }

  @override
  void initState()
  {
    postRequest();
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
          child:_loadListView(),
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



  _clearSearch() {
    _searchLanguageController.clear();
    setState(() => _searchedLangData = _langData);
  }
   Widget _loadListView() {
    return ListView.builder(
      itemCount: _searchedLangData.length,
      itemBuilder: (BuildContext context, int idx)
    {
      if (idx == 0) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                  Container(alignment: Alignment.topRight, margin: EdgeInsets.only(top: 18), child: IconButton(onPressed: () {}, icon: Icon(Icons.search_rounded, size: 40, color: Colors.white,)),),
                  Container(alignment: Alignment.topRight, margin: EdgeInsets.only(top: 18), child: IconButton(onPressed: () {}, icon: Icon(Icons.circle, size: 46, color: Colors.white,)),)
                ],),

              ],),
            Container(margin: EdgeInsets.only(left: 32,right: 32),
              child:
              Stack(alignment: Alignment.center,
                children: [
                  Image.asset('assets/images/circleblast.png', width: 600,),
                  Container(padding: EdgeInsets.only(left: 12,top: 12),
                      child:
                      Column(children: [ Container(margin: EdgeInsets.only(right: 8), child:Text("Джем",
                        style: TextStyle(
                          fontSize: 40,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),)),Container(margin: EdgeInsets.only(right: 8), child:
                        IconButton(onPressed: ()  {
                          onCallbacki();
                        }, iconSize: 64,
                            icon: iconpla))],)
                  ),
                ],),),
            SizedBox(height: 10,),
            Center(child: Text("Чарт",
              style: TextStyle(
                fontSize: 30,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),),),
            SizedBox(height: 10,),

          ],
        );
      }else{

      return Container(
        margin: const EdgeInsets.only(bottom: 10),
        child: Material(

          color: Color.fromARGB(255, 15, 15, 16),
          borderRadius: BorderRadius.circular(5),
          child: ListTile(
            contentPadding: EdgeInsets.only(
                left: 0, right: 0, bottom: 4, top: 4),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5)),
            onTap: () async {
              onCallback(_searchedLangData[idx-1]['idshaz']);
            },
            leadingAndTrailingTextStyle: TextStyle(),
            leading: SizedBox(width: 90,
              height: 60,
              child: Row(mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: 30, child: Text(
                    (idx).toString(),
                    textAlign: TextAlign.center,

                    style: TextStyle(

                        fontSize: 18,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(255, 246, 244, 244)
                    ),
                  ),), SizedBox(
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
      );
    }
      },
    );
  }


  Future<http.Response> postRequest () async {
    var urli = Uri.parse("https://kompot.site/gettopmusic?lim=20&token=1");

    var response = await http.post(urli,
      headers: {"Content-Type": "application/json; charset=UTF-8"},
      body: jsonEncode(<String, String>{
        'lim': "20",
      }),
    );
    String dff = response.body.toString();
    print(dff);
    setState(() {
      _langData = jsonDecode(dff);
      _searchedLangData = _langData[0];
    });
    return response;
  }



}




