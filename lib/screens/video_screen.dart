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

class VideoScreen extends StatefulWidget {
  const VideoScreen({Key? key}) : super(key: key);
  @override
  State<VideoScreen> createState() => _VideoScreenState();




}

class _VideoScreenState extends State<VideoScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  List _langData = [
    {
      'id': '1',
      'img': 'assets/images/usa.jpeg',
      'name': 'English',
    },
    {
      'id': '2',
      'img': 'assets/images/russia.png',
      'name': 'Русский',
    },
  ];
  @override
  void initState()
  {
    postRequest();
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
        ListView(
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
          Container(padding: EdgeInsets.only(left: 12,top: 12),
              child:
              Text("blast!",
                style: TextStyle(
                  fontSize: 40,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),)),
        ],),
            Container(margin: EdgeInsets.only(left: 32,right: 32),
              child:
            Stack(alignment: Alignment.center,
              children: [
              Image.asset('assets/images/circleblast.png', width: 600,),
              Container(padding: EdgeInsets.only(left: 12,top: 12),
                  child:
                      Column(children: [ Text("Джем",
                        style: TextStyle(
                          fontSize: 40,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),),
                        IconButton(onPressed: ()  {
                           player.setUrl("https://kompot.site/music/436.mp3");
                           player.play();
                        }, iconSize: 56, icon: Image.asset('assets/images/plays.png',width: 56, height: 56)),],)
                  ),
            ],),),

          ],
        ),
      ),

      ),
    );
  }


  List _searchedLangData = [];

  final _searchLanguageController = TextEditingController();


  @override
  void dispose() {
    player.dispose();
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

  Widget _loadGridView() {
    return GridView(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 170.0,
        crossAxisSpacing: 20,
        mainAxisSpacing: 10,
      ),
      children: List.generate(_searchedLangData.length, (idx) {
        return Material(
          borderRadius: BorderRadius.circular(10),
          color: Color.fromARGB(255, 244, 244, 246),
          child: InkWell(
            splashColor: Colors.redAccent,
            borderRadius: BorderRadius.circular(10),
            onTap: () async {

            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            Container(
              alignment: Alignment.topLeft,
              margin: const EdgeInsets.only(left: 10,top: 6),
              child:Text(
                  _langData[idx]['name'],
                  textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                  style: const TextStyle(
                    fontSize: 20,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child:SizedBox(
                  width: 110,
                  height: 110,
                  child: CachedNetworkImage(
                    imageUrl: _searchedLangData[idx]['img'],
                  ),
                ),
            ),
              ],
            ),
          ),
        );
      }),
    );
  }
  Future<http.Response> postRequest () async {
    var urli = Uri.parse("https://magazinchik.keeppixel.store/flutterapi.php?getcategory=1");

    var response = await http.post(urli,
      headers: {"Content-Type": "application/json; charset=UTF-8"},
      body: jsonEncode(<String, String>{
        'login': "klkjh",
      }),
    );
    String dff = response.body.toString();
    print(dff);
    setState(() {
      _langData = jsonDecode(dff);
      _searchedLangData = _langData;
    });
    return response;
  }


}




