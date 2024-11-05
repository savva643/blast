import 'dart:async';
import 'dart:convert';
import 'dart:io';


import 'package:audio_service/audio_service.dart';
import 'package:blast/screens/login.dart';
import 'package:blast/screens/profile_screen.dart';
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

class MusicScreen extends StatefulWidget {
  final  Function(dynamic) onCallback;
  final VoidCallback onCallbacki;
  final VoidCallback hie;
  final VoidCallback showlog;
  final VoidCallback resre;
  final VoidCallback essension;
  MusicScreen({Key? key, required this.onCallback, required this.onCallbacki, required this.hie, required this.showlog, required this.resre, required this.essension}) : super(key: key);
  @override
  State<MusicScreen> createState() => MusicScreenState((dynamic input) {onCallback(input);},onCallbacki, hie, showlog, resre,essension);




}

class MusicScreenState extends State<MusicScreen> with TickerProviderStateMixin{
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late AnimationController controllermuscircle;

  late AnimationController _controllere;
  double dragValue = 0.0;


  var iconplaese = Icon(Icons.play_arrow_rounded, size: 64, color: Colors.white,key: ValueKey<bool>(AudioService.playbackState.playing));
  var iconpla = Icon(Icons.play_arrow_rounded, size: 64, color: Colors.white,key: ValueKey<bool>(AudioService.playbackState.playing));
  void updateIcon(Icon newIcon) {
    setState(() {
      iconpla = newIcon;
    });
  }
  void updateIconese(Icon newIcon) {
    setState(() {
      iconplaese = newIcon;
    });
  }
  late  Function(dynamic) onCallback;
  late VoidCallback onCallbacki;
  late VoidCallback essension;
  late VoidCallback showsearch;
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

  void _showSmallDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(child: Container(margin: EdgeInsets.only(right: 100, left: 100, bottom: 80, top: 80), padding: EdgeInsets.only(right: 60, left: 60, bottom: 60, top: 60), decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(40)), color: Color.fromARGB(255, 15, 15, 16)),child:
        Column(mainAxisSize: MainAxisSize.min,
          children: [
          Text("blast! находится в alpha",
          style: TextStyle(
            fontSize: 30,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),),
          Text("История обновления",
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),),
        Expanded(child:
        ListView.builder(
        itemCount: 1,
        itemBuilder: (BuildContext context, int idx)
        {
        return Container(child: Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [Text("Функция Эссенция",
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),),
          Text("Это инструмент, который позволяет пользователю познакомиться с треками через наиболее выразительные и запоминающиеся фрагменты. Каждая песня в библиотеке имеет короткий отрывок, специально подобранный для максимального впечатления, который и составляет её Эссенцию.",
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),)
        ],),);

        },
        ))
        ],),));
      },
    );
  }





  MusicScreenState(Function(dynamic) onk,VoidCallback onki, VoidCallback fg, VoidCallback dawsd, VoidCallback dsacf, VoidCallback dsacfdcs){
    onCallback = onk;
    onCallbacki = onki;
    showsearch = fg;
    showlog = dawsd;
    reseti = dsacf;
    essension = dsacfdcs;
  }
  late Animation<double> _animation;
  late Animation<double> _animationi;
  bool isAnimating = false;
  bool isAnimatingi = false;
  void toggleAnimation(bool ds) {
    setState(() {
      if (ds) {
        controllermuscircle.repeat();
      } else {
        controllermuscircle.animateTo(controllermuscircle.value+0.01, duration: const Duration(seconds: 1));
      }
      isAnimating = ds;
    });
  }


  void toggleAnimationese(bool ds) {
    setState(() {
      if (ds) {
        _controllere.repeat();
      } else {
        _controllere.animateTo(_controllere.value+0.01, duration: const Duration(seconds: 1));
      }
      isAnimatingi = ds;
    });
  }

  @override
  void initState()
  {
    postRequest();
    getpr();
    controllermuscircle = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 50),
    )..repeat();

    _controllere = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30), // Задаем время полного оборота
    );

    _animation = CurvedAnimation(
      parent: controllermuscircle,
      curve: Curves.easeInOut,  // Плавное ускорение и замедление
    );

    _animationi = CurvedAnimation(
      parent: _controllere,
      curve: Curves.easeInOut,  // Плавное ускорение и замедление
    );
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
                PageView(
                  physics: BouncingScrollPhysics(),
                  children: [
                    Container(margin: EdgeInsets.only(left: 32,right: 32), alignment: Alignment.center, child:
                    Stack(alignment: Alignment.center,
                      children: [
                        RotationTransition(
                            turns: Tween(begin: 0.0, end: 1.0).animate(controllermuscircle),
                            child:Image.asset('assets/images/circleblast.png', width: 800,)),
                        Container(padding: EdgeInsets.only(left: 12,top: 12),
                            child:
                            Column(mainAxisAlignment: MainAxisAlignment.center, children: [ Container(margin: EdgeInsets.only(right: 8), child:Text("Джем",
                              style: TextStyle(
                                fontSize: 40,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),)),Container(margin: EdgeInsets.only(right: 8), child:
                            IconButton(onPressed: ()  {
                              onCallbacki();
                            }, iconSize: 64,
                                icon: AnimatedSwitcher(
                                    duration: Duration(milliseconds: 300),
                                    transitionBuilder: (Widget child, Animation<double> animation) {
                                      return RotationTransition(
                                        turns: Tween(begin: 0.75, end: 1.0).animate(animation),
                                        child: ScaleTransition(scale: animation, child: child),
                                      );
                                    },
                                    child:iconpla)))],)
                        ),
                      ],)),
                    Container(child:   Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(margin: EdgeInsets.only(left: 40,right: 40), child:
                        RotationTransition(
                            turns: Tween(begin: 0.0, end: 1.0).animate(_controllere),
                            child:Image.asset('assets/images/forclock.png', width: 800,))),
                        // Часовая стрелка (короче)
                        Container(height: 360, width: 360, child:
                        RotationTransition(
                          turns: Tween(begin: 0.0, end: 1.0).animate(
                            CurvedAnimation(
                              parent: _controllere,
                              curve: Curves.linear,
                            ),
                          ),
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              height: 200, // Половина длины для часовой стрелки
                              width: 40,
                              decoration: BoxDecoration(color: Colors.purpleAccent,borderRadius: BorderRadius.all(Radius.circular(200))),
                            ),
                          ),
                        )),
                        // Минутная стрелка (длиннее)
                        Container(height: 280, width: 280, child:
                        RotationTransition(
                          turns: Tween(begin: 0.0, end: 12.0).animate(
                            CurvedAnimation(
                              parent: _controllere,
                              curve: Curves.linear,
                            ),
                          ),
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              height: 160, // Длина минутной стрелки чуть больше
                              width: 40,
                              decoration: BoxDecoration(color: Colors.purple,borderRadius: BorderRadius.all(Radius.circular(200))),
                            ),
                          ),
                        )),
                        Container(padding: EdgeInsets.only(left: 12,top: 12),
                            child:
                            Column(mainAxisAlignment: MainAxisAlignment.center, children: [ Container(margin: EdgeInsets.only(right: 8), child:Text("Эссенция",
                              style: TextStyle(
                                fontSize: 40,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),)),Container(margin: EdgeInsets.only(right: 8), child:
                            IconButton(onPressed: ()  {
                              essension();
                            }, iconSize: 64,
                                icon: AnimatedSwitcher(
                                    duration: Duration(milliseconds: 300),
                                    transitionBuilder: (Widget child, Animation<double> animation) {
                                      return RotationTransition(
                                        turns: Tween(begin: 0.75, end: 1.0).animate(animation),
                                        child: ScaleTransition(scale: animation, child: child),
                                      );
                                    },
                                    child:iconplaese)))],)
                        ),
                      ],
                    ),
                    )

                  ],), Container(child: Row(children: [Expanded(child: Container()), Container(alignment: Alignment.topRight, margin: EdgeInsets.only(top: 21), child: IconButton(onPressed: () {showsearch();}, icon: Icon(Icons.search_rounded, size: 40, color: Colors.white,)),),
                Container(alignment: Alignment.topRight, margin: EdgeInsets.only(top: 18), child: IconButton(onPressed:  useri ? () { Navigator.push(context, MaterialPageRoute(builder: (context) =>  ProfileScreen(reseti: reseti,))); } : showlog, icon: imgprofile!="" ? SizedBox(height: 44, width: 44, child: CachedNetworkImage(
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
    controllermuscircle.dispose();
    _controllere.dispose();
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
                    Container(padding: EdgeInsets.only(left: 6,top: 13),child:  TextButton(onPressed: () {_showSmallDialog(context);}, style: ButtonStyle(backgroundColor: MaterialStateProperty.resolveWith<Color?>(
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
    return ListView.builder(
      itemCount: _searchedLangData.length+1,
      itemBuilder: (BuildContext context, int idx)
    {
      if (idx == 0) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
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
                      ),)),
                  Container(padding: EdgeInsets.only(left: 6,top: 2),child:  TextButton(onPressed: () {_showSmallDialog(context);}, style: ButtonStyle(backgroundColor: MaterialStateProperty.resolveWith<Color?>(
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
                  )) : Icon(Icons.circle, size: 46, color: Colors.white,)),)
                ],),

              ],),
            Container(height: size.width,
              child:
              PageView(
                physics: BouncingScrollPhysics(),
                children: [
                Container(margin: EdgeInsets.only(left: 32,right: 32), alignment: Alignment.center, child:
              Stack(alignment: Alignment.center,
                children: [
                     RotationTransition(
                         turns: Tween(begin: 0.0, end: 1.0).animate(controllermuscircle),
                         child:Image.asset('assets/images/circleblast.png', width: 800,)),
                      Container(padding: EdgeInsets.only(left: 12,top: 12),
                      child:
                      Column(mainAxisAlignment: MainAxisAlignment.center, children: [ Container(margin: EdgeInsets.only(right: 8), child:Text("Джем",
                        style: TextStyle(
                          fontSize: 40,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),)),Container(margin: EdgeInsets.only(right: 8), child:
                        IconButton(onPressed: ()  {
                          onCallbacki();
                        }, iconSize: 64,
                            icon: AnimatedSwitcher(
                                duration: Duration(milliseconds: 300),
                                transitionBuilder: (Widget child, Animation<double> animation) {
                                  return RotationTransition(
                                    turns: Tween(begin: 0.75, end: 1.0).animate(animation),
                                    child: ScaleTransition(scale: animation, child: child),
                                  );
                                },
                                child:iconpla)))],)
                  ),
                ],)),
                  Container( margin: EdgeInsets.only(left: 32,right: 32), child:   Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(padding: EdgeInsets.only(left: 12,right: 12), child:
                      RotationTransition(
                          turns: Tween(begin: 0.0, end: 1.0).animate(_controllere),
                          child:Image.asset('assets/images/forclock.png', width: 800,))),
                      // Часовая стрелка (короче)
                      Container(height: 360, width: 360, child:
                      RotationTransition(
                        turns: Tween(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                            parent: _controllere,
                            curve: Curves.linear,
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            height: 200, // Половина длины для часовой стрелки
                            width: 40,
                            decoration: BoxDecoration(color: Colors.purpleAccent,borderRadius: BorderRadius.all(Radius.circular(200))),
                          ),
                        ),
                      )),
                      // Минутная стрелка (длиннее)
                      Container(height: 280, width: 280, child:
                      RotationTransition(
                        turns: Tween(begin: 0.0, end: 12.0).animate(
                          CurvedAnimation(
                            parent: _controllere,
                            curve: Curves.linear,
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            height: 160, // Длина минутной стрелки чуть больше
                            width: 40,
                            decoration: BoxDecoration(color: Colors.purple,borderRadius: BorderRadius.all(Radius.circular(200))),
                          ),
                        ),
                      )),
                      Container(padding: EdgeInsets.only(left: 12,top: 12),
                          child:
                          Column(mainAxisAlignment: MainAxisAlignment.center, children: [ Container(margin: EdgeInsets.only(right: 8), child:Text("Эссенция",
                            style: TextStyle(
                              fontSize: 40,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),)),Container(margin: EdgeInsets.only(right: 8), child:
                          IconButton(onPressed: ()  {
                            essension();
                          }, iconSize: 64,
                              icon: AnimatedSwitcher(
                                  duration: Duration(milliseconds: 300),
                                  transitionBuilder: (Widget child, Animation<double> animation) {
                                    return RotationTransition(
                                      turns: Tween(begin: 0.75, end: 1.0).animate(animation),
                                      child: ScaleTransition(scale: animation, child: child),
                                    );
                                  },
                                  child:iconplaese)))],)
                      ),
                    ],
                  ),
                  )

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
            trailing: Container(padding: EdgeInsets.only(right: 4), child:  Row( mainAxisSize: MainAxisSize.min, // This ensures Row takes minimal width
              mainAxisAlignment: MainAxisAlignment.end,  children: [_searchedLangData[idx-1]['install'] == "1" ? Icon(Icons.file_download_outlined, color: Colors.green,) : Container(), _searchedLangData[idx-1]['install'] == "1" ? SizedBox(width: 4,) :  Container(), IconButton(icon: Icon(Icons.more_vert),
              color: Colors.white,
              onPressed: () {},)],)) ,
          ),
        ),
      );
    }
      },
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




