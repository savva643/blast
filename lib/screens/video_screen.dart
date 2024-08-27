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
            Container(margin: EdgeInsets.only(top: 0),
              child:
            Stack(alignment: Alignment.center,
              children: [
                Container(width: size.width, height: 400, child:
                _loadListView()
                )
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

  Widget _loadListView() {
    Size size = MediaQuery.of(context).size;
    return ListView.builder(
      itemCount: _searchedLangData.length,
      itemBuilder: (BuildContext context, int idx)
      {
          return Container(
            height: 300,
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

                },
                leadingAndTrailingTextStyle: TextStyle(),
                leading:  Transform.translate(
                    offset: Offset(0, 180),
                    child: AspectRatio(aspectRatio: 1, child:  SizedBox(width: size.width, child:  CachedNetworkImage(
                            imageUrl: _searchedLangData[idx]['imgvidos'],
                            imageBuilder: (context, imageProvider) =>
                                Container(
                                  padding: EdgeInsets.only(
                                      left: 0, right: 0, bottom: 0, top: 0),
                                  width: size.width,
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
                          ),)
                        ),),
                title: Text(
                  _searchedLangData[idx]['name'],
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
                  _searchedLangData[idx]['message'],
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
      },
    );
  }


  Future<http.Response> postRequest () async {
    var urli = Uri.parse("https://kompot.site/getvideomus");

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
      _searchedLangData = _langData;
    });
    return response;
  }


}




