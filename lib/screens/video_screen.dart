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

class VideoScreen extends StatefulWidget {
  final  Function(dynamic) onCallback;
  final VoidCallback hie;
  final VoidCallback showlog;
  final VoidCallback dsad;
  const VideoScreen({Key? key, required this.onCallback, required this.hie, required this.showlog, required this.dsad}) : super(key: key);

  @override
  State<VideoScreen> createState() => _VideoScreenState((dynamic input) {onCallback(input);}, hie,showlog,dsad);

}

class _VideoScreenState extends State<VideoScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late VoidCallback showsearch;
  late VoidCallback showlog;
  late Function(dynamic) onCallback;
  late VoidCallback reseti;
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
    getpr();
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
      extendBody: true,
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
          child:
        Column(
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
            Container(alignment: Alignment.topRight, margin: EdgeInsets.only(top: 18), child: IconButton(onPressed: () {showsearch();}, icon: Icon(Icons.search_rounded, size: 40, color: Colors.white,)),),
            Container(alignment: Alignment.topRight, margin: EdgeInsets.only(top: 18), child: IconButton(onPressed: useri ? () { Navigator.push(context, MaterialPageRoute(builder: (context) =>  ProfileScreen(reseti:reseti))); } : showlog, icon: imgprofile!="" ? SizedBox(height: 44, width: 44, child: CachedNetworkImage(
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
          Container(padding: EdgeInsets.only(top: 80), height: size.height,
            child:size.width > 1200 ? _loadGridView() : size.width > 800 ? _loadGridView2() : _loadListView()
            ,),
        ],),


          ],
        ),
      ),

      ),
    );
  }


  List _searchedLangData = [];

  final _searchLanguageController = TextEditingController();

  _VideoScreenState(Function(dynamic) onk, VoidCallback fg, VoidCallback dawsd, VoidCallback gbdfgb) {
    onCallback = onk;
    showsearch = fg;
    showlog = dawsd;
    reseti = gbdfgb;
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
    return Container(height: size.height, child: ListView.builder(
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
    )
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
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              ),],
          ),

          ],)

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
      )),
        Container(alignment: Alignment.bottomCenter, child:
        Container(height: 62, child:
Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Row(mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.end, children: [
          IconButton(

            icon: Icon(Icons.more_vert),
            color: Colors.white,
            onPressed: () {},
          )],)])))
      ],)
    );
  }


}



