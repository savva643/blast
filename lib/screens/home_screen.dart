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
import 'package:octo_image/octo_image.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'AudioManager.dart';
import 'background_task.dart';
import 'music_screen.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

const kBgColor = Color(0xFF1604E2);

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();




}




class _HomeScreenState extends State<HomeScreen>{
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<MusicScreenState> _childKey = GlobalKey<MusicScreenState>();


  String shazid = "0";
  String idmus = "0";
  String namemus = "Название";
  String ispolmus = "Исполнитель";
  String imgmus = "https://kompot.site/img/music.jpg";

  get listok => null;

  @override
  void initState()
  {
    super.initState();
    AudioService.customEventStream.listen((event) {
      if (event != null) {
        setState(() {
          _currentPosition = event['position'].toDouble();
          _totalDuration = event['duration'].toDouble();
          print(event['duration'].toString());
        });
      }
    });
    postRequesty();
  }

  Future<void> _playNewTrack(String url) async {
    print("object");
    AudioService.playMediaItem(
      MediaItem(
        id: url,
        album: 'New Album',
        title: 'New Track',
      ),
    );

  }

  Future<void> getaboutmus(String shazid, bool jem) async {
    if(shazid != this.shazid){
      if(!jem){
        isjemnow = false;
        _childKey.currentState?.updateIcon(Icon(Icons.play_arrow_rounded, size: 64, color: Colors.white));
      }
    var urli = Uri.parse("https://kompot.site/getaboutmus?sidi="+shazid);

    var response = await http.post(urli,
      headers: {"Content-Type": "application/json; charset=UTF-8"},
      body: jsonEncode(<String, String>{
        'sidi': shazid,
      }),
    );
    String dff = response.body.toString();
    print(dff);
    setState(() {
      _langData[0] = jsonDecode(dff);
      playmusa(_langData[0]);
    });

    }else{
      if(AudioService.playbackState.playing){
        AudioService.pause();
        setState(() {
          iconpla = Icon(Icons.play_arrow_rounded, size: 40,);
          if(isjemnow){
            _childKey.currentState?.updateIcon(Icon(Icons.play_arrow_rounded, size: 64, color: Colors.white));
          }
        });
      }else{
        AudioService.play();
        setState(() {
          iconpla = Icon(Icons.pause_rounded, size: 40,);
          if(isjemnow){
            _childKey.currentState?.updateIcon(Icon(Icons.pause_rounded, size: 64, color: Colors.white));
          }
        });
      }
    }
  }
  List _langData = [
  {
  'id': '1',
  'img': 'https://kompot.site/img/music.jpg',
  'name': 'Название',
  'message': 'Имполнитель',
  },];
  bool frstsd = false;
  Future<void> playmusa(dynamic listok) async {
    print("object");
    print(idmus);
    _totalDuration = 1;
    _currentPosition = 0;
    print(listok["id"]);
    if(idmus != listok["id"]) {
      if(frstsd) {
        _playNewTrack(listok['url']);
        AudioService.play();
        setState(() {
          iconpla = Icon(Icons.pause_rounded, size: 40,);
          if(isjemnow){
            _childKey.currentState?.updateIcon(Icon(Icons.pause_rounded, size: 64, color: Colors.white));
          }
          namemus = listok["name"];
          ispolmus = listok["message"];
          imgmus = listok['img'];
          idmus = listok['id'];
          shazid = listok['idshaz'];
        });
      }else{
        frstsd = true;
        await AudioService.start(
          backgroundTaskEntrypoint: _audioPlayerTaskEntrypoint,
          androidNotificationChannelName: 'Audio Service Demo',
          androidNotificationColor: 0xFF2196f3,
          androidNotificationIcon: 'mipmap/ic_launcher',
          params: {'url': listok['url']},
        );
        setState(() {
          namemus = listok["name"];
          ispolmus = listok["message"];
          imgmus = listok['img'];
          idmus = listok['id'];
          shazid = listok['idshaz'];
        });
      }

    }else{
      if(AudioService.playbackState.playing){
        AudioService.pause();
        setState(() {
          iconpla = Icon(Icons.play_arrow_rounded, size: 40,);
          if(isjemnow){
            _childKey.currentState?.updateIcon(Icon(Icons.play_arrow_rounded, size: 64, color: Colors.white));
          }
        });
      }else{
        AudioService.play();
        setState(() {
          iconpla = Icon(Icons.pause_rounded, size: 40,);
          if(isjemnow){
            _childKey.currentState?.updateIcon(Icon(Icons.pause_rounded, size: 64, color: Colors.white));
          }
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
  double  _currentPosition = 0;
  double  _totalDuration = 1;
  double _currentValue = 3;


  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  void _showModalSheet(){
    Size size = MediaQuery.of(context).size;
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (builder){
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return StreamBuilder(
                    stream: AudioService.positionStream,
                    builder: (context, snapshot) {
                        return Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(color: const Color.fromARGB(255, 15, 15, 16),),
                      Image.network(
                        imgmus, // URL вашей фоновой картинки
                        fit: BoxFit.cover,
                      ),
                      Container(
                        color: Colors.black.withOpacity(0.5), // Контейнер для применения размытия
                      ),
                      BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          color: Colors.black.withOpacity(0), // Контейнер для применения размытия
                        ),
                        blendMode: BlendMode.srcATop,
                      ),
                      Container(
                          height: size.height,

                          child: Column(children: [
                            AspectRatio(
                                aspectRatio: 1.0, // Сохранение пропорций 1:1
                                child:Container(  height: 360, width: 360, margin: EdgeInsets.only(left: 20, right: 20,top: 60),decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                    clipBehavior: Clip.hardEdge,
                                    child:AspectRatio(
                                      aspectRatio: 1.0, // Сохранение пропорций 1:1
                                      child: Image.network(
                                        imgmus,
                                        height: 400,
                                        width: 400,
                                        fit: BoxFit.cover, // Изображение заполняет контейнер
                                      ),
                                    ))),
                            Text(namemus,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.fade,
                              maxLines: 1,
                              style: TextStyle(
                                  fontSize: 30,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromARGB(255, 246, 244, 244)
                              ),),
                            Text(ispolmus,
                              overflow: TextOverflow.fade,
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 24,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w300,
                                  color: Color.fromARGB(255, 246, 244, 244)
                              ),),
                            Padding(padding: EdgeInsets.only(top: 16,left: 22, right: 22), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(_formatDuration(Duration(milliseconds: _currentPosition.toInt())),
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w400,
                                  color: Color.fromARGB(255, 246, 244, 244)
                              ),),Text(_formatDuration(Duration(milliseconds: _totalDuration.toInt())),
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w400,
                                  color: Color.fromARGB(255, 246, 244, 244)
                              ),),],)),
                            SizedBox(height: 8,  child: SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                trackHeight: 8.0,
                                tickMarkShape: RoundSliderTickMarkShape(tickMarkRadius: 24),
                                thumbShape: SliderComponentShape.noThumb,
                                overlayShape: RoundSliderOverlayShape(overlayRadius: 24.0),
                                activeTrackColor: Colors.blue,
                                inactiveTrackColor: Colors.blue.withOpacity(0.3),
                                overlayColor: Colors.blue.withOpacity(0.0),
                                trackShape: RoundedRectSliderTrackShape(),
                              ),
                              child: StreamBuilder(
                                stream: AudioService.positionStream,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData && !snapshot.hasError && _totalDuration > 0) {
                                    final position = snapshot.data as Duration;
                                    return Slider(
                                      value: position.inMilliseconds.toDouble(),
                                      max: _totalDuration,
                                      onChanged: (value) {
                                        AudioService.seekTo(Duration(milliseconds: value.toInt()));
                                      },
                                    );
                                  } else {
                                    return Slider(
                                      value: 0,
                                      max: _totalDuration,
                                      onChanged: (value) {
                                        AudioService.seekTo(Duration(milliseconds: value.toInt()));
                                      },
                                    );
                                  }
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
                                if(AudioService.playbackState.playing){
                                  AudioService.pause();
                                  setState(() {
                                    iconpla = Icon(Icons.play_arrow_rounded, size: 40,);
                                    _updateIcon(Icon(Icons.play_arrow_rounded, size: 40,));
                                    if(isjemnow){
                                      _childKey.currentState?.updateIcon(Icon(Icons.play_arrow_rounded, size: 64, color: Colors.white));
                                    }
                                  });
                                }else{
                                  AudioService.play();
                                  setState(() {
                                    iconpla = Icon(Icons.pause_rounded, size: 40,);
                                    _updateIcon(Icon(Icons.pause_rounded, size: 40,));
                                    if(isjemnow){
                                      _childKey.currentState?.updateIcon(Icon(Icons.pause_rounded, size: 64, color: Colors.white));
                                    }
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
          decoration: const BoxDecoration(
              color: Color.fromARGB(255, 25, 24, 24),
              borderRadius: BorderRadius.vertical(top: Radius.circular(15))
          ),
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

                              leading:  Padding(padding: EdgeInsets.only(left: 10, top: 8),
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
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w500,

                                    color: Color.fromARGB(255, 246, 244, 244)
                                ),
                              ),
                              subtitle: Text(
                                ispolmus,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w300,
                                    color: Color.fromARGB(255, 246, 244, 244)
                                ),
                              ),

                              trailing: Container(              padding: EdgeInsets.only(right: 10, top: 8),
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
                                        if(isjemnow){
                                          _childKey.currentState?.updateIcon(Icon(Icons.play_arrow_rounded, size: 64, color: Colors.white));
                                        }
                                      });
                                    }else{
                                      AudioService.play();
                                      setState(() {
                                        iconpla = Icon(Icons.pause_rounded, size: 40,);
                                        _updateIcon(Icon(Icons.pause_rounded, size: 40,));
                                        if(isjemnow){
                                          _childKey.currentState?.updateIcon(Icon(Icons.pause_rounded, size: 64, color: Colors.white));
                                        }
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
    MusicScreen(key: _childKey,onCallback: (dynamic input) {
      getaboutmus(input, false);
    }, onCallbacki: postRequesty),
    VideoScreen(),
  ];

  bool isjemnow = false;

  @override
  void dispose() {
    super.dispose();
  }
  String _jemData = "132";
  Future<void> postRequesty () async {
    if(!isjemnow) {
      var urli = Uri.parse("https://kompot.site/getjemmus");

      var response = await http.post(urli,
        headers: {"Content-Type": "application/json; charset=UTF-8"},
        body: jsonEncode(<String, String>{
          'lim': "20",
        }),
      );
      String dff = response.body.toString();
      print(dff);
      setState(() {
        _jemData = dff;
        getaboutmus(_jemData, true);
        isjemnow = true;
      });
    }else{
      if(AudioService.playbackState.playing){
        AudioService.pause();
        setState(() {
          iconpla = Icon(Icons.play_arrow_rounded, size: 40,);
          if(isjemnow){
            _childKey.currentState?.updateIcon(Icon(Icons.play_arrow_rounded, size: 64, color: Colors.white));
          }
        });
      }else{
        AudioService.play();
        setState(() {
          iconpla = Icon(Icons.pause_rounded, size: 40,);
          if(isjemnow){
            _childKey.currentState?.updateIcon(Icon(Icons.pause_rounded, size: 64, color: Colors.white));
          }
        });
      }
    }
  }

}
void _audioPlayerTaskEntrypoint() async {
  await AudioServiceBackground.run(() => AudioPlayerTask());
}