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
  final  Function(dynamic) onCallback;
  const VideoScreen({Key? key, required this.onCallback}) : super(key: key);

  @override
  State<VideoScreen> createState() => _VideoScreenState((dynamic input) {onCallback(input);});




}

class _VideoScreenState extends State<VideoScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late Function(dynamic) onCallback;
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
                Container(width: size.width, height: size.height-200, child:
                size.width > 1200 ? _loadGridView() : size.width > 800 ? _loadGridView2() : _loadListView()
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

  _VideoScreenState(Function(dynamic) onk) {
    onCallback = onk;
  }


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

  Widget _loadGridView2() {
    Size size = MediaQuery.of(context).size;
    return GridView(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisExtent: ((size.width/16)*4.1),
        crossAxisSpacing: 20,
        mainAxisSpacing: 10,
      ),
      children: List.generate(_searchedLangData.length, (idx) {
        return CustomTile(
          title: _searchedLangData[idx]['name'],
          subtitle: _searchedLangData[idx]['message'],
          imageUrl: _searchedLangData[idx]['imgvidos'],
          wih: size.width,
          urlo: _searchedLangData[idx]['idshaz'],
          onCallback: (dynamic input) {onCallback(input);},
        );
      }),
    );
  }

  Widget _loadGridView() {
    Size size = MediaQuery.of(context).size;
    return GridView(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisExtent: ((size.width/16)*3),
        crossAxisSpacing: 20,
        mainAxisSpacing: 10,
      ),
      children: List.generate(_searchedLangData.length, (idx) {
        return CustomTile(
          title: _searchedLangData[idx]['name'],
          subtitle: _searchedLangData[idx]['message'],
          imageUrl: _searchedLangData[idx]['imgvidos'],
          wih: size.width,
          urlo: _searchedLangData[idx]['idshaz'],
          onCallback: (dynamic input) {onCallback(input);},
        );
      }),
    );
  }



  Widget _loadListView() {
    Size size = MediaQuery.of(context).size;
    return ListView.builder(
      itemCount: _searchedLangData.length,
      itemBuilder: (BuildContext context, int idx)
      {
          return CustomTile(
            title: _searchedLangData[idx]['name'],
            subtitle: _searchedLangData[idx]['message'],
            imageUrl: _searchedLangData[idx]['imgvidos'],
            wih: size.width,
            urlo: _searchedLangData[idx]['idshaz'],
            onCallback: (dynamic input) {onCallback(input);},
          );
      },
    );
  }


  Future<http.Response> postRequest () async {
    var urli = Uri.parse("https://kompot.site/getvideomus");

    var response = await http.get(urli);
    String dff = response.body.toString();
    print(dff);
    setState(() {
      _langData = jsonDecode(dff);
      _searchedLangData = _langData;
    });
    return response;
  }


}
class CustomTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;
  final double wih;
  final String urlo;
  Function(dynamic) onCallback;
  CustomTile({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.wih,
    required this.urlo,
    required this.onCallback,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child:  Stack(children: [ Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [AspectRatio(aspectRatio: 16/9, child:
          CachedNetworkImage(
            imageUrl: imageUrl,
            imageBuilder: (context, imageProvider) =>
                Container(
                  padding: EdgeInsets.only(
                      left: 0, right: 0, bottom: 0, top: 0),
                  width: wih,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(18),
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.fitWidth),
                  ),
                ),
            placeholder: (context, url) =>
                CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),)
          ),
          SizedBox(height: 8),
          Text(
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
          Text(
            subtitle,
            textAlign: TextAlign.start,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: 14,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w300,
                color: Color.fromARGB(255, 246, 244, 244)
            ),
          ),
        ],
      ),SizedBox(height: ((size.width/16)*9)+40, width: size.width,  child: ElevatedButton(
        onPressed: () {
          onCallback(urlo);
        },

        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18), // Скругленные углы
          ),
          backgroundColor: Colors.transparent, // Прозрачный фон
          shadowColor: Colors.transparent, // Убираем тень
          elevation: 0, // Убираем эффект возвышенности
        ), child: Container(width: wih,),
      ))],)
    );
  }
}



