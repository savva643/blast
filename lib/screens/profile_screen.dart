import 'dart:async';
import 'dart:convert';
import 'dart:io';


import 'package:blast/screens/login.dart';
import 'package:blast/screens/search_screen.dart';
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

class ProfileScreen extends StatefulWidget {
  final VoidCallback reseti;
  ProfileScreen({Key? key, required this.reseti}) : super(key: key);
  @override
  State<ProfileScreen> createState() => ProfileScreenState(reseti);




}

class ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  var iconpla = Icon(Icons.play_arrow_rounded, size: 64, color: Colors.white,);
  void updateIcon(Icon newIcon) {
    setState(() {
      iconpla = newIcon;
    });
  }
  late VoidCallback resetapp;
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

  ProfileScreenState(VoidCallback sdas){
    resetapp = sdas;
  }

  @override
  void initState()
  {
    postRequest();
    getpr();
    super.initState();
  }

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
          child: size.width > 800 ? SizedBox(width: size.width, height: size.height, child: Container(width: size.width, height: size.height, child: Row(children: [ SizedBox(height: size.height, width: size.width/2, child:_loadListViewMore()),  Container(width: size.width/2,
              child: Stack(alignment: Alignment.topRight, children: [ Center(child:
              Stack(alignment: Alignment.center,
                children: [
                  Image.asset('assets/images/circleblast.png', width: 600,),
                  Center(child:Container(padding: EdgeInsets.only(left: 12,top: 12),
                      child:
                      Column(mainAxisAlignment: MainAxisAlignment.center,children: [ Container(margin: EdgeInsets.only(right: 8), child:Text("Джем",
                        style: TextStyle(
                          fontSize: 50,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),)),Container(margin: EdgeInsets.only(right: 8), child:
                      IconButton(onPressed: ()  {

                      }, iconSize: 74,
                          icon: iconpla))],)
                  )), Container(child: Row(children: [Expanded(child: Container()), Container(alignment: Alignment.topRight, margin: EdgeInsets.only(top: 21), child: IconButton(onPressed: () {}, icon: Icon(Icons.search_rounded, size: 40, color: Colors.white,)),),
                    Container(alignment: Alignment.topRight, margin: EdgeInsets.only(top: 18), child: IconButton(onPressed:  () {}, icon: imgprofile!="" ? SizedBox(height: 44, width: 44, child: CachedNetworkImage(
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
                    )) : Icon(Icons.circle, size: 46, color: Colors.white,)),)],),)
                ],),)],)),],),))  : _loadListView(),
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

  Widget _loadListViewMore() {
    Size size = MediaQuery.of(context).size;
    return ListView.builder(
      itemCount: _searchedLangData.length+1,
      itemBuilder: (BuildContext context, int idx)
      {
        return SizedBox(child: idx == 0 ?  Column(
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
                  Container(padding: EdgeInsets.only(left: 12,top: 12),
                      child:
                      Text("blast!",
                        style: TextStyle(
                          fontSize: 40,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),)),
                  Container(padding: EdgeInsets.only(left: 6,top: 13),child:  TextButton(onPressed: () {}, style: ButtonStyle(backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed)) {
                        return Colors.grey[900]; // Darker grey when pressed
                      } else if (states.contains(MaterialState.hovered)) {
                        return Colors.grey[700]; // Lighter grey when hovered
                      }
                      return Colors.grey[800]; // Default grey color
                    },
                  ), ),child: Text("alpha",
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      )))), Expanded(child: Container()),

                ],),

              ],),
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
        )
            :
        Container(
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
              trailing:  Padding(
                padding: EdgeInsets.only(right: 20.0), // Set padding as needed
                child: Row(
                  mainAxisSize: MainAxisSize.min, // This ensures Row takes minimal width
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(Icons.more_vert),
                      color: Colors.white,
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
        );
      },
    );
  }


  Widget _loadListView() {
    Size size = MediaQuery.of(context).size;
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
                    Container(padding: EdgeInsets.only(left: 12,top: 12),
                        child:
                        Text("blast!",
                          style: TextStyle(
                            fontSize: 40,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),)),
                   Expanded(child: Container()),
                  ],),
                  Container(margin: EdgeInsets.only(left: 0), padding: EdgeInsets.only(top: 56), child:
                  Row(children: [Container(margin: EdgeInsets.only(top: 0), child: IconButton(onPressed: (){ Navigator.pop(context); }, icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.white, size: 34,)),),
                    Text("Аккаунт",
                      style: TextStyle(
                        fontSize: 30,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),)],)),
                ],),

              Container(alignment: Alignment.center,
                child:
                Container(margin: EdgeInsets.only(top: 0), child: imgprofile!="" ? SizedBox(height: 120, width: 120, child: CachedNetworkImage(
                  imageUrl: imgprofile, // Replace with your image URL
                  imageBuilder: (context, imageProvider) => Container(
                    width: 120.0, // Set the width of the circular image
                    height: 120.0, // Set the height of the circular image
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
                )) : Icon(Icons.circle, size: 132, color: Colors.white,),),),
              SizedBox(height: 6,),
            Container(alignment: Alignment.center,child: Text(nameprofile,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 36,
                height: 1,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),),),
              Container(alignment: Alignment.center,child: Text(emailprofile,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w700,
                  color: Colors.grey,
                ),),),
              SizedBox(height: 16,),
              Container(
                padding: const EdgeInsets.only(left: 14, right: 14),
                child: Material(

                  color: Color(0xff333333),
                  borderRadius: BorderRadius.circular(10),
                  child: ListTile(
                    contentPadding: EdgeInsets.only(
                        left: 8, right: 8, bottom: 4, top: 4),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    onTap: () async {

                    },
                    leadingAndTrailingTextStyle: TextStyle(),
                    title: Text(
                      "Настройки",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 246, 244, 244)
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(child: Container()),
              Container(
                padding: const EdgeInsets.only(left: 14, right: 14, bottom: 140),
                child: Material(

                  color: Color(0xff333333),
                  borderRadius: BorderRadius.circular(10),
                  child: ListTile(
                    contentPadding: EdgeInsets.only(
                        left: 8, right: 8, bottom: 4, top: 4),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    onTap: () async {
                      final SharedPreferences prefs = await SharedPreferences.getInstance();
                      await prefs.remove("token");
                      resetapp();
                    },
                    leadingAndTrailingTextStyle: TextStyle(),
                    title: Text(
                      textAlign: TextAlign.center,
                      "Выйти",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 22,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 255, 0, 0)
                      ),
                    ),
                  ),
                ),
              )
            ],
          );

  }


  Future<http.Response> postRequest () async {
    var urli = Uri.parse("https://kompot.site/gettopmusic?lim=20&token=1");

    var response = await http.get(urli);
    String dff = response.body.toString();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? sac = prefs.getStringList("installmusid");

    setState(() {
      _langData =  jsonDecode(dff)[0];
      for (var i = 0; i < _langData.length; i++) {
        if (sac != null) {
          if (!sac.isEmpty) {
            if (sac.contains(_langData[i]["idshaz"])) {
              (_langData[i] as Map<String, dynamic>)["install"] = "1";
            } else {
              (_langData[i] as Map<String, dynamic>)["install"] = "0";
            }
          } else {
            (_langData[i] as Map<String, dynamic>)["install"] = "0";
          }
        }else{
          (_langData[i] as Map<String, dynamic>)["install"] = "0";
        }
      }
      _searchedLangData = _langData;

    });
    return response;
  }

  String imgprofile = "";
  String nameprofile = "";
  String emailprofile = "";
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
        nameprofile = _langData["name_kompot"];
        emailprofile = _langData["email"];
        print("object"+imgprofile);
      });
    }
  }

}




