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

class PlaylistScreen extends StatefulWidget {
  final  Function(dynamic) onCallback;
  final VoidCallback hie;
  const PlaylistScreen({Key? key, required this.onCallback, required this.hie}) : super(key: key);
  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState((dynamic input) {onCallback(input);}, hie);




}

class _PlaylistScreenState extends State<PlaylistScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late VoidCallback showsearch;
  late Function(dynamic) onCallback;
  _PlaylistScreenState(Function(dynamic) onk, VoidCallback fg) {
    onCallback = onk;
    showsearch = fg;
  }
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
            Container(alignment: Alignment.topRight, margin: EdgeInsets.only(top: 18), child: IconButton(onPressed: () {}, icon: imgprofile!="" ? SizedBox(height: 44, width: 44, child: CachedNetworkImage(
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

  Future<void> getpr() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? ds = prefs.getString("token");
    if(ds != ""){
      var urli = Uri.parse("https://kompot.site/getabout?token="+ds!);

      var response = await http.get(urli);
      String dff = response.body.toString();

      setState(() {
        var _langData = jsonDecode(dff);

        imgprofile = _langData["img_kompot"];
        print("object"+imgprofile);
      });
    }
  }


  @override
  void dispose() {
    player.dispose();
    super.dispose();
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
                          child: Image(image: AssetImage('assets/images/music.jpg'), width: 60,)),
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
      children: List.generate(_searchedLangData.length, (idx) {
        return idx == 0 ?  CustomTile(title: "История", imageUrl: 'assets/images/music.jpg', wih: size.width, fd: true,) : idx == 1 ?  CustomTile(title: "Мне нравится", imageUrl: "assets/images/loveplaylist.gif", wih: size.width,fd: true,) : CustomTile(title: _searchedLangData[idx]['name'], imageUrl: _searchedLangData[idx]['img'], wih: size.width,fd: false,);
      }),))]
    );
  }

  Future<void> postRequest () async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? ds = prefs.getString("token");
    if(ds != "") {
      var urli = Uri.parse("https://kompot.site/getmusicplaylist?tokeni="+ds!);

      var response = await http.get(urli);
      String dff = response.body.toString();
      print("hjk"+dff);
      setState(() {
        _langData = jsonDecode(dff)[0];
        _searchedLangData = _langData;
      });
    }
  }


}


class CustomTile extends StatelessWidget {
  final String title;
  final String imageUrl;
  final double wih;
  final bool fd;
  CustomTile({
    required this.title,
    required this.imageUrl,
    required this.wih,
    required this.fd,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child:  Stack(children: [ SizedBox(height: wih/2, width: wih/2,  child:Column(
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
          ],
        )),SizedBox(height: wih/4, width: wih/4,  child: ElevatedButton(
          onPressed: () {

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

