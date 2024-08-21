import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:audio_service/audio_service.dart';
import 'package:blast/screens/playlist_screen.dart';
import 'package:blast/screens/video_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'AudioManager.dart';
import 'background_task.dart';
import 'music_screen.dart';



const kBgColor = Color(0xFF1604E2);

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();




}


class _HomeScreenState extends State<HomeScreen>{
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();




  String idmus = "0";
  String namemus = "Название";
  String ispolmus = "Исполнитель";
  String imgmus = "https://kompot.site/img/music.jpg";

  get listok => null;

  @override
  void initState()
  {
    super.initState();

  }

  Future<void> _playNewTrack(String url) async {
    print("object");
      await AudioService.customAction('playNewTrack', {'url': url});

  }

  bool frstsd = false;
  Future<void> playmusa(dynamic listok) async {
    if(idmus != listok["id"]) {
      if(frstsd) {
        _playNewTrack(listok['url']);
      }else{
        frstsd = true;
        await AudioService.start(
          backgroundTaskEntrypoint: _audioPlayerTaskEntrypoint,
          params: {'url': listok['url']},
        );
      }
      setState(() {
        iconpla = Icon(Icons.pause_rounded, size: 40,);
        namemus = listok["name"];
        ispolmus = listok["message"];
        imgmus = listok['img'];
        idmus = listok['id'];
      });
    }else{
      if(AudioService.playbackState.playing){
        AudioService.pause();
        setState(() {
          iconpla = Icon(Icons.play_arrow_rounded, size: 40,);
        });
      }else{
        AudioService.play();
        setState(() {
          iconpla = Icon(Icons.pause_rounded, size: 40,);
        });
      }
    }

  }
 
  String musicUrl = ""; // Insert your music URL
  String thumbnailImgUrl = "";
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
  double _currentValue = 3;
  void _showModalSheet(){
    Size size = MediaQuery.of(context).size;
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (builder){
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Consumer<AudioManager>(
                    builder: (context, notifier, child) {

                 return Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(color: const Color.fromARGB(255, 15, 15, 16),),
                  Image.network(
                  imgmus, // URL вашей фоновой картинки
                  fit: BoxFit.cover,
                ),
                BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                color: Colors.black.withOpacity(0), // Контейнер для применения размытия
                ),
                ),
                  Container(
                    height: size.height,

                    child: Column(children: [
                      Container(  height: 360, width: 360, margin: EdgeInsets.only(left: 20, right: 20,top: 60),
                        child:
                        CachedNetworkImage(
                          imageUrl: imgmus,
                          imageBuilder: (context, imageProvider) =>
                              Container(
                                width: 400.0,
                                height: 400.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(20),
                                  image: DecorationImage(
                                      image: imageProvider),
                                ),
                              ),
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        ),),
                      Text(namemus,
                        style: TextStyle(
                            fontSize: 30,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w500,
                            color: Color.fromARGB(255, 246, 244, 244)
                        ),),
                      Text(ispolmus,
                        style: TextStyle(
                            fontSize: 24,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w300,
                            color: Color.fromARGB(255, 246, 244, 244)
                        ),),
                      Padding(padding: EdgeInsets.only(top: 16,left: 22, right: 22), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(notifier.position.inSeconds.toString(),
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w400,
                            color: Color.fromARGB(255, 246, 244, 244)
                        ),),Text(notifier.duration.inSeconds.toString(),
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w400,
                            color: Color.fromARGB(255, 246, 244, 244)
                        ),),],)),
                      SizedBox(height: 8, child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 8.0,

                          thumbShape: RoundSliderThumbShape(enabledThumbRadius: 0.01, elevation: 0, pressedElevation: 0),
                          overlayShape: RoundSliderOverlayShape(overlayRadius: 24.0),
                          thumbColor: Colors.transparent.withOpacity(0),
                          activeTrackColor: Colors.blue,
                          inactiveTrackColor: Colors.blue.withOpacity(0.3),
                          overlayColor: Colors.blue.withOpacity(0.0),
                          trackShape: RoundedRectSliderTrackShape(),
                        ),
                        child: Slider(
                          value: notifier.position.inSeconds.toDouble(),
                          max: notifier.duration.inSeconds.toDouble(),
                          onChanged: (value) {
                            AudioService.seekTo(Duration(seconds: value.toInt()));
                          },
                        ),)),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceAround, crossAxisAlignment: CrossAxisAlignment.center, children: [
                        SizedBox(width: 50, height: 50, child:IconButton(onPressed: () {}, icon: Image(
                            color: Color.fromARGB(255, 255, 255, 255),
                            image: AssetImage('assets/images/unloveno.png'),
                            width: 100
                        ))),
                        SizedBox(width: 50, height: 50, child:IconButton(onPressed: () {}, icon: Image(
                            color: Color.fromARGB(255, 255, 255, 255),
                            image: AssetImage('assets/images/reveuws.png'),
                            width: 100
                        ))),
                        SizedBox(height: 50, width: 50, child: IconButton(onPressed: () {
                          if(notifier.isPlaying){
                            AudioService.pause();
                            setState(() {
                              iconpla = Icon(Icons.play_arrow_rounded, size: 40,);
                              _updateIcon(Icon(Icons.play_arrow_rounded, size: 40,));
                            });
                          }else{
                            AudioService.play();
                            setState(() {
                              iconpla = Icon(Icons.pause_rounded, size: 40,);
                              _updateIcon(Icon(Icons.pause_rounded, size: 40,));
                            });
                          }
                        }, padding: EdgeInsets.zero, icon: Icon(iconpla.icon, size: 50, color: Colors.white,))),
                        SizedBox(width: 50, height: 50, child:IconButton(onPressed: () {}, icon: Image(
                          color: Color.fromARGB(255, 255, 255, 255),
                          image: AssetImage('assets/images/nexts.png'),
                          width: 120,
                          height: 120,
                        ))),
                        SizedBox(width: 50, height: 50, child: IconButton(onPressed: () {}, icon: Image(
                            color: Color.fromARGB(255, 255, 255, 255),
                            image: AssetImage('assets/images/loveno.png'),
                            width: 100
                        ))),
                      ],)],))]);});});
        }
    );
  }

  var iconpla = Icon(Icons.play_arrow_rounded, size: 40,);
  void _updateIcon(Icon newIcon) {
    setState(() {
      iconpla = newIcon;
    });
  }
  Container buildMyNavBar(BuildContext context) {
    return
      Container(
        height: 134+ MediaQuery.of(context).padding.bottom,
          color: Color.fromARGB(255, 25, 24, 24),
          child:SafeArea(

    child: Container(

      decoration: const BoxDecoration(
          color: Color.fromARGB(255, 25, 24, 24),
          borderRadius: BorderRadius.vertical(top: Radius.circular(15))
      ),
      child:
    Column(
      mainAxisAlignment: MainAxisAlignment.end,

        children: [
      Container(
        height: 72,
        child: Material(

          color: Color.fromARGB(255, 25, 24, 24),
          borderRadius: BorderRadius.circular(15),
          child: ListTile(
            contentPadding: EdgeInsets.only(
                left: 0, right: 0, bottom: 0, top: 0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5)),
            onTap: () async {
              _showModalSheet();
            },

            leading:  Padding(padding: EdgeInsets.only(left: 10),
            child: SizedBox(
                    width: 60,
                    height: 60,
                    child: OverflowBox(
                      maxWidth: double.infinity,
                      maxHeight: double.infinity,
                      child: CachedNetworkImage(
                        imageUrl: imgmus,
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
                    ),)),
            title: Text(
              namemus,
              style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w500,
                  color: Color.fromARGB(255, 246, 244, 244)
              ),
            ),
            subtitle: Text(
              ispolmus,
              style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w300,
                  color: Color.fromARGB(255, 246, 244, 244)
              ),
            ),

            trailing: Container(              padding: EdgeInsets.only(right: 10),
              child: IconButton(
                icon: iconpla,
              color: Colors.white,
                padding: EdgeInsets.only(right: 2,bottom: 2),
                onPressed: () {
                  if(AudioService.playbackState.playing){
                    AudioService.pause();
                    setState(() {
                      iconpla = Icon(Icons.play_arrow_rounded, size: 40,);
                      _updateIcon(Icon(Icons.play_arrow_rounded, size: 40,));
                    });
                  }else{
                    AudioService.play();
                    setState(() {
                      iconpla = Icon(Icons.pause_rounded, size: 40,);
                      _updateIcon(Icon(Icons.pause_rounded, size: 40,));
                    });
                  }
    },),)
          ),
        ),
      ),
    Container(
      height: 60,
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
    ),
      ]),))
    );
  }
  int pageIndex = 1;

   late List<StatefulWidget> pages = [
    PlaylistScreen(),
    MusicScreen(onCallback: (dynamic input) {
      playmusa(input);
    },),
    VideoScreen(),
  ];

  @override
  void dispose() {
    super.dispose();
  }

}
void _audioPlayerTaskEntrypoint() async {
  AudioServiceBackground.run(() => AudioPlayerTask());
}




