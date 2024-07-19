import 'dart:async';
import 'dart:convert';
import 'dart:io';


import 'package:blast/screens/playlist_screen.dart';
import 'package:blast/screens/video_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'music_screen.dart';



const kBgColor = Color(0xFF1604E2);

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();




}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  void initState()
  {

    super.initState();
  }
  String musicUrl = ""; // Insert your music URL
  String thumbnailImgUrl = "";
  var player = AudioPlayer();
  @override
  Widget build(BuildContext context) {
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
        backgroundColor: const Color.fromARGB(255, 15, 15, 16),
        bottomNavigationBar: buildMyNavBar(context),
      body: pages[pageIndex]
    );
  }




  Container buildMyNavBar(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 25, 24, 24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            enableFeedback: false,
            onPressed: () {
              setState(() {
                pageIndex = 0;
              });
            },

            icon: pageIndex == 0
                ? const Image(
                color: Color.fromARGB(255, 255, 255, 255),
                image: AssetImage('assets/images/playlisst.png'),
                width: 30
            )
                : const Image(
                color: Color.fromARGB(255, 123, 123, 124),
                image: AssetImage('assets/images/playlisst.png'),
                width: 30
            ),
          ),
          IconButton(
            enableFeedback: false,
            onPressed: () {
              setState(() {
                pageIndex = 1;
              });
            },
            icon: pageIndex == 1
                ? const Image(
                color: Color.fromARGB(255, 255, 255, 255),
                image: AssetImage('assets/images/musicon.png'),
                width: 30
            )
                : const Image(
                color: Color.fromARGB(255, 123, 123, 124),
                image: AssetImage('assets/images/musicon.png'),
                width: 30
            ),
          ),
          IconButton(
            enableFeedback: false,
            onPressed: () {
              setState(() {
                pageIndex = 2;
              });
            },
            icon: pageIndex == 2
                ? const Image(
                color: Color.fromARGB(255, 255, 255, 255),
                image: AssetImage('assets/images/video.png'),
                width: 30
            )
                : const Image(
                color: Color.fromARGB(255, 123, 123, 124),
                image: AssetImage('assets/images/video.png'),
                width: 30
            ),
          ),
        ],
      ),
    );
  }
  int pageIndex = 1;

  final pages = [
    PlaylistScreen(),
    MusicScreen(),
    VideoScreen(),
  ];

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }






}




