import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:blast/screens/search_screen.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
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
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:media_kit_video/media_kit_video_controls/src/controls/methods/video_state.dart';
import 'package:octo_image/octo_image.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';
import 'AudioManager.dart';
import 'background_task.dart';
import 'music_screen.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:web_socket_channel/status.dart' as status;

const kBgColor = Color(0xFF1604E2);

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();




}




class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<MusicScreenState> _childKey = GlobalKey<MusicScreenState>();

  late final videob = Player();

  // Create a [VideoController] to handle video output from [Player].
  late final controller = VideoController(videob);


  //videoblock
  bool isplad = false;

  Future<void> playVideo(String shazidi, bool frommus) async {
    if (shazid != shazidi || frommus) {
      var urli = Uri.parse("https://kompot.site/getaboutmus?sidi=" + shazidi);

      var response = await http.get(urli);
      String dff = response.body.toString();
      print(dff);
      setState(() {
        _langData[0] = jsonDecode(dff);
        videoope = true;
        vidaftermus = _langData[0]['id'];
        videob.open(Media(_langData[0]['vidos']));
        _toogleAnimky();
        if (!frommus) {
          _showModalSheet();
          opacityi1 = 0;
          opacityi2 = 1;
        }

        iconpla = Icon(Icons.pause_rounded, size: 40,);
        if (isjemnow) {
          _childKey.currentState?.updateIcon(
              Icon(Icons.pause_rounded, size: 64, color: Colors.white));
        }
        namemus = _langData[0]["name"];
        ispolmus = _langData[0]["message"];
        imgmus = _langData[0]['img'];
        idmus = _langData[0]['id'];
        shazid = _langData[0]['idshaz'];
      });
    } else {
      playpause();
    }
  }


  double squareScaleA = 0;
  double squareScaleB = 0;
  String shazid = "0";
  String idmus = "0";
  String namemus = "Название";
  String ispolmus = "Исполнитель";
  String imgmus = "https://kompot.site/img/music.jpg";

  get listok => null;

  @override
  void initState() {
    super.initState();
    getnamedevice();
    AudioService.customEventStream.listen((event) {
      if (event != null) {
        setState(() {
          _currentPosition = event['position'].toDouble();
          _totalDuration = event['duration'].toDouble();
          print(event['duration'].toString());
        });
      }
    });
    AudioService.playbackStateStream.listen((PlaybackState state) {
      setState(() {
        if (!videoope) {
          if (!state.playing) {
            setState(() {
              iconpla = Icon(Icons.play_arrow_rounded, size: 40,);
              if (isjemnow) {
                _childKey.currentState?.updateIcon(Icon(
                    Icons.play_arrow_rounded, size: 64, color: Colors.white));
              }
            });
          } else {
            setState(() {
              iconpla = Icon(Icons.pause_rounded, size: 40,);
              if (isjemnow) {
                _childKey.currentState?.updateIcon(
                    Icon(Icons.pause_rounded, size: 64, color: Colors.white));
              }
            });
          }
        }
      });
    });
    controller.player.stream.playing.listen((bool state) {
      setState(() {
        if (videoope) {
          if (!state) {
            setState(() {
              iconpla = Icon(Icons.play_arrow_rounded, size: 40,);
              if (isjemnow) {
                _childKey.currentState?.updateIcon(Icon(
                    Icons.play_arrow_rounded, size: 64, color: Colors.white));
              }
              AudioService.seekTo(Duration(milliseconds: 1));
            });
          } else {
            setState(() {
              iconpla = Icon(Icons.pause_rounded, size: 40,);
              if (isjemnow) {
                _childKey.currentState?.updateIcon(
                    Icon(Icons.pause_rounded, size: 64, color: Colors.white));
              }
              AudioService.seekTo(Duration(milliseconds: 1));
            });
          }
        }
      });
    });
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _animation = AlignmentTween(
      begin: Alignment.center,
      end: Alignment.centerLeft,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    postRequesty();
  }

  Future<void> _playNewTrack(String url) async {
    print("object");
    AudioService.playMediaItem(
      MediaItem(
        id: url,
        artUri: Uri.parse(_langData[0]['img']),
        artist: _langData[0]['message'],
        title: _langData[0]['name'],
      ),
    );
  }

  Future<void> getaboutmus(String shazid, bool jem) async {
    if (shazid != this.shazid) {

        if (!jem) {
          isjemnow = false;
          _childKey.currentState?.updateIcon(
              Icon(Icons.play_arrow_rounded, size: 64, color: Colors.white));
        }
        var urli = Uri.parse("https://kompot.site/getaboutmus?sidi=" + shazid);

        var response = await http.get(urli);
        String dff = response.body.toString();
        print(dff);
        setState(() {
          _langData[0] = jsonDecode(dff);
          if (_langData[0]['vidos'] != '0' && videoope) {
            playVideo(_langData[0]['idshaz'], false);
          } else {
            playmusa(_langData[0], false);
            if (videoope) {
              videoope = false;
              _toogleAnimky();
              controller.player.pause();
            }
          }
        });

    } else {
      playpause();
    }
  }

  void playpause() {
    if (videoope) {
      if (controller.player.state.playing) {
        controller.player.pause();
        setState(() {
          iconpla = Icon(Icons.play_arrow_rounded, size: 40,);
          if (isjemnow) {
            _childKey.currentState?.updateIcon(Icon(
                Icons.play_arrow_rounded, size: 64, color: Colors.white));
          }
        });
      } else {
        controller.player.play();
        setState(() {
          iconpla = Icon(Icons.pause_rounded, size: 40,);
          if (isjemnow) {
            _childKey.currentState?.updateIcon(
                Icon(Icons.pause_rounded, size: 64, color: Colors.white));
          }
        });
      }
    } else {
      if (AudioService.playbackState.playing) {
        AudioService.pause();
        setState(() {
          iconpla = Icon(Icons.play_arrow_rounded, size: 40,);
          if (isjemnow) {
            _childKey.currentState?.updateIcon(Icon(
                Icons.play_arrow_rounded, size: 64, color: Colors.white));
          }
        });
      } else {
        AudioService.play();
        setState(() {
          iconpla = Icon(Icons.pause_rounded, size: 40,);
          if (isjemnow) {
            _childKey.currentState?.updateIcon(
                Icon(Icons.pause_rounded, size: 64, color: Colors.white));
          }
        });
      }
    }
  }


  late AnimationController _controller;
  late Animation<Alignment> _animation;

  //block for anim
  double imgwh = 360;
  double dsds = 20;
  double dsds2 = 60;
  double videoopacity = 0;
  double opacity = 1;

  double opacityi1 = 1;
  double opacityi2 = 0;
  Alignment ali = Alignment.center;

  void _toogleAnimky() {
    Size size = MediaQuery
        .of(context)
        .size;
    setState(() {
      imgwh = videoope ? 80 : 360;
      dsds = videoope ? 8 : 20;
      if (size.width <= 640) {
        dsds2 = videoope ? ((size.width / 16) * 9) + 80 : 60;
      } else {
        dsds2 = videoope ? ((640 / 16) * 9) + 80 : 60;
      }
      squareScaleA = videoope ? -80 : 0;
      squareScaleB = videoope ? 0 : 80;
      opacity = videoope ? 0 : 1;
      videoopacity = videoope ? 1 : 0;
      ali = videoope ? Alignment.centerLeft : Alignment.center;
      videoope ? _controller.forward() : _controller.reverse();
      if (videoope == false) {
        opacityi1 = 1;
        opacityi2 = 0;
      }
    });
  }

  void _setvi() {
    print(vidaftermus);
    setState(() {
      videoope = !videoope;
      if (!videoope) {
        controller.player.pause();
        if (musaftervid == vidaftermus) {
          playpause();
        } else {
          playmusa(_langData[0], true);
        }
        AudioService.seekTo(controller.player.state.position);
        _toogleAnimky();
      } else {
        AudioService.pause();
        if (musaftervid == vidaftermus) {
          playpause();
          _toogleAnimky();
        } else {
          _toogleAnimky();
          playVideo(shazid, true);
        }
        controller.player.seek(AudioService.playbackState.position);
      }
    });
  }

  String vidaftermus = "false";
  String musaftervid = "false";

  bool videoope = false;
  List _langData = [
    {
      'id': '1',
      'img': 'https://kompot.site/img/music.jpg',
      'name': 'Название',
      'message': 'Имполнитель',
    },
  ];
  bool frstsd = false;

  Future<void> playmusa(dynamic listok, bool frmvid) async {
    print("object");
    print(idmus);
    musaftervid = listok["id"];
    _totalDuration = 1;
    _currentPosition = 0;
    print(listok["id"]);
    if(devicecon){

    }else {
      if (idmus != listok["id"] || frmvid) {
        if (frstsd) {
          _playNewTrack(listok['url']);
          AudioService.play();
          setState(() {
            iconpla = Icon(Icons.pause_rounded, size: 40,);
            if (isjemnow) {
              _childKey.currentState?.updateIcon(
                  Icon(Icons.pause_rounded, size: 64, color: Colors.white));
            }
            namemus = listok["name"];
            ispolmus = listok["message"];
            imgmus = listok['img'];
            idmus = listok['id'];
            shazid = listok['idshaz'];
          });
        } else {
          frstsd = true;
          await AudioService.start(
            backgroundTaskEntrypoint: _audioPlayerTaskEntrypoint,
            androidNotificationChannelName: 'blast!',
            androidNotificationColor: 0xFF2196f3,
            androidNotificationIcon: 'drawable/mus_logo_foreground',
            params: {'url': MediaItem(
              id: _langData[0]['url'],
              artUri: Uri.parse(_langData[0]['img']),
              artist: _langData[0]['message'],
              title: _langData[0]['name'],
            )},
          );
          setState(() {
            namemus = listok["name"];
            ispolmus = listok["message"];
            imgmus = listok['img'];
            idmus = listok['id'];
            shazid = listok['idshaz'];
          });
        }
      } else {
        playpause();
      }
    }
  }

  String musicUrl = ""; // Insert your music URL
  String thumbnailImgUrl = "";

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
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
              statusBarIconBrightness: Brightness
                  .light, // For Android: (dark icons)
            ),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 15, 15, 16),
        bottomNavigationBar: buildMyNavBar(context),
        extendBody: true,
        body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              // При изменении размеров экрана обновляется состояние
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  Size size = MediaQuery
                      .of(context)
                      .size;
                  if (size.width <= 640) {
                    dsds2 = videoope ? ((size.width / 16) * 9) + 80 : 60;
                  } else {
                    dsds2 = videoope ? ((640 / 16) * 9) + 80 : 60;
                  }
                });
              });
              return showsearch ? SearchScreen(onCallback: (dynamic input) {
                getaboutmus(input, false);
              }, onCallbacki: postRequesty, hie: closeserch) : Container(
                  height: size.height, child: IndexedStack(
                index: pageIndex, // Отображение выбранного экрана
                children: pages,
              ));
            }
        )
    );
  }

  double _currentPosition = 0;
  double _totalDuration = 1;
  double _currentValue = 3;

  bool showsearch = false;

  void showserch() {
    setState(() {
      showsearch = true;
    });
  }

  void closeserch() {
    setState(() {
      showsearch = false;
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  void _showModalSheet() {
    Size size = MediaQuery
        .of(context)
        .size;
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (builder) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return StreamBuilder(
                    stream: AudioService.positionStream,
                    builder: (context, snapshot) {
                      return Stack(
                          fit: StackFit.expand,
                          children: [
                            Container(
                              color: const Color.fromARGB(255, 15, 15, 16),),
                            Image.network(
                              imgmus, // URL вашей фоновой картинки
                              fit: BoxFit.cover,
                            ),
                            Container(
                              color: Colors.black.withOpacity(
                                  0.5), // Контейнер для применения размытия
                            ),
                            BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                color: Colors.black.withOpacity(
                                    0), // Контейнер для применения размытия
                              ),
                              blendMode: BlendMode.srcATop,
                            ),

                            Container(
                                height: size.height,
                                child: Stack(children: [
                                  Column(children: [
                                    AnimatedOpacity(opacity: videoopacity,
                                        duration: Duration(milliseconds: 400),
                                        child: Container(
                                          margin: EdgeInsets.only(top: 60),
                                          child: AspectRatio(
                                            aspectRatio: 16 / 9,
                                            child: MaterialDesktopVideoControlsTheme(
                                              normal: MaterialDesktopVideoControlsThemeData(

                                                // Modify theme options:
                                                seekBarThumbColor: Colors.blue,
                                                seekBarPositionColor: Colors
                                                    .blue,
                                                toggleFullscreenOnDoublePress: false,
                                              ),
                                              fullscreen: const MaterialDesktopVideoControlsThemeData(
                                                seekBarThumbColor: Colors.blue,
                                                topButtonBarMargin: EdgeInsets
                                                    .only(top: 20, left: 30),
                                                topButtonBar: [Text("blast!",
                                                  style: TextStyle(
                                                    fontSize: 40,
                                                    fontFamily: 'Montserrat',
                                                    fontWeight: FontWeight.w900,
                                                    color: Colors.white,
                                                  ),)
                                                ],
                                                seekBarPositionColor: Colors
                                                    .blue,),
                                              child: Video(
                                                controller: controller,
                                              ),
                                            ),
                                          ),)),
                                    Row(children: [
                                      AnimatedOpacity(opacity: opacityi2,
                                          duration: Duration(seconds: 0),
                                          child: AnimatedContainer(
                                              alignment: Alignment.centerLeft,
                                              margin: EdgeInsets.only(
                                                  left: 20, right: 20, top: 20),
                                              height: 80,
                                              width: 80,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.rectangle,
                                                borderRadius: BorderRadius
                                                    .circular(8),
                                              ),
                                              clipBehavior: Clip
                                                  .antiAliasWithSaveLayer,
                                              duration: Duration(
                                                  milliseconds: 0),
                                              child: AspectRatio(
                                                  aspectRatio: 1,
                                                  // Сохранение пропорций 1:1
                                                  child: Image.network(
                                                    imgmus,
                                                    height: imgwh, width: imgwh,
                                                    fit: BoxFit
                                                        .contain, // Изображ
                                                  )))),
                                      AnimatedOpacity(opacity: videoopacity,
                                          duration: Duration(milliseconds: 400),
                                          child: AnimatedContainer(
                                            margin: EdgeInsets.only(top: 20),
                                            transform: Matrix4.translation(
                                                vector.Vector3(
                                                    0, squareScaleB, 0)),
                                            duration: Duration(
                                                milliseconds: 400),
                                            child:
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .start,
                                              children: [Text(namemus,
                                                textAlign: TextAlign.start,
                                                overflow: TextOverflow.fade,
                                                maxLines: 1,
                                                style: TextStyle(
                                                    fontSize: 30,
                                                    fontFamily: 'Montserrat',
                                                    fontWeight: FontWeight.w500,
                                                    color: Color.fromARGB(
                                                        255, 246, 244, 244)
                                                ),),
                                                Text(ispolmus,
                                                  overflow: TextOverflow.fade,
                                                  maxLines: 1,
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                      fontSize: 24,
                                                      fontFamily: 'Montserrat',
                                                      fontWeight: FontWeight
                                                          .w300,
                                                      color: Color.fromARGB(
                                                          255, 246, 244, 244)
                                                  ),)
                                              ],),))

                                    ],),
                                  ]), Column(children: [
                                    AspectRatio(
                                        aspectRatio: 1,
                                        // Сохранение пропорций 1:1
                                        child: AnimatedOpacity(
                                            opacity: opacityi1,
                                            duration: Duration(seconds: 0),
                                            child: AnimatedBuilder(
                                                animation: _animation,
                                                builder: (context, child) {
                                                  return Align(
                                                      alignment: _animation
                                                          .value,
                                                      child:
                                                      AnimatedContainer(
                                                          margin: EdgeInsets
                                                              .only(left: 30,
                                                              right: 30,
                                                              top: dsds2),
                                                          height: imgwh,
                                                          width: imgwh,
                                                          decoration: BoxDecoration(
                                                            shape: BoxShape
                                                                .rectangle,
                                                            borderRadius: BorderRadius
                                                                .circular(dsds),
                                                          ),

                                                          clipBehavior: Clip
                                                              .hardEdge,
                                                          duration: Duration(
                                                              milliseconds: 400),
                                                          child: AspectRatio(
                                                              aspectRatio: 1,
                                                              // Сохранение пропорций 1:1
                                                              child: Image
                                                                  .network(
                                                                imgmus,
                                                                height: imgwh,
                                                                width: imgwh,
                                                                fit: BoxFit
                                                                    .cover, // Изображ
                                                              ))));
                                                }))),
                                    AnimatedOpacity(opacity: opacity,
                                        duration: Duration(milliseconds: 400),
                                        onEnd: () {
                                          setState(() {
                                            if (videoope) {
                                              opacityi1 = 0;
                                              opacityi2 = 1;
                                            }
                                          });
                                        },
                                        child: AnimatedContainer(
                                            duration: Duration(
                                                milliseconds: 400),
                                            transform: Matrix4.translation(
                                                vector.Vector3(
                                                    0, squareScaleA, 0)),
                                            child: Text(namemus,
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.fade,
                                              maxLines: 1,
                                              style: TextStyle(
                                                  fontSize: 30,
                                                  fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.w500,
                                                  color: Color.fromARGB(
                                                      255, 246, 244, 244)
                                              ),))),
                                    AnimatedOpacity(opacity: opacity,
                                        duration: Duration(milliseconds: 400),
                                        child: AnimatedContainer(
                                            duration: Duration(
                                                milliseconds: 400),
                                            transform: Matrix4.translation(
                                                vector.Vector3(
                                                    0, squareScaleA, 0)),
                                            child: Text(ispolmus,
                                              overflow: TextOverflow.fade,
                                              maxLines: 1,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 24,
                                                  fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.w300,
                                                  color: Color.fromARGB(
                                                      255, 246, 244, 244)
                                              ),))),
                                    AnimatedOpacity(opacity: opacity,
                                        duration: Duration(milliseconds: 400),
                                        child: AnimatedContainer(
                                            duration: Duration(
                                                milliseconds: 400),
                                            transform: Matrix4.translation(
                                                vector.Vector3(
                                                    0, squareScaleA, 0)),
                                            child: Padding(
                                                padding: EdgeInsets.only(
                                                    top: 16,
                                                    left: 22,
                                                    right: 22),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    Text(_formatDuration(
                                                        Duration(
                                                            milliseconds: _currentPosition
                                                                .toInt())),
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontFamily: 'Montserrat',
                                                          fontWeight: FontWeight
                                                              .w400,
                                                          color: Color.fromARGB(
                                                              255, 246, 244,
                                                              244)
                                                      ),),
                                                    Text(_formatDuration(
                                                        Duration(
                                                            milliseconds: _totalDuration
                                                                .toInt())),
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontFamily: 'Montserrat',
                                                          fontWeight: FontWeight
                                                              .w400,
                                                          color: Color.fromARGB(
                                                              255, 246, 244,
                                                              244)
                                                      ),),
                                                  ],)))),
                                    SizedBox(height: 4,),
                                    AnimatedOpacity(opacity: opacity,
                                        duration: Duration(milliseconds: 400),
                                        child: AnimatedContainer(
                                            duration: Duration(
                                                milliseconds: 400),
                                            transform: Matrix4.translation(
                                                vector.Vector3(
                                                    0, squareScaleA, 0)),
                                            child: SizedBox(
                                                height: 8, child: SliderTheme(
                                              data: SliderTheme.of(context)
                                                  .copyWith(
                                                trackHeight: 8.0,
                                                tickMarkShape: RoundSliderTickMarkShape(
                                                    tickMarkRadius: 24),
                                                thumbShape: SliderComponentShape
                                                    .noThumb,
                                                overlayShape: RoundSliderOverlayShape(
                                                    overlayRadius: 24.0),
                                                activeTrackColor: Colors.blue,
                                                inactiveTrackColor: Colors.blue
                                                    .withOpacity(0.3),
                                                overlayColor: Colors.blue
                                                    .withOpacity(0.0),
                                                trackShape: RoundedRectSliderTrackShape(),
                                              ),
                                              child: StreamBuilder(
                                                stream: AudioService
                                                    .positionStream,
                                                builder: (context, snapshot) {
                                                  if (snapshot.hasData &&
                                                      !snapshot.hasError &&
                                                      _totalDuration > 0) {
                                                    final position = snapshot
                                                        .data as Duration;
                                                    return Slider(
                                                      value: _currentPosition,
                                                      max: _totalDuration,
                                                      onChanged: (value) {
                                                        AudioService.seekTo(
                                                            Duration(
                                                                milliseconds: value
                                                                    .toInt()));
                                                      },
                                                    );
                                                  } else {
                                                    return Slider(
                                                      value: 0,
                                                      max: _totalDuration,
                                                      onChanged: (value) {
                                                        AudioService.seekTo(
                                                            Duration(
                                                                milliseconds: value
                                                                    .toInt()));
                                                      },
                                                    );
                                                  }
                                                },
                                              ),)))),
                                    SizedBox(height: 22,),
                                    AnimatedContainer(
                                        duration: Duration(milliseconds: 400),
                                        transform: Matrix4.translation(
                                            vector.Vector3(0, squareScaleA, 0)),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .spaceAround,
                                          crossAxisAlignment: CrossAxisAlignment
                                              .center,
                                          children: [
                                            SizedBox(width: 50,
                                                height: 50,
                                                child: IconButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        _setvi();
                                                      });
                                                    }, icon: Image(
                                                    color: Color.fromARGB(
                                                        255, 255, 255, 255),
                                                    image: AssetImage(
                                                        'assets/images/unloveno.png'),
                                                    width: 100
                                                ))),
                                            SizedBox(width: 50,
                                                height: 50,
                                                child: IconButton(
                                                    onPressed: () {},
                                                    icon: Image(
                                                        color: Color.fromARGB(
                                                            255, 255, 255, 255),
                                                        image: AssetImage(
                                                            'assets/images/reveuws.png'),
                                                        width: 100
                                                    ))),
                                            SizedBox(height: 50,
                                                width: 50,
                                                child: IconButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        playpause();
                                                      });
                                                    },
                                                    padding: EdgeInsets.zero,
                                                    icon: Icon(
                                                      iconpla.icon, size: 50,
                                                      color: Colors.white,))),
                                            SizedBox(width: 50,
                                                height: 50,
                                                child: IconButton(
                                                    onPressed: () {},
                                                    icon: Image(
                                                      color: Color.fromARGB(
                                                          255, 255, 255, 255),
                                                      image: AssetImage(
                                                          'assets/images/nexts.png'),
                                                      width: 120,
                                                      height: 120,
                                                    ))),
                                            SizedBox(width: 50,
                                                height: 50,
                                                child: IconButton(
                                                    onPressed: () {},
                                                    icon: Image(
                                                        color: Color.fromARGB(
                                                            255, 255, 255, 255),
                                                        image: AssetImage(
                                                            'assets/images/loveno.png'),
                                                        width: 100
                                                    ))),
                                          ],)),
                                    SizedBox(height: 22,),
                                    AnimatedContainer(
                                        duration: Duration(milliseconds: 400),
                                        transform: Matrix4.translation(
                                            vector.Vector3(0, squareScaleA, 0)),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .spaceAround,
                                          crossAxisAlignment: CrossAxisAlignment
                                              .center,
                                          children: [
                                            SizedBox(width: 50,
                                                height: 50,
                                                child: IconButton(
                                                    onPressed: () {
                                                      connectToWebSocket();
                                                    },
                                                    padding: EdgeInsets.zero,
                                                    icon: Icon(
                                                      Icons.devices_rounded,
                                                      size: 50,
                                                      color: Colors.white,))),
                                            SizedBox(width: 50,
                                                height: 50,
                                                child: IconButton(
                                                    onPressed: () {},
                                                    padding: EdgeInsets.zero,
                                                    icon: Icon(
                                                      Icons.queue_music_rounded,
                                                      size: 50,
                                                      color: Colors.white,))),
                                            SizedBox(height: 50,
                                                width: 50,
                                                child: IconButton(
                                                    onPressed: () {},
                                                    padding: EdgeInsets.zero,
                                                    icon: Icon(Icons
                                                        .playlist_add_rounded,
                                                      size: 50,
                                                      color: Colors.white,))),
                                            SizedBox(width: 50,
                                                height: 50,
                                                child: IconButton(
                                                    onPressed: () {},
                                                    padding: EdgeInsets.zero,
                                                    icon: Image(
                                                      color: Color.fromARGB(
                                                          255, 255, 255, 255),
                                                      image: AssetImage(
                                                          'assets/images/video.png'),
                                                      width: 120,
                                                      height: 120,
                                                    ))),
                                          ],))
                                  ],)
                                ],))
                          ]);
                    });
              });
        }
    );
  }

  var iconpla = Icon(Icons.play_arrow_rounded, size: 40,);

  void _updateIcon(Icon newIcon) {
    setState(() {
      iconpla = newIcon;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      pageIndex = index;
    });
  }

  void _showModalSheetu() {
    Size size = MediaQuery
        .of(context)
        .size;
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(borderRadius: BorderRadius.vertical(top: Radius.circular(16)), color: Color.fromARGB(255, 15, 15, 16)),
                  child: _loaddevicelist(),);
              }
          );
        }
    );
  }

  void connectToWebSocket() {
    getdivecs();
    _showModalSheetu();


  }


  Container buildMyNavBar(BuildContext context) {
    return
      Container(
          height: 134+ MediaQuery.of(context).padding.bottom,
          decoration: const BoxDecoration(
              color: Color.fromARGB(120, 25, 24, 24),
              borderRadius: BorderRadius.vertical(top: Radius.circular(15))
          ),
          child:
          ClipRect(
          child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0), // Настройка степени размытия
    child:
          SafeArea(

              child: Container(

                decoration: const BoxDecoration(
                    color: Color.fromARGB(120, 25, 24, 24),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(15))
                ),
                child:
                Column(
                    mainAxisAlignment: MainAxisAlignment.end,

                    children: [
                      Container(
                        height: 72,
                        child: Material(

                          color: Color.fromARGB(0, 25, 24, 24),
                          borderRadius: BorderRadius.circular(15),
                          child: ListTile(
                              contentPadding: EdgeInsets.only(
                                  left: 0, right: 0, bottom: 0, top: 0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              onTap: () async {
                                _showModalSheet();
                              },

                              leading: Padding(padding: Platform.isWindows || kIsWeb ?  EdgeInsets.only(left: 10, top: 8) :  EdgeInsets.only(left: 10, top: 4),
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
                                    playpause();
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
                    ]),))))
      );
  }
  int pageIndex = 1;

  late List<StatefulWidget> pages = [
    PlaylistScreen(onCallback: (dynamic input) {
      playVideo(input, false);
    }, hie: showserch),
    MusicScreen(key: _childKey,onCallback: (dynamic input) {
      getaboutmus(input, false);
    }, onCallbacki: postRequesty, hie: showserch),
    VideoScreen(onCallback: (dynamic input) {
      playVideo(input, false);
    }, hie: showserch),
  ];

  bool isjemnow = false;

  @override
  void dispose() {
    super.dispose();
    videob.dispose();
  }
  String _jemData = "132";
  Future<void> postRequesty () async {
    if(!isjemnow) {
      var urli = Uri.parse("https://kompot.site/getjemmus");

      var response = await http.get(urli);
      String dff = response.body.toString();
      print(dff);
      setState(() {
        _jemData = dff;
        getaboutmus(_jemData, true);
        isjemnow = true;
      });
    }else{
      playpause();
    }
  }

  List<dynamic> devicelis = [];

  Future<void> getdivecs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
     String? tr = prefs.getString("token");
      var urli = Uri.parse("https://kompot.site/getdeviceblast?getdevices="+tr!);

      var response = await http.get(urli);
      String dff = response.body.toString();
      print(dff);
      setState(() {
        devicelis.clear();
        List<dynamic> dj = jsonDecode(dff);
        devicelis.add({"id": "0","ip": "","name": "Это устройство","status": "true", "connected": "1"});
        for (var num in dj){
          String ipixa = num["ip"];
          final channel = WebSocketChannel.connect(Uri.parse('ws://'+ipixa+':6732'));

          List<dynamic> sdc = [{"type":"checkonline"}];
          String jsonString = jsonEncode(sdc[0]);
          channel.sink.add(jsonString);
          channel.stream.listen((message) {
            List<dynamic> sdbf = [];
            print('Recived: $message');
            sdbf.add(jsonDecode(message));
            if(sdbf[0]["status"].toString() == "true"){
              print('Connected: $message');
              channel.sink.close(status.normalClosure, 'Client closed connection');
              devicelis.add({"id": num["id"],"ip": num["ip"],"name": num["name"],"status": "true", "connected": "0"});
            }else{
              devicelis.add({"id": num["id"],"ip": num["ip"],"name": num["name"],"status": "false", "connected": "0"});
            }

          });

        }
      });
  }
  late WebSocketChannel channeldev;
  dynamic devici;
  bool devicecon = false;
  void connectdevice(dynamic sdv){
    channeldev = WebSocketChannel.connect(Uri.parse('ws://'+sdv["ip"]+':6732'));
    List<dynamic> sdc = [{"type":"connect", "name":_deviceName, "id":"2"}];
    String jsonString = jsonEncode(sdc[0]);
    channeldev.sink.add(jsonString);
    print(jsonString);
    channeldev.stream.listen((message) {
      List<dynamic> sdbf = [];
      print('Recived: $message');
      sdbf.add(jsonDecode(message));
      if(sdbf[0]["status"].toString() == "true"){
        devici = sdv;
        List<dynamic> sdc = [{"type":"openmus", "id":_langData[0]["id"],  "idshaz":_langData[0]["idshaz"],  "vidos":videoope.toString(),  "timecurrent":_currentPosition.toString(), "iddevice":"2"}];
        String jsonString = jsonEncode(sdc[0]);
        channeldev.sink.add(jsonString);
        print(jsonString);
      }
    });
  }

  String _deviceName = 'Unknown Device';

  Future<void> getnamedevice() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        setState(() {
          _deviceName = androidInfo.model; // Gets the device model name for Android
        });
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        setState(() {
          _deviceName = iosInfo.name; // Gets the name set by the user on iOS
        });
      } else if (Platform.isMacOS) {
        MacOsDeviceInfo macInfo = await deviceInfo.macOsInfo;
        setState(() {
          _deviceName = macInfo.computerName; // Gets the computer name on macOS
        });
      } else if (Platform.isWindows) {
        WindowsDeviceInfo windowsInfo = await deviceInfo.windowsInfo;
        setState(() {
          _deviceName = windowsInfo.computerName; // Gets the computer name on Windows
        });
      } else if (Platform.isLinux) {
        LinuxDeviceInfo linuxInfo = await deviceInfo.linuxInfo;
        setState(() {
          _deviceName = linuxInfo.name; // Gets the name of the Linux machine
        });
      } else if (kIsWeb) {
        setState(() {
          _deviceName = "Web Browser"; // Gets the browser's user agent string for Web
        });
      } else {
        setState(() {
          _deviceName = 'Unsupported Platform';
        });
      }
    } catch (e) {
      setState(() {
        _deviceName = 'Failed to get device name: $e';
      });
    }
  }

  void disconnectdeivce(){

  }

  Widget _loaddevicelist() {
    Size size = MediaQuery.of(context).size;
    return ListView.builder(
      itemCount: devicelis.length,
      itemBuilder: (BuildContext context, int idx)
      {
        return SizedBox(child:
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
                connectdevice(devicelis[idx]);
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
                      child: Icon(Icons.device_unknown_rounded, color: devicelis[idx]['status'] == "true" ? Colors.white : Colors.grey,),),
                  ],),),
              title: Text(
                devicelis[idx]['name'],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                    color: devicelis[idx]['status'] == "true" ? Colors.white : Colors.grey
                ),
              ),
              trailing: devicelis[idx]['connected'] == "1" ?  Icon(Icons.check, color: Colors.white,) : null,
            ),
          ),
        )
        );
      },
    );
  }

}
void _audioPlayerTaskEntrypoint() async {
  await AudioServiceBackground.run(() => AudioPlayerTask());
}