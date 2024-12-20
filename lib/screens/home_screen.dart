import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:path_provider/path_provider.dart';
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
import '../api/api_service.dart';
import '../api/record_api.dart';
import '../parts/bottomsheet_about_music.dart';
import '../parts/bottomsheet_queue.dart';
import '../parts/bottomsheet_recognize.dart';
import '../parts/player_widgets.dart';
import '../providers/queue_manager_provider.dart';
import 'AudioManager.dart';
import 'background_task.dart';
import 'login.dart';
import 'music_screen.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:dio/dio.dart';

const kBgColor = Color.fromARGB(255, 15, 15, 16);
final GlobalKey<HomeScreenState> homa = GlobalKey<HomeScreenState>();


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => HomeScreenState();




}



class HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<MusicScreenState> _childKey = GlobalKey<MusicScreenState>();

  
  late final videob = Player();

  // Create a [VideoController] to handle video output from [Player].
  late final controller = VideoController(videob);

  late final videoshort = Player();

  // Create a [VideoController] to handle video output from [Player].
  late final controllershort = VideoController(videoshort);

  //videoblock
  bool isplad = false;


  double _volume = 1.0; // начальная громкость
  Timer? _fadeTimer;


  double dsadsa = 0.0;













  Widget playerik(BuildContext context) {

    final TextStyle nameStyle = const TextStyle(
      fontSize: 28,
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.w600,
      color: Colors.white,
    );
    final TextStyle artistStyle = const TextStyle(
      fontSize: 20,
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.w400,
      color: Colors.grey,
    );
    return Scaffold(
      backgroundColor: const Color(0xFF0f0f10).withOpacity(0),
      body: SafeArea(
        child: Container(padding: EdgeInsets.only(top: 10, bottom: 10),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final double availableHeight = constraints.maxHeight;
              final double availablew = constraints.maxWidth;
              final double imageHeight = availablew * 0.86 <
                  availableHeight * 0.46 ? availablew * 0.86 : availableHeight *
                  0.46; // 40% экрана под изображение


              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(padding: EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end, children: [
                        SizedBox(width: 30,
                            height: 30,
                            child: IconButton(
                                onPressed: () {
                                  connectToWebSocket();
                                },
                                padding: EdgeInsets
                                    .zero,
                                icon: Icon(
                                  Icons
                                      .devices_rounded,
                                  size: 30,
                                  color: Colors
                                      .white,))),
                        SizedBox(width: 20,),
                        SizedBox(width: 30,
                            height: 30,
                            child: IconButton(
                                disabledColor: Color.fromARGB(
                                    255, 123, 123, 124),
                                onPressed: null,
                                padding: EdgeInsets
                                    .zero,
                                icon: Icon(
                                  Icons
                                      .queue_music_rounded,
                                  size: 30,
                                  color: Color.fromARGB(255, 123, 123, 124),))),
                        SizedBox(width: 10,),
                        SizedBox(height: 30,
                            width: 30,
                            child: IconButton(
                                disabledColor: Color.fromARGB(
                                    255, 123, 123, 124),
                                onPressed: () {
                                  showTrackOptionsBottomSheet(context, langData[0]);
                                },
                                padding: EdgeInsets
                                    .zero,
                                icon: Icon(Icons
                                    .more_vert_rounded,
                                  size: 30,
                                  color: Color.fromARGB(255, 255, 255, 255),)))
                      ],)),
                  // Обложка, круглая картинка исполнителя и информация о песне
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                    AnimatedOpacity(
                    opacity: opacityi3,
              duration: Duration(
              milliseconds: 400),
              child:
                      AnimatedOpacity(
                          opacity: opacityi1,
                          duration: Duration(
                              milliseconds: 0),
                          child: AnimatedBuilder(
                              animation: animation,
                              builder: (context,
                                  child) {
                                return Align(
                                    alignment: animation
                                        .value,
                                    child:
                                    AnimatedContainer(
                                      constraints: BoxConstraints(maxWidth: 800, maxHeight: 800),
                                      margin: EdgeInsets
                                          .only(
                                        left: 30,
                                        right: 30,),
                                      height: imgwh == 80 ? imgwh : imageHeight,
                                      width: imgwh == 80 ? imgwh : imageHeight,
                                      duration: Duration(
                                          milliseconds: 400),
                                      child: RoundedImage(imageUrl: imgmus, size: imageHeight),
                                    ));}))),

                      const SizedBox(height: 16),
                      AnimatedOpacity(opacity: opacity,
                          duration: Duration(
                              milliseconds: 400),
                          onEnd: () {
                            setnewState(() {
                              if (videoope) {
                                dsadsa = MediaQuery
                                    .of(context)
                                    .size.width;
                                opacityi1 = 0;
                              }
                            });
                          },
                          child: AnimatedContainer(
                              duration: Duration(
                                  milliseconds: 400),
                              transform: Matrix4
                                  .translation(
                                  vector.Vector3(
                                      0, squareScaleA, 0)),
                              child: Container(
                                height: 50,
                                alignment: Alignment.center,
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width - 32,
                                child: buildTextOrMarquee(
                                    namemus, nameStyle, MediaQuery
                                    .of(context)
                                    .size
                                    .width - 32),
                              ))),
                      AnimatedOpacity(opacity: opacity,
                          duration: Duration(
                              milliseconds: 400),
                          child: AnimatedContainer(
                            alignment: Alignment.center,
                            duration: Duration(
                                milliseconds: 400),
                            transform: Matrix4
                                .translation(
                                vector.Vector3(
                                    0, squareScaleA, 0)),
                            child: Container(
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Круглая картинка исполнителя
                                  CircleAvatar(
                                    radius: 24, // Размер аватара
                                    backgroundImage: NetworkImage(
                                      imgispol, // Ссылка на изображение исполнителя
                                    ),
                                    backgroundColor: Colors
                                        .grey[800], // Цвет фона, если изображения нет
                                  ),
                                  const SizedBox(width: 8),
                                  // Имя исполнителя
                                  Container(
                                    height: 50,
                                    alignment: Alignment.center,
                                    width: shouldScroll(
                                        ispolmus, artistStyle, MediaQuery
                                        .of(context)
                                        .size
                                        .width - 120) ? MediaQuery
                                        .of(context)
                                        .size
                                        .width - 120 : getTextWidth(
                                        ispolmus, artistStyle) + 16,
                                    child: buildTextOrMarquee(
                                      ispolmus,
                                      artistStyle,
                                      shouldScroll(
                                          ispolmus, artistStyle, MediaQuery
                                          .of(context)
                                          .size
                                          .width - 120) ? MediaQuery
                                          .of(context)
                                          .size
                                          .width - 120 : getTextWidth(
                                          ispolmus, artistStyle) + 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),)),
                    ],
                  ),
                  // Анимированный слайдер
                  Column(
                    children: [
                      AnimatedOpacity(opacity: opacity,
                          duration: Duration(
                              milliseconds: 400),
                          child: AnimatedContainer(
                              duration: Duration(
                                  milliseconds: 400),
                              transform: Matrix4
                                  .translation(
                                  vector.Vector3(
                                      0, squareScaleA, 0)),
                              child: SizedBox(
                                height: 8,
                                child: StreamBuilder(
                                  stream: AudioService
                                      .positionStream,
                                  builder: (context,
                                      snapshot) {
                                    if (snapshot
                                        .hasData &&
                                        !snapshot
                                            .hasError &&
                                        totalDuration >
                                            0) {
                                      final position = snapshot
                                          .data as Duration;
                                      return
                                        GestureDetector(
                                          onTapDown: (_) {
                                            setState(() {
                                              isPressed =
                                              true; // Устанавливаем флаг нажатия
                                              scaleY =
                                              1.4; // Увеличиваем слайдер по оси Y
                                              translateX =
                                              12.0; // Сдвигаем слайдер влево
                                              translateY = 10.0;
                                            });
                                          },
                                          onTapUp: (_) {
                                            setState(() {
                                              isPressed =
                                              false; // Сбрасываем флаг нажатия
                                              scaleY =
                                              1.0; // Возвращаем слайдер к исходному размеру по оси Y
                                              translateX =
                                              26.0; // Возвращаем слайдер в исходное положение
                                              translateY = 4.0;
                                            });
                                          },
                                          child: AnimatedContainer(
                                            duration: Duration(
                                                milliseconds: 200),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: translateX),
                                            curve: Curves.easeInOut,
                                            transform: Matrix4.identity()
                                              ..scale(1.0, scaleY),
                                            // Применяем масштаб
                                            child: FlutterSlider(
                                              values: isPressed
                                                  ? [newposition]
                                                  : [currentPosition],
                                              max: totalDuration,
                                              min: 0,
                                              tooltip: FlutterSliderTooltip(
                                                disabled: true, // Отключаем текст со значением
                                              ),
                                              handler: FlutterSliderHandler(
                                                decoration: BoxDecoration(
                                                  color: Colors
                                                      .transparent, // Делаем thumb полностью прозрачным
                                                ),
                                                child: SizedBox
                                                    .shrink(), // Полностью скрываем thumb
                                              ),
                                              onDragStarted: (handlerIndex,
                                                  lowerValue, upperValue) {
                                                setState(() {
                                                  newposition = lowerValue;
                                                });
                                              },
                                              onDragging: (handlerIndex,
                                                  lowerValue, upperValue) {
                                                // Обновляем текущую позицию слайдера, но не меняем масштаб
                                                setState(() {
                                                  newposition =
                                                      lowerValue; // Обновляем текущую позицию слайдера
                                                  setState(() {
                                                    isPressed =
                                                    true; // Устанавливаем флаг нажатия
                                                    scaleY =
                                                    1.4; // Увеличиваем слайдер по оси Y
                                                    translateX =
                                                    12.0; // Сдвигаем слайдер влево
                                                    translateY = 10.0;
                                                  });
                                                });
                                              },
                                              onDragCompleted: (handlerIndex,
                                                  lowerValue, upperValue) {
                                                // Логика завершения перетаскивания
                                                setState(() {
                                                  currentPosition = lowerValue;
                                                });
                                                Duration jda = Duration(
                                                    milliseconds: lowerValue
                                                        .toInt());
                                                print("Position: ${jda
                                                    .inMilliseconds} ms");
                                                setState(() {
                                                  isPressed =
                                                  false; // Сбрасываем флаг нажатия
                                                  scaleY =
                                                  1.0; // Возвращаем слайдер к исходному размеру по оси Y
                                                  translateX =
                                                  26.0; // Возвращаем слайдер в исходное положение
                                                  translateY = 4.0;
                                                });
                                                if (devicecon) {
                                                  List<dynamic> sdc = [
                                                    {
                                                      "type": "media",
                                                      "what": "seekto",
                                                      "timecurrent": jda
                                                          .inSeconds,
                                                      "iddevice": "2"
                                                    }
                                                  ];
                                                  String jsonString = jsonEncode(sdc[0]);
                                                  // Предполагается, что channeldev доступен и открыт для отправки
                                                  channeldev.sink.add(jsonString);
                                                } else {
                                                  if (instalumusa) {
                                                    AudioService.seekTo(Duration(milliseconds: lowerValue.toInt() * 2));
                                                  } else {
                                                    AudioService.seekTo(Duration(milliseconds: lowerValue.toInt()));
                                                  }
                                                }
                                              },
                                              trackBar: FlutterSliderTrackBar(
                                                activeTrackBarHeight: 8,
                                                inactiveTrackBarHeight: 8,
                                                activeTrackBar: BoxDecoration(
                                                  color: Colors.blue,
                                                  borderRadius: BorderRadius
                                                      .circular(10),
                                                ),
                                                inactiveTrackBar: BoxDecoration(
                                                  color: Colors.blue
                                                      .withOpacity(0.3),
                                                  borderRadius: BorderRadius
                                                      .circular(10),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                    } else {
                                      return GestureDetector(
                                        onTapDown: (_) {
                                          setState(() {
                                            isPressed =
                                            true; // Устанавливаем флаг нажатия
                                            scaleY =
                                            1.4; // Увеличиваем слайдер по оси Y
                                            translateX =
                                            12.0; // Сдвигаем слайдер влево
                                            translateY = 10.0;
                                          });
                                        },
                                        onTapUp: (_) {
                                          setState(() {
                                            isPressed =
                                            false; // Сбрасываем флаг нажатия
                                            scaleY =
                                            1.0; // Возвращаем слайдер к исходному размеру по оси Y
                                            translateX =
                                            26.0; // Возвращаем слайдер в исходное положение
                                            translateY = 4.0;
                                          });
                                        },
                                        child: AnimatedContainer(
                                          duration: Duration(milliseconds: 200),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: translateX),
                                          curve: Curves.easeInOut,
                                          transform: Matrix4.identity()
                                            ..scale(1.0, scaleY),
                                          // Применяем масштаб
                                          child: FlutterSlider(
                                            values: isPressed
                                                ? [newposition]
                                                : [currentPosition],
                                            max: totalDuration,
                                            min: 0,
                                            tooltip: FlutterSliderTooltip(
                                              disabled: true, // Отключаем текст со значением
                                            ),
                                            handler: FlutterSliderHandler(
                                              decoration: BoxDecoration(
                                                color: Colors
                                                    .transparent, // Делаем thumb полностью прозрачным
                                              ),
                                              child: SizedBox
                                                  .shrink(), // Полностью скрываем thumb
                                            ),
                                            onDragStarted: (handlerIndex,
                                                lowerValue, upperValue) {
                                              setState(() {
                                                newposition = lowerValue;
                                              });
                                            },
                                            onDragging: (handlerIndex,
                                                lowerValue, upperValue) {
                                              // Обновляем текущую позицию слайдера, но не меняем масштаб
                                              setState(() {
                                                newposition =
                                                    lowerValue; // Обновляем текущую позицию слайдера
                                                setState(() {
                                                  isPressed =
                                                  true; // Устанавливаем флаг нажатия
                                                  scaleY =
                                                  1.4; // Увеличиваем слайдер по оси Y
                                                  translateX =
                                                  12.0; // Сдвигаем слайдер влево
                                                  translateY = 10.0;
                                                });
                                              });
                                            },
                                            onDragCompleted: (handlerIndex,
                                                lowerValue, upperValue) {
                                              // Логика завершения перетаскивания
                                              setState(() {
                                                currentPosition = lowerValue;
                                              });
                                              Duration jda = Duration(
                                                  milliseconds: lowerValue
                                                      .toInt());
                                              print("Position: ${jda
                                                  .inMilliseconds} ms");
                                              setState(() {
                                                isPressed =
                                                false; // Сбрасываем флаг нажатия
                                                scaleY =
                                                1.0; // Возвращаем слайдер к исходному размеру по оси Y
                                                translateX =
                                                26.0; // Возвращаем слайдер в исходное положение
                                                translateY = 4.0;
                                              });
                                              if (devicecon) {
                                                List<dynamic> sdc = [
                                                  {
                                                    "type": "media",
                                                    "what": "seekto",
                                                    "timecurrent": jda
                                                        .inSeconds,
                                                    "iddevice": "2"
                                                  }
                                                ];
                                                String jsonString = jsonEncode(sdc[0]);
                                                // Предполагается, что channeldev доступен и открыт для отправки
                                                channeldev.sink.add(jsonString);
                                              } else {
                                                if (instalumusa) {
                                                  AudioService.seekTo(Duration(milliseconds: lowerValue.toInt() * 2));
                                                } else {
                                                  AudioService.seekTo(Duration(milliseconds: lowerValue.toInt()));
                                                }
                                              }
                                            },
                                            trackBar: FlutterSliderTrackBar(
                                              activeTrackBarHeight: 8,
                                              inactiveTrackBarHeight: 8,
                                              activeTrackBar: BoxDecoration(
                                                color: Colors.blue,
                                                borderRadius: BorderRadius
                                                    .circular(10),
                                              ),
                                              inactiveTrackBar: BoxDecoration(
                                                color: Colors.blue.withOpacity(
                                                    0.3),
                                                borderRadius: BorderRadius
                                                    .circular(10),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                ),))),
              AnimatedOpacity(opacity: opacity,
              duration: Duration(
              milliseconds: 400),
              child: AnimatedContainer(
              duration: Duration(
              milliseconds: 400),
              transform: Matrix4
                  .translation(
              vector.Vector3(
              0, squareScaleA, 0)),
              child: AnimatedPadding(
                        padding: EdgeInsets.only(left: 18 + translateX,
                            right: 18 + translateX,
                            top: translateY),
                        duration: Duration(milliseconds: 200),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 200),
                              // Длительность анимации
                              style: TextStyle(
                                fontSize: isPressed ? 16 : 14,
                                // Увеличиваем текст при нажатии
                                color: isPressed ? Colors.white : Colors.grey,
                                // Меняем цвет
                                fontWeight: FontWeight.bold,
                              ),
                              child: Text(
                                formatDuration(Duration(
                                    milliseconds: currentPosition.toInt())),
                              ),
                            ),
                            AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 200),
                              // Длительность анимации
                              style: TextStyle(
                                fontSize: isPressed ? 16 : 14,
                                // Увеличиваем текст при нажатии
                                color: isPressed ? Colors.white : Colors.grey,
                                // Меняем цвет
                                fontWeight: FontWeight.bold,
                              ),
                              child: Text(
                                formatDuration(Duration(
                                    milliseconds: totalDuration.toInt())),
                              ),
                            ),
                          ],
                        ),
                      ))),
                    ],
                  ),
                  // Кнопки управления
                  AnimatedContainer(
                      duration: Duration(
                          milliseconds: 400),
                      transform: Matrix4.translation(
                          vector.Vector3(
                              0, squareScaleA, 0)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment
                            .spaceAround,
                        crossAxisAlignment: CrossAxisAlignment
                            .center,
                        children: [
                          SizedBox(width: 50,
                              height: 50,
                              child: IconButton(
                                  disabledColor: Color.fromARGB(
                                      255, 123, 123, 124),
                                  onPressed: () {
                                    toggleLike(0);
                                  },
                                  icon: Image(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      image: isDisLiked
                                          ? AssetImage(
                                          'assets/images/unloveyes.png')
                                          : AssetImage(
                                          'assets/images/unloveno.png'),
                                      width: 100
                                  ))),
                          SizedBox(width: 50,
                              height: 50,
                              child: IconButton(
                                  disabledColor: canrevew ? Color.fromARGB(
                                      255, 255, 255, 255) : Color.fromARGB(
                                      255, 123, 123, 124),
                                  onPressed: canrevew ? previosmusic : null,
                                  icon: Image(
                                      color: canrevew ? Color.fromARGB(
                                          255, 255, 255, 255) : Color.fromARGB(
                                          255, 123, 123, 124),
                                      image: AssetImage(
                                          'assets/images/reveuws.png'),
                                      width: 100
                                  ))),
                          SizedBox(height: 50,
                              width: 50,
                              child: loadingmus
                                  ? CircularProgressIndicator()
                                  : IconButton(
                                  onPressed: () {
                                    setnewState(() {
                                      playpause();
                                    });
                                  },
                                  padding: EdgeInsets
                                      .zero,
                                  icon: AnimatedSwitcher(
                                      duration: Duration(milliseconds: 300),
                                      transitionBuilder: (Widget child,
                                          Animation<double> animation) {
                                        return RotationTransition(
                                          turns: Tween(begin: 0.75, end: 1.0)
                                              .animate(animation),
                                          child: ScaleTransition(
                                              scale: animation, child: child),
                                        );
                                      }, child: Icon(
                                    iconpla.icon,
                                    key: videoope ? ValueKey<bool>(controller.player.state.playing) : ValueKey<bool>(AudioService.playbackState.playing),
                                    size: 50,
                                    color: Colors
                                        .white,)))),
                          SizedBox(width: 50,
                              height: 50,
                              child: IconButton(
                                  disabledColor: cannext ? Color.fromARGB(
                                      255, 255, 255, 255) : Color.fromARGB(
                                      255, 123, 123, 124),
                                  onPressed: cannext ? nextmusic : null,
                                  icon: Image(
                                    color: cannext ? Color.fromARGB(
                                        255, 255, 255, 255) : Color.fromARGB(
                                        255, 123, 123, 124),
                                    image: AssetImage(
                                        'assets/images/nexts.png'),
                                    width: 120,
                                    height: 120,
                                  ))),
                          SizedBox(width: 50,
                              height: 50,
                              child: IconButton(
                                  onPressed: () {
                                    toggleLike(1);
                                  }, // () {installmusic(_langData[0]);},
                                  icon: Image(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      image: isLiked
                                          ? AssetImage(
                                          'assets/images/loveyes.png')
                                          : AssetImage(
                                          'assets/images/loveno.png'),
                                      width: 100
                                  ))),
                        ],)),
                  // Дополнительные кнопки
                  AnimatedContainer(
                      duration: Duration(
                          milliseconds: 400),
                      transform: Matrix4.translation(
                          vector.Vector3(
                              0, squareScaleA, 0)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment
                            .spaceAround,
                        crossAxisAlignment: CrossAxisAlignment
                            .center,
                        children: [
                          SizedBox(width: 40,
                              height: 40,
                              child: IconButton(
                                  onPressed: null,
                                  padding: EdgeInsets
                                      .zero,
                                  icon: Icon(
                                    CupertinoIcons.shuffle,
                                    size: 32,
                                    color: Colors
                                        .white,))),
                          SizedBox(width: 40,
                              height: 40,
                              child: IconButton(
                                  disabledColor: Color.fromARGB(
                                      255, 123, 123, 124),
                                  onPressed: null,
                                  padding: EdgeInsets
                                      .zero,
                                  icon: Icon(
                                    Icons
                                        .queue_music_rounded,
                                    size: 40,
                                    color: Color.fromARGB(
                                        255, 123, 123, 124),))),

                          SizedBox(width: 40,
                              height: 40,
                              child: IconButton(
                                  disabledColor: Color.fromARGB(
                                      255, 123, 123, 124),
                                  onPressed: langData[0]['vidos'] != "0" ? () {
                                    setnewState(() {
                                      setvi(shazid, true, false);
                                    });
                                  } : null,
                                  padding: EdgeInsets
                                      .zero,
                                  icon: Image(
                                    color: langData[0]['vidos'] != "0" ? Color
                                        .fromARGB(255, 255, 255, 255) : Color
                                        .fromARGB(255, 123, 123, 124),
                                    image: AssetImage(videoope
                                        ? 'assets/images/musicon.png'
                                        : 'assets/images/video.png'),
                                    width: 120,
                                    height: 120,
                                  ))),
                          SizedBox(height: 40,
                              width: 40,
                              child: IconButton(
                                  disabledColor: Color.fromARGB(
                                      255, 123, 123, 124),
                                  onPressed: null,
                                  padding: EdgeInsets
                                      .zero,
                                  icon: Icon(Icons.loop_rounded,
                                    size: 40,
                                    color: Color.fromARGB(
                                        255, 123, 123, 124),))),
                        ],))
                ],
              );
            },
          ),
        ),
      ),
    );
  }







  final ApiService apiService = ApiService();

  bool essensionbool = false;
  Future<void> essension() async {
    if(!essensionbool){
      essensionbool = true;
      if(videoope){
        controller.player.pause();
      }else{
        AudioService.pause();
      }
      var langData = await apiService.getEssensionRandom();
      setState(() {
        nestedArray.clear();
        nestedArray.add(langData);
        getaboutmus(nestedArray[0]["idshaz"], false, false, true, false);
      });
    }else{
      playpause();
    }

  }

  



  bool isPressed = false; // Флаг для отслеживания состояния нажатия
  bool instalumusa = false;

  Future<void> playVideo(String shazidi, bool frommus) async {
    if (shazid != shazidi || frommus) {
      var aboutmus = await apiService.getAboutMusic(shazidi);
      setState(() {
        langData[0] = aboutmus;
        videoope = true;
        vidaftermus = langData[0]['id'];
        videob.open(Media(langData[0]['vidos']));
        if (!frommus) {
          _showModalSheet();
          dsadsa = MediaQuery
              .of(context)
              .size.width;
          opacityi1 = 0;
          videoopacity = 1;

        }

        iconpla = Icon(Icons.pause_rounded, size: 40,key: ValueKey<bool>(AudioService.playbackState.playing));
        if (isjemnow) {
          _childKey.currentState?.toggleAnimation(true);
          _childKey.currentState?.updateIcon(
              Icon(Icons.pause_rounded, size: 64, color: Colors.white,key: ValueKey<bool>(AudioService.playbackState.playing)));
        }
        if (essensionbool) {
          _childKey.currentState?.toggleAnimationese(true);
          _childKey.currentState?.updateIconese(Icon(
              Icons.pause_rounded, size: 64, color: Colors.white,key: ValueKey<bool>(AudioService.playbackState.playing)));
        }
        print("dsfvdfvs"+langData[0]["doi"].toString());
        if(langData[0]["doi"] == "0"){
          isDisLiked = true;
          isLiked = false;
        }else if(langData[0]["doi"] == "1"){
          isDisLiked = false;
          isLiked = true;
        }else if(langData[0]["doi"] == "2"){
          isDisLiked = false;
          isLiked = false;
        }
        namemus = langData[0]["name"];
        ispolmus = langData[0]["message"];
        imgmus = langData[0]['img'];
        idmus = langData[0]['id'];
        shazid = langData[0]['idshaz'];
        imgispol = langData[0]['messageimg'];
        _toogleAnimky();
        Future.delayed(Duration(milliseconds: 400), opaka);
      });
    } else {
      playpause();
    }
  }

  void dragStarted1(double lowerValue){
    setState(() {
      newposition = lowerValue;
    });
  }

  void dragCompleted1(double lowerValue){
    setState(() {
      currentPosition = lowerValue;
    });
    Duration jda = Duration(
        milliseconds: lowerValue
            .toInt());
    print("Position: ${jda
        .inMilliseconds} ms");
    setState(() {
      isPressed =
      false; // Сбрасываем флаг нажатия
      scaleY =
      1.0; // Возвращаем слайдер к исходному размеру по оси Y
      translateX =
      26.0; // Возвращаем слайдер в исходное положение
      translateY = 4.0;
    });
    if (devicecon) {
      List<dynamic> sdc = [
        {
          "type": "media",
          "what": "seekto",
          "timecurrent": jda
              .inSeconds,
          "iddevice": "2"
        }
      ];
      String jsonString = jsonEncode(sdc[0]);
      // Предполагается, что channeldev доступен и открыт для отправки
      channeldev.sink.add(jsonString);
    } else {
      if (instalumusa) {
        AudioService.seekTo(Duration(milliseconds: lowerValue.toInt() * 2));
      } else {
        AudioService.seekTo(Duration(milliseconds: lowerValue.toInt()));
      }
    }
  }

  void tapdown1(){
    setState(() {
      isPressed =
      true; // Устанавливаем флаг нажатия
      scaleY =
      1.4; // Увеличиваем слайдер по оси Y
      translateX =
      12.0; // Сдвигаем слайдер влево
      translateY = 10.0;
    });
  }

  void tapup1(){
    setState(() {
      isPressed =
      false; // Сбрасываем флаг нажатия
      scaleY =
      1.0; // Возвращаем слайдер к исходному размеру по оси Y
      translateX =
      26.0; // Возвращаем слайдер в исходное положение
      translateY = 4.0;
    });
  }

  void opaka(){
    print("dushnila"+videoope.toString());
    if(_isBottomSheetOpen) {
      setState(() {
        setnewState(() {
          if (videoope) {
            opacityi1 = 0;
            videoopacity = 1;
            dsadsa = MediaQuery
                .of(context)
                .size
                .width;
            opacity = 0;
          } else {
            opacityi1 = 1;
            opacity = 1;
            videoopacity = 0;
            dsadsa = 0;
          }
        });
      });
    }else{
      setState(() {
        if (videoope) {
          opacityi1 = 0;
          videoopacity = 1;
          dsadsa = MediaQuery
              .of(context)
              .size
              .width;
          opacity = 0;
        } else {
          opacityi1 = 1;
          opacity = 1;
          videoopacity = 0;
          dsadsa = 0;
        }
      });
    }
    print("dushnila1"+dsadsa.toString());
  }

  void opaka2(){
    print("dushnilaoff"+videoope.toString());
    setState(() {
      setnewState((){
        if (!videoope) {
          opacityi1 = 1;
          videoopacity = 0;
          dsadsa = 0;
        }
      });
    });
  }

  double scaleY = 1.0; // Начальный масштаб по оси Y (высота)
  double translateX = 26; // Начальное смещение по оси X (сдвиг влево)
  double translateY = 4.0;
  late double squareScaleA = videoope ? MediaQuery.of(context).size.width > 800 ? -320 : -80 * (MediaQuery.of(context).size.width / 280) : 0;
  late double squareScaleB = videoope ? 0 : MediaQuery.of(context).size.width > 800 ? -320 : 80 * (MediaQuery.of(context).size.width / 280);
  String shazid = "0";
  String idmus = "0";
  String namemus = "Название";
  String ispolmus = "Исполнитель";
  String imgmus = "https://kompot.site/img/music.jpg";
  String imgispol = "https://kompot.site/img/music.jpg";
  bool _isMuted = kIsWeb && (defaultTargetPlatform == TargetPlatform.iOS); // Состояние звука
  bool _isWeb = kIsWeb && (defaultTargetPlatform == TargetPlatform.iOS); // Проверка для iOS на вебе

  void _toggleMute() {
    if (_isWeb && _isMuted) {
      setState(() {
        _isMuted = !_isMuted;
        controller.player.setVolume(_isMuted ? 0.0 : 1.0); // Если звук выключен, устанавливаем 0, иначе 1
      });
    }
  }

  double newposition = 0.0;

  get listok => null;

  double opac = 0;
  String getCacheBustedUrl(String url) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return "$url?timestamp=$timestamp";
  }
  @override
  void initState() {
    super.initState();
    getnamedevice();
    _startServer();
    _getLocalIp();
    AudioService.customEventStream.listen((event) {

      if(!devicecon) {

        print("hyffyj");
        if (event != null) {
          if (event is Map && event.containsKey('currentTracki')) {
            final currentTrack = event['currentTracki'];
            if (currentTrack != null) {
              context.read<QueueManagerProvider>().setCurrentTrack(currentTrack);
            }
          }
          if (event is Map && event.containsKey('nextTrack')) {
            final currentTrack = event['nextTrack'];
            if (currentTrack != null) {
              print("nextvid6");
              if(currentTrack['vidos'] != '0'){
                print("nextvid7");
                playVideo(currentTrack['idshaz'], false);
                setMusicInQueue(1, currentTrack['idshaz'], true);
              }
              else{
                print("nextvidno2");
                AudioService.customAction('next', {});
              }
            }
          }
          if (event is Map && event.containsKey('previousTrack')) {
            final currentTrack = event['previousTrack'];
            if (currentTrack != null) {
              if(currentTrack['vidos'] != '0'){
                playVideo(currentTrack['idshaz'], false);
                setMusicInQueue(0, currentTrack['idshaz'], true);
              }
              else{
                AudioService.customAction('previous', {});
              }
            }
          }
          if (event is Map && event.containsKey('setqueue')) {
            final queue = event['setqueue'];
            if (queue != null) {
              context.read<QueueManagerProvider>().setQueue(queue);
            }
          }
          if(_isBottomSheetOpen){
            setnewState(() {
              setState(() {
                if (event.containsKey('isShuffleEnabled')) {
                  _isShuffleEnabled = event['isShuffleEnabled'];
                }
                if (event.containsKey('repeatMode')) {
                  _repeatMode = LoopMode.values[event['repeatMode']];
                }
              });
            });
          }else{
            setState(() {
              if (event.containsKey('isShuffleEnabled')) {
                _isShuffleEnabled = event['isShuffleEnabled'];
              }
              if (event.containsKey('repeatMode')) {
                _repeatMode = LoopMode.values[event['repeatMode']];
              }
            });
            }
          setState(() {
            if(_isBottomSheetOpen){
              setnewState(() {
                if(event['skip'].toString() == "fgbds"){
                  print("dsaxcasc");
                  print(event.toString());
                  if(event['canforward'].toString() == "true"){
                    print("jhmjmhhjmmjhmjhjmsdvs");
                    cannext = true;
                  }else{
                    cannext = false;
                  }
                  if(event['canprevious'].toString() == "true"){
                    canrevew = true;
                  }else{
                    canrevew = false;
                  }
                }
                if(event['event'].toString() == "trackChanged"){
                  final trackData = event['currentTrack'] as Map<String, dynamic>;
                  final currentTrack = MediaItem(
                    id: trackData['id'],
                    title: trackData['title'],
                    artist: trackData['artist'],
                    artUri: Uri.parse(trackData['artUri']),
                    extras: {
                      'idshaz': trackData['extras']['idshaz'],
                      'url': trackData['extras']['url'],
                      'messageimg': trackData['extras']['messageimg'],
                      'short': trackData['extras']['short'],
                      'txt': trackData['extras']['txt'],
                      'vidos': trackData['extras']['vidos'],
                      'bgvideo': trackData['extras']['bgvideo'],
                      'elir': trackData['extras']['elir'],
                    },
                  );
                  final dwa = event['video'] as bool;
                  print("fvdsgvv"+currentTrack.toString());
                  if(dwa == false) {
                    getaboutmusmini(currentTrack);
                  }
                  print("fvdsfgdfgdt"+trackData.toString());
                }
                if(instalumusa) {
                  print(event);
                  currentPosition = ((event['position'].toDouble()) ~/ 2).toDouble();
                  totalDuration = ((event['duration'].toDouble()) ~/ 2).toDouble();
                  print(event['duration'].toString());
                } else {
                  currentPosition = event['position'].toDouble();
                  totalDuration = event['duration'].toDouble();
                  print(event['duration'].toString());
                }
              });
            }else{
              if(event['skip'].toString() == "fgbds"){
                if(event['canforward'].toString() == "true"){
                  cannext = true;
                }else{
                  cannext = false;
                }
                if(event['canprevious'].toString() == "true"){
                  canrevew = true;
                }else{
                  canrevew = false;
                }
              }
              if(event['event'].toString() == "trackChanged"){
                print("fvdsgvv1");
                final trackData = event['currentTrack'] as Map<String, dynamic>;
                print("fvdsgvv2");
                final currentTrack = MediaItem(
                  id: trackData['id'],
                  title: trackData['title'],
                  artist: trackData['artist'],
                  artUri: Uri.parse(trackData['artUri']),
                  extras: {
                    'idshaz': trackData['extras']['idshaz'],
                    'url': trackData['extras']['url'],
                    'messageimg': trackData['extras']['messageimg'],
                    'short': trackData['extras']['short'],
                    'txt': trackData['extras']['txt'],
                    'vidos': trackData['extras']['vidos'],
                    'bgvideo': trackData['extras']['bgvideo'],
                    'elir': trackData['extras']['elir'],
                  },
                );
                print("fvdsgvv");
                final dwa = event['video'] as bool;
                print("fvdsgvv"+currentTrack.toString());
                if(dwa == false) {
                  getaboutmusmini(currentTrack);
                }
                print("fvdsfgdfgdt"+trackData.toString());
              }
              if (instalumusa) {
                print(event);
                currentPosition = ((event['position'].toDouble()) ~/ 2).toDouble();
                totalDuration = ((event['duration'].toDouble()) ~/ 2).toDouble();
                print(event['duration'].toString());
              } else {
                currentPosition = event['position'].toDouble();
                totalDuration = event['duration'].toDouble();
                print(event['duration'].toString());
              }
            }
          });
        }
      }else{
        setnewState(() {
          if(instalumusa) {
            totalDuration = ((event['duration'].toDouble()) ~/ 2).toDouble();
          }else{
            totalDuration = event['duration'].toDouble();
          }
        });
      }
    });

    AudioService.playbackStateStream.listen((PlaybackState state) {
      setState(() {
        print("dsfxv"+videoope.toString());
        if (!videoope) {
          if (langData[0]['bgvideo'] == "0") {
            opac = 0;
            opacityi3 = 1;
          }
          if (!state.playing) {
            setState(() {
              if(langData[0]['bgvideo'] != "0"){
                videoshort.pause();
              }
              iconpla = Icon(Icons.play_arrow_rounded, size: 40,key: ValueKey<bool>(AudioService.playbackState.playing));
              if (isjemnow) {
                _childKey.currentState?.toggleAnimation(false);
                _childKey.currentState?.updateIcon(Icon(
                    Icons.play_arrow_rounded, size: 64, color: Colors.white,key: ValueKey<bool>(AudioService.playbackState.playing)));
              }
              if (essensionbool) {
                _childKey.currentState?.toggleAnimationese(false);
                _childKey.currentState?.updateIconese(Icon(
                    Icons.play_arrow_rounded, size: 64, color: Colors.white,key: ValueKey<bool>(AudioService.playbackState.playing)));
              }
            });
          } else {
            setState(() {
              if(langData[0]['bgvideo'] != "0"){
                videoshort.play();
              }
              iconpla = Icon(Icons.pause_rounded, size: 40,key: ValueKey<bool>(AudioService.playbackState.playing));
              if (isjemnow) {
                _childKey.currentState?.toggleAnimation(true);
                _childKey.currentState?.updateIcon(
                    Icon(Icons.pause_rounded, size: 64, color: Colors.white,key: ValueKey<bool>(AudioService.playbackState.playing)));
              }
              if (essensionbool) {
                _childKey.currentState?.toggleAnimationese(true);
                _childKey.currentState?.updateIconese(Icon(
                    Icons.pause_rounded, size: 64, color: Colors.white,key: ValueKey<bool>(AudioService.playbackState.playing)));
              }
            });
          }
        }else{

        }
      });
    });
    bool fj = false;
    Duration _threshold = Duration(milliseconds: 300); // за 300 мс до конца видео
     controllershort.player.stream.completed.listen((_) async {
       videoshort.setPlaylistMode(PlaylistMode.loop);
       // await videoshort.seek(Duration.zero);
       await videoshort.play(); // Запускаем воспроизведение заново
      fj = true;
    });

    controllershort.player.stream.playing.listen((bool state) {
      if(_isBottomSheetOpen){
        setnewState(() {
          if (videoope) {
            opac = 0;
            opacityi3 = 1;
          }else {
            if (langData[0]['bgvideo'] == "0") {
              opac = 0;
              opacityi3 = 1;
            } else {
              if (!state) {
                if (fj) {
                  fj = false;
                  if (!AudioService.playbackState.playing) {
                    opac = 0;
                    opacityi3 = 1;
                  }
                } else {
                  opac = 0;
                  opacityi3 = 1;
                }
              } else {
                opac = 1;
                opacityi3 = 0;
              }
            }
          }
        });
        setnewState(() {
          if (videoope) {
            if (!state) {
              setState(() {
                iconpla = Icon(Icons.play_arrow_rounded, size: 40,key: ValueKey<bool>(state));
                if (isjemnow) {
                  _childKey.currentState?.toggleAnimation(false);
                  _childKey.currentState?.updateIcon(Icon(
                      Icons.play_arrow_rounded, size: 64, color: Colors.white,key: ValueKey<bool>(state)));
                }
                if (essensionbool) {
                  _childKey.currentState?.toggleAnimationese(false);
                  _childKey.currentState?.updateIconese(Icon(
                      Icons.play_arrow_rounded, size: 64, color: Colors.white,key: ValueKey<bool>(AudioService.playbackState.playing)));
                }
                AudioService.seekTo(Duration(milliseconds: 1));
              });
            } else {
              setState(() {
                iconpla = Icon(Icons.pause_rounded, size: 40,key: ValueKey<bool>(state));
                if (isjemnow) {
                  _childKey.currentState?.toggleAnimation(true);
                  _childKey.currentState?.updateIcon(
                      Icon(Icons.pause_rounded, size: 64, color: Colors.white,key: ValueKey<bool>(state)));
                }
                if (essensionbool) {
                  _childKey.currentState?.toggleAnimationese(true);
                  _childKey.currentState?.updateIconese(Icon(
                      Icons.pause_rounded, size: 64, color: Colors.white,key: ValueKey<bool>(AudioService.playbackState.playing)));
                }
                AudioService.seekTo(Duration(milliseconds: 1));
              });
            }
          }
        });
      }
    });
    controller.player.stream.playing.listen((bool state) {
      setnewState(() {
      setState(() {
        if (videoope) {
          if(langData[0]['bgvideo'] != "0"){
            videoshort.pause();
          }
          if (!state) {
            setState(() {
              iconpla = Icon(Icons.play_arrow_rounded, size: 40,key: ValueKey<bool>(controller.player.state.playing));
              if (isjemnow) {
                _childKey.currentState?.toggleAnimation(false);
                _childKey.currentState?.updateIcon(Icon(
                    Icons.play_arrow_rounded, size: 64, color: Colors.white,key: ValueKey<bool>(controller.player.state.playing)));
              }
              if (essensionbool) {
                _childKey.currentState?.toggleAnimationese(false);
                _childKey.currentState?.updateIconese(Icon(
                    Icons.play_arrow_rounded, size: 64, color: Colors.white,key: ValueKey<bool>(AudioService.playbackState.playing)));
              }
              AudioService.seekTo(Duration(milliseconds: 1));
            });
          } else {
            setState(() {
              iconpla = Icon(Icons.pause_rounded, size: 40,key: ValueKey<bool>(controller.player.state.playing));
              if (isjemnow) {
                _childKey.currentState?.toggleAnimation(true);
                _childKey.currentState?.updateIcon(
                    Icon(Icons.pause_rounded, size: 64, color: Colors.white,key: ValueKey<bool>(controller.player.state.playing)));
              }
              if (essensionbool) {
                _childKey.currentState?.toggleAnimationese(true);
                _childKey.currentState?.updateIconese(Icon(
                    Icons.pause_rounded, size: 64, color: Colors.white,key: ValueKey<bool>(AudioService.playbackState.playing)));
              }
              AudioService.seekTo(Duration(milliseconds: 1));
            });
          }
        }
      });
    });
    });
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    animation = AlignmentTween(
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
        id: langData[0]['id'],
        artUri: Uri.parse(langData[0]['img']),
        artist: langData[0]['message'],
        title: langData[0]['name'],
        extras: {
          'idshaz': langData[0]['idshaz'],
          'url': langData[0]['url'],
          'messageimg': langData[0]['messageimg'],
          'short': langData[0]['short'],
          'txt': langData[0]['txt'],
          'vidos': langData[0]['vidos'],
          'bgvideo': langData[0]['bgvideo'],
          'elir': langData[0]['elir'],
        },
      ),
    );
  }



  Future<void> getaboutmusmini(MediaItem item) async {
    print("hhgfgbffddsag1");
    String? shazik = item.extras?['idshaz'].toString();
    print(shazid);
    print("hhgfgbffdg");
    print(shazik);
    if (shazik != shazid) {
      instalumusa = false;
      if(_isBottomSheetOpen) {
        print("vfdvbsxb");
        setState(() {
          setnewState(() {
            print("sdsdasddsadsadsadsa");
            namemus = item.title;
            ispolmus = item.artist!;
            imgmus = item.artUri.toString();
            imgispol = item.extras!['messageimg'].toString();
            idmus = item.id;
            shazid = item.extras!['idshaz'].toString();
          });
        });
      }else{
        setState(() {
          namemus = item.title;
          ispolmus = item.artist!;
          imgmus = item.artUri.toString();
          imgispol = item.extras!['messageimg'].toString();
          idmus = item.id;
          shazid = item.extras!['idshaz'].toString();
        });
      }
      if(!videoope){
        AudioService.play();
      }
      var aboutmus = await apiService.getAboutMusic(shazik!);
      langData[0] = aboutmus;
      await AudioService.customAction('getskip', {});

      if (langData[0]['vidos'] != '0' && videoope) {
        playVideo(langData[0]['idshaz'], true);
      } else {
        print("thytfyjyju");
        playmusamini(langData[0]);

        if (videoope) {
          videoope = false;
          _toogleAnimky();
          Future.delayed(Duration(milliseconds: 400), opaka);
          controller.player.pause();
        }
      }
    } else {
      playpause();
    }
  }

  Future<void> getaboutmus(String shazid, bool jem, bool install, bool ese, bool isfromochered) async {

    print(shazid+"jkljl"+this.shazid);
    if (shazid != this.shazid) {
      canrevew = false;
      cannext = false;
      AudioService.stop();
      if(ese == false){
        setState(() {
          essensionbool = false;
        });
      }
        if (!jem) {
          isjemnow = false;
          _childKey.currentState?.toggleAnimation(false);
          _childKey.currentState?.updateIcon(
              Icon(Icons.play_arrow_rounded, size: 64, color: Colors.white));
        }
        var aboutmus = await apiService.getAboutMusic(shazid);
        if(install){
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          List<String>? sac = prefs.getStringList("historymusid");
          List<String> fsaf = [];
          if (sac != null) {
            fsaf = sac;
          }
          if(fsaf.length >= 20){
            fsaf.removeLast();
          }
          fsaf.add(aboutmus["id"]);
          await prefs.setStringList("historymusid", fsaf);
        }
      setState(() {
        print("hyhg");
        langData[0] = aboutmus;

        if(isfromochered){
          int dsv = ocherd.indexOf(langData[0]["idshaz"]);
          print((dsv+2).toString()+"i"+(ocherd.length).toString()+"fdsfdfd"+(dsv-1).toString());
          if(dsv+2 <= ocherd.length) {
            cannext = true;
          }else{
            cannext = false;
          }
          if(dsv-1 > 0) {
            canrevew = true;
          }else{
            canrevew = false;
          }
        }else {
          ocherd.clear();
          ocherd.add(langData[0]["idshaz"]);
          ispalylistochered = false;
        }
      });
      bool fvd = false;
      bool fvd2 = await filterValidImages(langData[0]['url']);
      print("hjtghjgthjy"+install.toString());
      print("hjtghjgthjycsadc"+fvd2.toString());
      if(install) {
         fvd = await filterValidImages(langData[0]['timeurl']);
      }

      setState(() {
        loadingmus = false;
        if(_isBottomSheetOpen){
          setnewState(() {
            loadingmus = false;
          });
        }

          if(install){
            instalumusa = true;
            print("vfdvvfdv");
            print(langData[0]['timeurl']);
            if(fvd) {
              print("haveconnect");
              langData[0]['url'] = langData[0]['timeurl'];
            }
          }else{
            if(!fvd2) {
              print("objefghngfhgbfdct");
              installmus(langData[0], false);
              instalumusa = true;
              return;
            }
            instalumusa = false;
          }
          if (langData[0]['vidos'] != '0' && videoope) {
            playVideo(langData[0]['idshaz'], false);
          } else {
            print("thytfyjyju");
            playmusa(langData[0], false,install, ese);
            if (videoope) {
              videoope = false;
              _toogleAnimky();
              Future.delayed(Duration(milliseconds: 400), opaka);
              controller.player.pause();
            }
          }
        });
    } else {
      playpause();
    }
  }

  void setvi2() {
    setnewState(() {
      setvi(shazid, true, false);
    });
  }
  void playpause2() {
    setnewState(() {
      playpause();
    });
  }



  void playpause() {
    if(devicecon) {
      List<dynamic> sdc = [
        {
          "type": "media",
          "what": "play",
          "iddevice": "2",
        }
      ];
      String jsonString = jsonEncode(sdc[0]);
      channeldev.sink.add(jsonString);
      print(jsonString);
    }else{
      if (videoope) {
        if (controller.player.state.playing) {
          controller.player.pause();
          setState(() {
            iconpla = Icon(Icons.play_arrow_rounded, size: 40,key: ValueKey<bool>(controller.player.state.playing));
            if (isjemnow) {
              _childKey.currentState?.toggleAnimation(false);
              _childKey.currentState?.updateIcon(Icon(
                  Icons.play_arrow_rounded, size: 64, color: Colors.white,key: ValueKey<bool>(controller.player.state.playing)));
            }
            if (essensionbool) {
              _childKey.currentState?.toggleAnimationese(false);
              _childKey.currentState?.updateIconese(Icon(
                  Icons.play_arrow_rounded, size: 64, color: Colors.white,key: ValueKey<bool>(AudioService.playbackState.playing)));
            }
          });
          setnewStatesxa(() {
            iconpla = Icon(Icons.play_arrow_rounded, size: 40,key: ValueKey<bool>(controller.player.state.playing));
            if (isjemnow) {
              _childKey.currentState?.toggleAnimation(false);
              _childKey.currentState?.updateIcon(Icon(
                  Icons.play_arrow_rounded, size: 64, color: Colors.white,key: ValueKey<bool>(controller.player.state.playing)));
            }
            if (essensionbool) {
              _childKey.currentState?.toggleAnimationese(false);
              _childKey.currentState?.updateIconese(Icon(
                  Icons.play_arrow_rounded, size: 64, color: Colors.white,key: ValueKey<bool>(AudioService.playbackState.playing)));
            }
          });
        } else {
          controller.player.play();
          setState(() {
            iconpla = Icon(Icons.pause_rounded, size: 40,key: ValueKey<bool>(controller.player.state.playing));
            if (isjemnow) {
              _childKey.currentState?.toggleAnimation(true);
              _childKey.currentState?.updateIcon(
                  Icon(Icons.pause_rounded, size: 64, color: Colors.white,key: ValueKey<bool>(controller.player.state.playing)));
            }
            if (essensionbool) {
              _childKey.currentState?.toggleAnimationese(true);
              _childKey.currentState?.updateIconese(Icon(
                  Icons.pause_rounded, size: 64, color: Colors.white,key: ValueKey<bool>(AudioService.playbackState.playing)));
            }
          });
          setnewStatesxa(() {
            iconpla = Icon(Icons.pause_rounded, size: 40,key: ValueKey<bool>(controller.player.state.playing));
            if (isjemnow) {
              _childKey.currentState?.toggleAnimation(true);
              _childKey.currentState?.updateIcon(
                  Icon(Icons.pause_rounded, size: 64, color: Colors.white,key: ValueKey<bool>(controller.player.state.playing)));
            }
            if (essensionbool) {
              _childKey.currentState?.toggleAnimationese(true);
              _childKey.currentState?.updateIconese(Icon(
                  Icons.pause_rounded, size: 64, color: Colors.white,key: ValueKey<bool>(AudioService.playbackState.playing)));
            }
          });
        }
      } else {
        _fadeTimer?.cancel();
        if (AudioService.playbackState.playing) {
          AudioService.pause();
          setState(() {
            iconpla = Icon(Icons.play_arrow_rounded, size: 40,key: ValueKey<bool>(AudioService.playbackState.playing));
            if (isjemnow) {
              _childKey.currentState?.toggleAnimation(false);
              _childKey.currentState?.updateIcon(Icon(
                  Icons.play_arrow_rounded, size: 64, color: Colors.white,key: ValueKey<bool>(AudioService.playbackState.playing)));
            }
            if (essensionbool) {
              _childKey.currentState?.toggleAnimationese(false);
              _childKey.currentState?.updateIconese(Icon(
                  Icons.play_arrow_rounded, size: 64, color: Colors.white,key: ValueKey<bool>(AudioService.playbackState.playing)));
            }
          });

        } else {
          AudioService.play();
          setState(() {
            iconpla = Icon(Icons.pause_rounded, size: 40,key: ValueKey<bool>(AudioService.playbackState.playing));
            if (isjemnow) {
              _childKey.currentState?.toggleAnimation(true);
              _childKey.currentState?.updateIcon(
                  Icon(Icons.pause_rounded, size: 64, color: Colors.white,key: ValueKey<bool>(AudioService.playbackState.playing)));
            }
            if (essensionbool) {
              _childKey.currentState?.toggleAnimationese(true);
              _childKey.currentState?.updateIconese(Icon(
                  Icons.pause_rounded, size: 64, color: Colors.white,key: ValueKey<bool>(AudioService.playbackState.playing)));
            }
          });

        }
      }
    }
  }


  late AnimationController _controller;
  late Animation<Alignment> animation;

  //block for anim
  double imgwh = 500;
  double dsds = 20;
  double dsds2 = 60;
  double videoopacity = 0;
  double opacity = 1;
  double opacityi3 = 1;
  double opacityi1 = 1;
  Alignment ali = Alignment.center;

  void _toogleAnimky() {
    Size size = MediaQuery
        .of(context)
        .size;
    setState(() {
      imgwh = videoope ? 80 : 500;
      dsds = videoope ? 8 : 20;
      if (size.width <= 640) {
        dsds2 = videoope ? ((size.width / 16) * 9) + 80 : 60;
      } else {
        dsds2 = videoope ? ((640 / 16) * 9) + 80 : 60;
      }

      ali = videoope ? Alignment.centerLeft : Alignment.center;
      videoope ? _controller.forward() : _controller.reverse();

      if(_isBottomSheetOpen) {
        setnewState(() {
          if (videoope) {
            opacityi1 = 0;
            opacity = 0;
          }else{
            opacityi1 = 1;
            opacity = 1;
            videoopacity = 0;
            dsadsa = 0;
          }
          imgwh = videoope ? 80 : 500;
          dsds = videoope ? 8 : 20;
          if (size.width <= 640) {
            dsds2 = videoope ? ((size.width / 16) * 9) + 80 : 60;
          } else {
            dsds2 = videoope ? ((640 / 16) * 9) + 80 : 60;
          }

          ali = videoope ? Alignment.centerLeft : Alignment.center;
          videoope ? _controller.forward() : _controller.reverse();
        });
      }
    });
  }

  void setvi(String dfg, bool ds, bool vid) {
    print(vidaftermus);
    setState(() {

      videoope = !videoope;
      Future.delayed(Duration(milliseconds: 400), opaka);
      if (vid){
        AudioService.pause();
        videoope = vid;
        _toogleAnimky();
        playVideo(dfg, ds);
      }else {
        if (!videoope) {
          controller.player.pause();
          if (musaftervid == vidaftermus) {
            playpause();
          } else {
            playmusa(langData[0], true, false, false);
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
            playVideo(dfg, ds);
          }
          controller.player.seek(AudioService.playbackState.position);
        }
      }
    });
  }


  var ocherd = [];
  bool isLiked = false;
  bool isDisLiked = false;
  bool isLoading = false;


  Future<void> toggleLike(int type) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? ds = prefs.getString("token");
    if(ds != "") {
      if (isLoading) return; // Блокируем повторное нажатие во время запроса
      setState(() {
        isLoading = true;
      });
      try {
        String reaction = await apiService.setMusicReaction(langData[0]['id'].toString(), type);
          setState(() {
            setnewState(() {
              if (reaction == "1") {
                isLiked = true;
                isDisLiked = false;
              } else if (reaction == "0") {
                isDisLiked = true;
                isLiked = false;
              } else if (reaction == "2") {
                isDisLiked = false;
                isLiked = false;
              }
            });
          });
            } catch (e) {
        print('Ошибка запроса: $e');
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }else{

    }
  }




  bool loadingmus = false;

  Future<void> installmus(dynamic sdcv, bool search) async {
    if(videoope){
      videoope = false;
      _toogleAnimky();
      Future.delayed(Duration(milliseconds: 400), opaka);
      controller.player.pause();
    }else{
      AudioService.pause();
    }
    AudioService.stop();
    setState(() {
      if(_isBottomSheetOpen) {
        setnewState(() {
          if (sdcv["doi"] == "0") {
            isDisLiked = true;
            isLiked = false;
          } else if (sdcv["doi"] == "1") {
            isDisLiked = false;
            isLiked = true;
          } else if (sdcv["doi"] == "2") {
            isDisLiked = false;
            isLiked = false;
          }
          namemus = sdcv["name"];
          ispolmus = sdcv["message"];
          imgmus = sdcv['img'];
          imgispol = sdcv['messageimg'];
          idmus = "0";
          shazid = sdcv['idshaz'];
        });
      }else{
        if (sdcv["doi"].toString() == "0") {
          isDisLiked = true;
          isLiked = false;
        } else if (sdcv["doi"].toString() == "1") {
          isDisLiked = false;
          isLiked = true;
        } else if (sdcv["doi"].toString() == "2") {
          isDisLiked = false;
          isLiked = false;
        }
        namemus = sdcv["name"];
        ispolmus = sdcv["message"];
        imgmus = sdcv['img'];
        try {
          imgispol = sdcv['messageimg'];
        }catch(e){
          print(e);
        }
        idmus = "0";
        shazid = sdcv['idshaz'];
      }
    });
    setState(() {
      loadingmus = true;
      if(_isBottomSheetOpen){
        setnewState(() {
          loadingmus = true;
        });
      }
    });
    bool fvd2 = await filterValidImages(getCacheBustedUrl(sdcv['url']));
    if(search || !fvd2) {
      String dff = await apiService.installMusic(sdcv['idshaz']);
      print(dff);
      getaboutmus(dff, false, true, false, false);
    }else{
      getaboutmus(sdcv['idshaz'], false, false, false, false);
    }

  }

  Future<bool> filterValidImages(String url) async {
    var dsv = false;


    try {
      final response = await http.head(Uri.parse(url));

      if (response.statusCode == 200) {
        dsv = true;
      }
    }catch (e) {
      print("Ошибка при загрузке музыки: $e");

    }

    print(dsv);
    return dsv;
  }


  Future<void> loadbgvideo(String url) async {
    if(kIsWeb){
      await videoshort.open(Media(url));
    }else{
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/cached_video.mp4';
      try {
        // Загружаем видео и сохраняем его
        await Dio().download(
            "https://kompot.site/" + langData[0]['bgvideo'], filePath);
        print("Видео загружено и сохранено в локальном хранилище.");
        await videoshort.open(Media(filePath));

      } catch (e) {
        print("Ошибка при загрузке видео: $e");
        return;
      }
    }
  }


  String vidaftermus = "false";
  String musaftervid = "false";

  bool videoope = false;
  List langData = [
    {
      'id': '1',
      'img': 'https://kompot.site/img/music.jpg',
      'name': 'Название',
      'message': 'Имполнитель',
    },
  ];
  bool frstsd = false;

  Future<void> playmusamini(dynamic listok) async {
    musaftervid = listok["id"];
    totalDuration = 1;
    currentPosition = 0;
    if(devicecon){
      List<dynamic> sdc = [
        {
          "type": "openmus",
          "id": listok["id"],
          "idshaz": listok["idshaz"],
          "vidos": videoope.toString(),
          "timecurrent": "0",
          "iddevice": "2"
        }
      ];
      String jsonString = jsonEncode(sdc[0]);
      channeldev.sink.add(jsonString);
      setState(() {
        if(_isBottomSheetOpen) {
          setnewState(() {
            if (listok["doi"] == "0") {
              isDisLiked = true;
              isLiked = false;
            } else if (listok["doi"] == "1") {
              isDisLiked = false;
              isLiked = true;
            } else if (listok["doi"] == "2") {
              isDisLiked = false;
              isLiked = false;
            }
          });
        }else{
          if (listok["doi"] == "0") {
            isDisLiked = true;
            isLiked = false;
          } else if (listok["doi"] == "1") {
            isDisLiked = false;
            isLiked = true;
          } else if (listok["doi"] == "2") {
            isDisLiked = false;
            isLiked = false;
          }
        }
      });
      if(langData[0]['bgvideo'] != "0") {
        print("https://kompot.site/"+langData[0]['bgvideo']);
        loadbgvideo("https://kompot.site/" + langData[0]['bgvideo']);
      }

    }else {
      print(idmus.toString()+"fdesfvs"+listok["id"].toString());
          setState(() {
            iconpla = Icon(Icons.pause_rounded, size: 40, key: ValueKey<bool>(AudioService.playbackState.playing),);
            if (isjemnow) {
              _childKey.currentState?.toggleAnimation(true);
              _childKey.currentState?.updateIcon(
                Icon(Icons.pause_rounded, size: 64, color: Colors.white,key: ValueKey<bool>(AudioService.playbackState.playing),), );
            }
            if (essensionbool) {
              _childKey.currentState?.toggleAnimationese(true);
              _childKey.currentState?.updateIconese(Icon(
                  Icons.pause_rounded, size: 64, color: Colors.white,key: ValueKey<bool>(AudioService.playbackState.playing)));
            }
            if(_isBottomSheetOpen){
              setnewState(() {
                if(listok["doi"] == "0"){
                  isDisLiked = true;
                  isLiked = false;
                }else if(listok["doi"] == "1"){
                  isDisLiked = false;
                  isLiked = true;
                }else if(listok["doi"] == "2"){
                  isDisLiked = false;
                  isLiked = false;
                }
              });
            }else{
              if(listok["doi"] == "0"){
                isDisLiked = true;
                isLiked = false;
              }else if(listok["doi"] == "1"){
                isDisLiked = false;
                isLiked = true;
              }else if(listok["doi"] == "2"){
                isDisLiked = false;
                isLiked = false;
              }

            }

          });
          if(langData[0]['bgvideo'] != "0") {
            loadbgvideo("https://kompot.site/" + langData[0]['bgvideo']);
          }

    }
  }

  Future<void> playmusa(dynamic listok, bool frmvid, bool install, bool essensioni) async {
    print("object");
    print(idmus);
    musaftervid = listok["id"];
    totalDuration = 1;
    currentPosition = 0;
    print(listok["id"]);
    if(essensioni == false){
      essensionbool = false;
    }
    if(devicecon){
      List<dynamic> sdc = [
        {
          "type": "openmus",
          "id": listok["id"],
          "idshaz": listok["idshaz"],
          "vidos": videoope.toString(),
          "timecurrent": "0",
          "iddevice": "2"
        }
      ];
      String jsonString = jsonEncode(sdc[0]);
      channeldev.sink.add(jsonString);
      setState(() {
        setnewState(() {
        if(listok["doi"] == "0"){
          isDisLiked = true;
          isLiked = false;
        }else if(listok["doi"] == "1"){
          isDisLiked = false;
          isLiked = true;
        }else if(listok["doi"] == "2"){
          isDisLiked = false;
          isLiked = false;
        }
        namemus = listok["name"];
        ispolmus = listok["message"];
        if(!install) {
          imgmus = listok['img'];
          imgispol = listok['messageimg'];
        }
        idmus = listok['id'];
        shazid = listok['idshaz'];
      });
      });
      if(langData[0]['bgvideo'] != "0") {
        loadbgvideo("https://kompot.site/" + langData[0]['bgvideo']);
      }
      if (essensioni) {
        _playNewTrack(listok['short']);
      }else{
        _playNewTrack(listok['url']);
      }
    }else {
      if (idmus != listok["id"] || frmvid) {
        if (frstsd) {
          if (essensioni) {
            print("dsccsd");
            print(listok['short']);
            _playNewTrack(listok['short']);
          }else{
            _playNewTrack(listok['url']);
          }
          AudioService.play();

          setState(() {
            iconpla = Icon(Icons.pause_rounded, size: 40, key: ValueKey<bool>(AudioService.playbackState.playing),);
            if (isjemnow) {
              _childKey.currentState?.toggleAnimation(true);
              _childKey.currentState?.updateIcon(
                  Icon(Icons.pause_rounded, size: 64, color: Colors.white,key: ValueKey<bool>(AudioService.playbackState.playing),), );
            }
            if (essensionbool) {
              _childKey.currentState?.toggleAnimationese(true);
              _childKey.currentState?.updateIconese(Icon(
                  Icons.pause_rounded, size: 64, color: Colors.white,key: ValueKey<bool>(AudioService.playbackState.playing)));
            }
            if(_isBottomSheetOpen){
            setnewState(() {
            if(listok["doi"] == "0"){
              isDisLiked = true;
              isLiked = false;
            }else if(listok["doi"] == "1"){
              isDisLiked = false;
              isLiked = true;
            }else if(listok["doi"] == "2"){
              isDisLiked = false;
              isLiked = false;
            }
            namemus = listok["name"];
            ispolmus = listok["message"];
            if(!install) {
              imgmus = listok['img'];
              imgispol = listok['messageimg'];
            }
            idmus = listok['id'];
            shazid = listok['idshaz'];
            });}else{
              if(listok["doi"] == "0"){
                isDisLiked = true;
                isLiked = false;
              }else if(listok["doi"] == "1"){
                isDisLiked = false;
                isLiked = true;
              }else if(listok["doi"] == "2"){
                isDisLiked = false;
                isLiked = false;
              }
              namemus = listok["name"];
              ispolmus = listok["message"];
              if(!install) {
                imgmus = listok['img'];
                imgispol = listok['messageimg'];
              }
              idmus = listok['id'];
              shazid = listok['idshaz'];
            }

          });
          if(langData[0]['bgvideo'] != "0") {
            loadbgvideo("https://kompot.site/" + langData[0]['bgvideo']);
          }
        } else {
          frstsd = true;
          if(essensioni) {
            await AudioService.start(
              backgroundTaskEntrypoint: _audioPlayerTaskEntrypoint,
              androidNotificationChannelName: 'blast!',
              androidNotificationColor: 0xFF2196f3,
              androidNotificationIcon: 'drawable/mus_logo_foreground',
              params: {'track': MediaItem(
                id: langData[0]['id'],
                artUri: Uri.parse(langData[0]['img']),
                artist: langData[0]['message'],
                title: langData[0]['name'],
                extras: {
                  'idshaz': langData[0]['idshaz'],
                  'url': langData[0]['short'],
                  'messageimg': langData[0]['messageimg'],
                  'short': langData[0]['short'],
                  'txt': langData[0]['txt'],
                  'vidos': langData[0]['vidos'],
                  'bgvideo': langData[0]['bgvideo'],
                  'elir': langData[0]['elir'],
                },
              )},
            );
          }else{
            await AudioService.start(
              backgroundTaskEntrypoint: _audioPlayerTaskEntrypoint,
              androidNotificationChannelName: 'blast!',
              androidNotificationColor: 0xFF2196f3,
              androidNotificationIcon: 'drawable/mus_logo_foreground',
              params: {'track': MediaItem(
                id: langData[0]['id'],
                artUri: Uri.parse(langData[0]['img']),
                artist: langData[0]['message'],
                title: langData[0]['name'],
                extras: {
                  'idshaz': langData[0]['idshaz'],
                  'url': langData[0]['url'],
                  'messageimg': langData[0]['messageimg'],
                  'short': langData[0]['short'],
                  'txt': langData[0]['txt'],
                  'vidos': langData[0]['vidos'],
                  'bgvideo': langData[0]['bgvideo'],
                  'elir': langData[0]['elir'],
                },
              )},
            );
          }
          setState(() {
            if(_isBottomSheetOpen) {
              setnewState(() {
                if (listok["doi"] == "0") {
                  isDisLiked = true;
                  isLiked = false;
                } else if (listok["doi"] == "1") {
                  isDisLiked = false;
                  isLiked = true;
                } else if (listok["doi"] == "2") {
                  isDisLiked = false;
                  isLiked = false;
                }
                namemus = listok["name"];
                ispolmus = listok["message"];
                if (!install) {
                  imgmus = listok['img'];
                  imgispol = listok['messageimg'];
                }
                idmus = listok['id'];
                shazid = listok['idshaz'];
              });
            }else{
              if (listok["doi"] == "0") {
                isDisLiked = true;
                isLiked = false;
              } else if (listok["doi"] == "1") {
                isDisLiked = false;
                isLiked = true;
              } else if (listok["doi"] == "2") {
                isDisLiked = false;
                isLiked = false;
              }
              namemus = listok["name"];
              ispolmus = listok["message"];
              if (!install) {
                imgmus = listok['img'];
                imgispol = listok['messageimg'];
              }
              idmus = listok['id'];
              shazid = listok['idshaz'];
            }
          });
          if(langData[0]['bgvideo'] != "0") {
            loadbgvideo("https://kompot.site/" + langData[0]['bgvideo']);
          }
        }
      } else {
        playpause();
      }
    }
  }

  String musicUrl = ""; // Insert your music URL
  String thumbnailImgUrl = "";
  late PlayerWidget playerwis;
  late QueueWidget queuewidget;

  late StateSetter setnewStatesxa;

  void showQueueBottomSheets(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: const Color.fromARGB(255, 15, 15, 16),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (context) =>
            DraggableScrollableSheet(
                initialChildSize: 0.6,
                minChildSize: 0.4,
                maxChildSize: 0.9,
                expand: false,
                builder: (context, scrollController) =>
                    StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {

                          setnewStatesxa = setState;
                          return queuewidget.queueWidget(context, scrollController, setnewStatesxa, setMusicInQueue);
                        }),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    queuewidget = QueueWidget(playpause, loadingmus, iconpla, videoope, controller);
    playerwis = PlayerWidget(
      connectToWebSocket: connectToWebSocket,
      langData: langData,
      opacityi3: opacityi3, opacityi1: opacityi1, animation: animation, imgwh: imgwh, imgmus: imgmus, opacity: opacity, videoope: videoope, opacityi2: videoopacity,
      squareScaleA: squareScaleA, scaleY: scaleY, translateX: translateX, translateY: translateY, shazid: shazid, namemus: namemus, opka: opaka, imgispol: imgispol, 
      ispolmus: ispolmus, totalDuration: totalDuration, tapdown1: tapdown1, tapup1: tapup1, isPressed: isPressed, newposition: newposition, currentPosition: currentPosition, dragStarted1: dragStarted1, dragCompleted1: dragCompleted1,
      toggleLike: toggleLike, isDisLiked: isDisLiked, canrevew: canrevew, previosmusic: previosmusic, loadingmus: loadingmus, playpause: playpause2, iconpla: iconpla, nextmusic: nextmusic, cannext: cannext, setvi: setvi2,
      controller: controller, isLiked: isLiked, squareScaleB: squareScaleB, videoopacity: videoopacity, toggleMute: _toggleMute, borderRadius: borderRadius, tap2: opaka2, queuewidget: (){showQueueBottomSheets(context);}, isShuffleEnabled: _isShuffleEnabled, repeatMode: _repeatMode, controllershort: controllershort,
    );

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
        body: Stack(children: [Positioned(
          top: -280,
          left: -196,
          child: Image.asset(
            'assets/images/circlebg.png',
            width: 420,
            height: 420,
          ),
        ), LayoutBuilder(
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
                getaboutmus(input, false, false, false, false);
              }, onCallbacki: postRequesty, hie: closeserch, showlog: showlogin, dasd: resetapp,dfsfd: (dynamic input) {
                installmus(input, true);
              }, reci: reci,) : Container(
                  height: size.height, child: IndexedStack(
                index: pageIndex, // Отображение выбранного экрана
                children: pages,
              ));
            }
        )])
    );
  }
  final GlobalKey<NavigatorState> _playlistNavigatorKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> _homeNavigatorKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> _videoNavigatorKey = GlobalKey<NavigatorState>();

  // Метод для получения текущего навигатора
  GlobalKey<NavigatorState> _getNavigatorKey(int index) {
    switch (index) {
      case 0:
        return _playlistNavigatorKey;
      case 1:
        return _homeNavigatorKey;
      case 2:
        return _videoNavigatorKey;
      default:
        return _homeNavigatorKey;
    }
  }


  void _openSearchPage(BuildContext context) {
    // Navigator.of(context).push(_createSearchRoute());

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SearchScreen(onCallback: (dynamic input) {
          getaboutmus(input, false, false, false, false);
        }, onCallbacki: postRequesty, hie: closeserch, showlog: showlogin, dasd: resetapp, dfsfd: (dynamic input) {
          installmus(input, true);
        }, reci: reci, ),
      ),
    );
  }

  bool _isShuffleEnabled = false;
  LoopMode _repeatMode = LoopMode.off;



  Future<void> setMusicInQueue(int index, String idshaz, bool video) async {
    if(video){
      await AudioService.customAction(
          'setindex', {'index': index, 'video': video});
    }else {
      if (shazid != idshaz) {
        await AudioService.customAction(
            'setindex', {'index': index, 'video': false});
      } else {
        playpause();
      }
    }
  }





  HttpServer? _server;
  List<WebSocket> _clients = [];
  bool _isServerRunning = false;


  double currentPosition = 0;
  double totalDuration = 1;
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
  bool _isBottomSheetOpen = false;

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }



  List nestedArray = [
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


  PageController _pageController = PageController();



  void _onPageChanged() {
    int currentPage = _pageController.page?.round() ?? 0;
    onPageChangedCallback(currentPage);
  }

  void onPageChangedCallback(int pageIndex) {
    // Вызывается при смене страницы
    print('Текущая страница: $pageIndex');
    // Можно добавить другие действия, которые должны происходить при смене страницы

  }


  late Recorderi reci = Recorderi(
    context: context,
    getaboutmus: getaboutmus,
    installmus: installmus,
  );


  Widget smallscreenesensionbottomshet() {

    Size size = MediaQuery
        .of(context)
        .size;
    return StreamBuilder(
        stream: AudioService.positionStream,
        builder: (context, snapshot) {
          return GestureDetector(
              onDoubleTapDown: (details) =>
              _onDoubleTap(details, context), child:
          PageView.builder(
            physics: BouncingScrollPhysics(),
            controller: _pageController,
            itemCount: nestedArray.length,
            itemBuilder: (context, index) {
              return Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      color: const Color.fromARGB(
                          255, 15, 15, 16),),
                    Image.network(
                      imgmus, // URL вашей фоновой картинки
                      fit: BoxFit.cover,
                    ),
                    Container(
                      color: Colors.black.withOpacity(
                          0.5), // Контейнер для применения размытия
                    ),
                    BackdropFilter(
                      filter: ImageFilter.blur(
                          sigmaX: 10, sigmaY: 10),
                      child: Container(
                        color: Colors.black.withOpacity(
                            0), // Контейнер для применения размытия
                      ),
                      blendMode: BlendMode.srcATop,
                    ),
                    AnimatedContainer(duration: Duration(milliseconds: 400), child: AnimatedOpacity(duration: Duration(milliseconds: 400), opacity: opac,
                        child: Video(
                          fit: BoxFit.cover,
                          controls: null,
                          controller: controllershort,
                        )),),
                    AnimatedOpacity(duration: Duration(milliseconds: 400), opacity: opac,
                        child: Container(
                          color: Colors.black.withOpacity(
                              0.3), // Контейнер для применения размытия
                        )),
                    Container(
                        constraints: BoxConstraints(maxWidth: 800),
                        height: size.height,
                        child: Stack(children: [
                          Column(children: [
                            AnimatedOpacity(opacity: videoopacity,
                                duration: Duration(
                                    milliseconds: 400),
                                child: Container(

                                    constraints: BoxConstraints(maxWidth: 800, maxHeight: 450),
                                    margin: EdgeInsets.only(
                                        top: 60),
                                    child: AspectRatio(
                                        aspectRatio: 16 / 9,
                                        child: Container(child: MaterialDesktopVideoControlsTheme(
                                          normal: MaterialDesktopVideoControlsThemeData(
                                            // Modify theme options:
                                            seekBarThumbColor: Colors
                                                .blue,
                                            seekBarPositionColor: Colors
                                                .blue,
                                            toggleFullscreenOnDoublePress: false,
                                          ),
                                          fullscreen: const MaterialDesktopVideoControlsThemeData(
                                            seekBarThumbColor: Colors
                                                .blue,
                                            topButtonBarMargin: EdgeInsets
                                                .only(
                                                top: 20, left: 30),
                                            topButtonBar: [
                                              Text("blast!",
                                                style: TextStyle(
                                                  fontSize: 40,
                                                  fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight
                                                      .w900,
                                                  color: Colors.white,
                                                ),)
                                            ],
                                            seekBarPositionColor: Colors
                                                .blue,),
                                          child:ClipRRect(
                                            borderRadius: borderRadius, // Make the border round
                                            child: GestureDetector(
                                                onTap: _toggleMute, // Обработчик клика на видео
                                                child: Video(
                                              controller: controller,
                                            )),
                                          ),
                                        ),)))),
                            Row(children: [
                              AnimatedOpacity(opacity: videoopacity,
                                  duration: Duration(seconds: 0),
                                  child: AnimatedContainer(
                                      alignment: Alignment
                                          .centerLeft,
                                      margin: EdgeInsets.only(
                                          left: 20,
                                          right: 20,
                                          top: 20),
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
                                            height: imgwh,
                                            width: imgwh,
                                            fit: BoxFit
                                                .contain, // Изображ
                                          )))),
                              AnimatedOpacity(
                                  opacity: videoopacity,
                                  duration: Duration(
                                      milliseconds: 400),
                                  child: AnimatedContainer(
                                    margin: EdgeInsets.only(
                                        top: 20),
                                    transform: Matrix4
                                        .translation(
                                        vector.Vector3(
                                            0, squareScaleB, 0)),
                                    duration: Duration(
                                        milliseconds: 400),
                                    child:
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: [AutoSizeText(namemus,
                                        textAlign: TextAlign
                                            .start,
                                        overflow: TextOverflow
                                            .ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(
                                            fontSize: 30,
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight
                                                .w500,
                                            color: Color.fromARGB(
                                                255, 246, 244,
                                                244)
                                        ),),
                                        AutoSizeText(ispolmus,
                                          overflow: TextOverflow
                                              .ellipsis,
                                          maxLines: 1,
                                          textAlign: TextAlign
                                              .start,
                                          style: TextStyle(
                                              fontSize: 24,
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight
                                                  .w300,
                                              color: Color
                                                  .fromARGB(
                                                  255, 246, 244,
                                                  244)
                                          ),)
                                      ],),))

                            ],),
                          ]), Column(children: [
                            AnimatedOpacity(
                                opacity: opacityi3,
                                duration: Duration(
                                    milliseconds: 400),
                                child: Container(
                                    constraints: BoxConstraints(maxWidth: 800, maxHeight: 800), child: AspectRatio(
                                    aspectRatio: 1,
                                    // Сохранение пропорций 1:1
                                    child: AnimatedOpacity(
                                        opacity: opacityi1,
                                        duration: Duration(
                                            milliseconds: 0),
                                        child: AnimatedBuilder(
                                            animation: animation,
                                            builder: (context,
                                                child) {
                                              return Align(
                                                  alignment: animation
                                                      .value,
                                                  child:
                                                  AnimatedContainer(
                                                      constraints: BoxConstraints(maxWidth: 800, maxHeight: 800),
                                                      margin: EdgeInsets
                                                          .only(
                                                        left: 30,
                                                        right: 30,
                                                        top: dsds2,),
                                                      height: imgwh,
                                                      width: imgwh,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape
                                                            .rectangle,
                                                        borderRadius: BorderRadius
                                                            .circular(
                                                            dsds),
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
                                            }))))),
                            AnimatedOpacity(opacity: opacity,
                                duration: Duration(
                                    milliseconds: 400),
                                onEnd: () {
                                  setnewState(() {
                                    if (videoope) {
                                      dsadsa = MediaQuery
                                          .of(context)
                                          .size.width;
                                      opacityi1 = 0;
                                      videoopacity = 1;
                                    }
                                  });
                                },
                                child: AnimatedContainer(
                                    width: size.width,
                                    duration: Duration(
                                        milliseconds: 400),
                                    transform: Matrix4
                                        .translation(
                                        vector.Vector3(
                                            0, squareScaleA, 0)),
                                    child: AutoSizeText(namemus,
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.fade,
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontSize: 30,
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight
                                              .w500,
                                          color: Color.fromARGB(
                                              255, 246, 244, 244)
                                      ),))),
                            AnimatedOpacity(opacity: opacity,
                                duration: Duration(
                                    milliseconds: 400),
                                child: AnimatedContainer(
                                    duration: Duration(
                                        milliseconds: 400),
                                    transform: Matrix4
                                        .translation(
                                        vector.Vector3(
                                            0, squareScaleA, 0)),
                                    child: AutoSizeText(ispolmus,
                                      overflow: TextOverflow.fade,
                                      maxLines: 1,

                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight
                                              .w300,
                                          color: Color.fromARGB(
                                              255, 246, 244, 244)
                                      ),))),
                            AnimatedOpacity(opacity: opacity,
                                duration: Duration(
                                    milliseconds: 400),
                                child: AnimatedContainer(
                                    duration: Duration(
                                        milliseconds: 400),
                                    transform: Matrix4
                                        .translation(
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
                                            AutoSizeText(formatDuration(
                                                Duration(
                                                    milliseconds: currentPosition
                                                        .toInt())),
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight
                                                      .w400,
                                                  color: Color
                                                      .fromARGB(
                                                      255, 246,
                                                      244,
                                                      244)
                                              ),),
                                            AutoSizeText(formatDuration(
                                                Duration(
                                                    milliseconds: totalDuration
                                                        .toInt())),
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight
                                                      .w400,
                                                  color: Color
                                                      .fromARGB(
                                                      255, 246,
                                                      244,
                                                      244)
                                              ),),
                                          ],)))),
                            SizedBox(height: 4,),
                            AnimatedOpacity(opacity: opacity,
                                duration: Duration(
                                    milliseconds: 400),
                                child: AnimatedContainer(
                                    duration: Duration(
                                        milliseconds: 400),
                                    transform: Matrix4
                                        .translation(
                                        vector.Vector3(
                                            0, squareScaleA, 0)),
                                    child: SizedBox(
                                        height: 8,
                                        child: StreamBuilder(
                                            stream: AudioService
                                                .positionStream,
                                            builder: (context,
                                                snapshot) {
                                              if (snapshot
                                                  .hasData &&
                                                  !snapshot
                                                      .hasError &&
                                                  totalDuration >
                                                      0) {
                                                final position = snapshot
                                                    .data as Duration;
                                                return GestureDetector(
                                                  onTapDown: (_) {
                                                    setState(() {
                                                      isPressed = true; // Устанавливаем флаг нажатия
                                                      scaleY = 1.4; // Увеличиваем слайдер по оси Y
                                                      translateX = 12.0; // Сдвигаем слайдер влево
                                                    });
                                                  },
                                                  onTapUp: (_) {
                                                    setState(() {
                                                      isPressed = false; // Сбрасываем флаг нажатия
                                                      scaleY = 1.0; // Возвращаем слайдер к исходному размеру по оси Y
                                                      translateX = 26.0; // Возвращаем слайдер в исходное положение
                                                    });
                                                  },
                                                  child: AnimatedContainer(
                                                    duration: Duration(milliseconds: 200),
                                                    padding: EdgeInsets.symmetric(horizontal: translateX),
                                                    curve: Curves.easeInOut,
                                                    transform: Matrix4.identity()
                                                      ..scale(1.0, scaleY), // Применяем масштаб
                                                    child: FlutterSlider(
                                                      values: isPressed ? [newposition] : [currentPosition],
                                                      max: totalDuration,
                                                      min: 0,
                                                      tooltip: FlutterSliderTooltip(
                                                        disabled: true, // Отключаем текст со значением
                                                      ),
                                                      handler: FlutterSliderHandler(
                                                        decoration: BoxDecoration(
                                                          color: Colors.transparent, // Делаем thumb полностью прозрачным
                                                        ),
                                                        child: SizedBox.shrink(), // Полностью скрываем thumb
                                                      ),
                                                      onDragStarted: (handlerIndex, lowerValue, upperValue) {
                                                        setState(() {
                                                          newposition = lowerValue;
                                                        });
                                                      },
                                                      onDragging: (handlerIndex, lowerValue, upperValue) {
                                                        // Обновляем текущую позицию слайдера, но не меняем масштаб
                                                        setState(() {
                                                          newposition = lowerValue; // Обновляем текущую позицию слайдера
                                                          setState(() {
                                                            isPressed = true; // Устанавливаем флаг нажатия
                                                            scaleY = 1.4; // Увеличиваем слайдер по оси Y
                                                            translateX = 12.0; // Сдвигаем слайдер влево
                                                          });
                                                        });
                                                      },
                                                      onDragCompleted: (handlerIndex, lowerValue, upperValue) {
                                                        // Логика завершения перетаскивания
                                                        setState(() {
                                                          currentPosition = lowerValue;
                                                        });
                                                        Duration jda = Duration(milliseconds: lowerValue.toInt());
                                                        print("Position: ${jda.inMilliseconds} ms");
                                                        setState(() {
                                                          isPressed = false; // Сбрасываем флаг нажатия
                                                          scaleY = 1.0; // Возвращаем слайдер к исходному размеру по оси Y
                                                          translateX = 26.0; // Возвращаем слайдер в исходное положение
                                                        });
                                                        if (devicecon) {
                                                          List<dynamic> sdc = [
                                                            {
                                                              "type": "media",
                                                              "what": "seekto",
                                                              "timecurrent": jda.inSeconds,
                                                              "iddevice": "2"
                                                            }
                                                          ];
                                                          String jsonString = jsonEncode(sdc[0]);
                                                          // Предполагается, что channeldev доступен и открыт для отправки
                                                          channeldev.sink.add(jsonString);
                                                        } else {
                                                          if (instalumusa) {
                                                            AudioService.seekTo(Duration(milliseconds: lowerValue.toInt() * 2));
                                                          } else {
                                                            AudioService.seekTo(Duration(milliseconds: lowerValue.toInt()));
                                                          }
                                                        }
                                                      },
                                                      trackBar: FlutterSliderTrackBar(
                                                        activeTrackBarHeight: 8,
                                                        inactiveTrackBarHeight: 8,
                                                        activeTrackBar: BoxDecoration(
                                                          color: Colors.blue,
                                                          borderRadius: BorderRadius.circular(10),
                                                        ),
                                                        inactiveTrackBar: BoxDecoration(
                                                          color: Colors.blue.withOpacity(0.3),
                                                          borderRadius: BorderRadius.circular(10),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              } else {
                                                return GestureDetector(
                                                  onTapDown: (_) {
                                                    setState(() {
                                                      isPressed = true; // Устанавливаем флаг нажатия
                                                      scaleY = 1.4; // Увеличиваем слайдер по оси Y
                                                      translateX = 12.0; // Сдвигаем слайдер влево
                                                    });
                                                  },
                                                  onTapUp: (_) {
                                                    setState(() {
                                                      isPressed = false; // Сбрасываем флаг нажатия
                                                      scaleY = 1.0; // Возвращаем слайдер к исходному размеру по оси Y
                                                      translateX = 26.0; // Возвращаем слайдер в исходное положение
                                                    });
                                                  },
                                                  child: AnimatedContainer(
                                                    duration: Duration(milliseconds: 200),
                                                    padding: EdgeInsets.symmetric(horizontal: translateX),
                                                    curve: Curves.easeInOut,
                                                    transform: Matrix4.identity()
                                                      ..scale(1.0, scaleY), // Применяем масштаб
                                                    child: FlutterSlider(
                                                      values: isPressed ? [newposition] : [currentPosition],
                                                      max: totalDuration,
                                                      min: 0,
                                                      tooltip: FlutterSliderTooltip(
                                                        disabled: true, // Отключаем текст со значением
                                                      ),
                                                      handler: FlutterSliderHandler(
                                                        decoration: BoxDecoration(
                                                          color: Colors.transparent, // Делаем thumb полностью прозрачным
                                                        ),
                                                        child: SizedBox.shrink(), // Полностью скрываем thumb
                                                      ),
                                                      onDragStarted: (handlerIndex, lowerValue, upperValue) {
                                                        setState(() {
                                                          newposition = lowerValue;
                                                        });
                                                      },
                                                      onDragging: (handlerIndex, lowerValue, upperValue) {
                                                        // Обновляем текущую позицию слайдера, но не меняем масштаб
                                                        setState(() {
                                                          newposition = lowerValue; // Обновляем текущую позицию слайдера
                                                          setState(() {
                                                            isPressed = true; // Устанавливаем флаг нажатия
                                                            scaleY = 1.4; // Увеличиваем слайдер по оси Y
                                                            translateX = 12.0; // Сдвигаем слайдер влево
                                                          });
                                                        });
                                                      },
                                                      onDragCompleted: (handlerIndex, lowerValue, upperValue) {
                                                        // Логика завершения перетаскивания
                                                        setState(() {
                                                          currentPosition = lowerValue;
                                                        });
                                                        Duration jda = Duration(milliseconds: lowerValue.toInt());
                                                        print("Position: ${jda.inMilliseconds} ms");
                                                        setState(() {
                                                          isPressed = false; // Сбрасываем флаг нажатия
                                                          scaleY = 1.0; // Возвращаем слайдер к исходному размеру по оси Y
                                                          translateX = 26.0; // Возвращаем слайдер в исходное положение
                                                        });
                                                        if (devicecon) {
                                                          List<dynamic> sdc = [
                                                            {
                                                              "type": "media",
                                                              "what": "seekto",
                                                              "timecurrent": jda.inSeconds,
                                                              "iddevice": "2"
                                                            }
                                                          ];
                                                          String jsonString = jsonEncode(sdc[0]);
                                                          // Предполагается, что channeldev доступен и открыт для отправки
                                                          channeldev.sink.add(jsonString);
                                                        } else {
                                                          if (instalumusa) {
                                                            AudioService.seekTo(Duration(milliseconds: lowerValue.toInt() * 2));
                                                          } else {
                                                            AudioService.seekTo(Duration(milliseconds: lowerValue.toInt()));
                                                          }
                                                        }
                                                      },
                                                      trackBar: FlutterSliderTrackBar(
                                                        activeTrackBarHeight: 8,
                                                        inactiveTrackBarHeight: 8,
                                                        activeTrackBar: BoxDecoration(
                                                          color: Colors.blue,
                                                          borderRadius: BorderRadius.circular(10),
                                                        ),
                                                        inactiveTrackBar: BoxDecoration(
                                                          color: Colors.blue.withOpacity(0.3),
                                                          borderRadius: BorderRadius.circular(10),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }
                                            },
                                          ),))),
                            SizedBox(height: 22,),
                            AnimatedContainer(
                                duration: Duration(
                                    milliseconds: 400),
                                transform: Matrix4.translation(
                                    vector.Vector3(
                                        0, squareScaleA, 0)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment
                                      .center,
                                  children: [
                                    SizedBox(width: 50,
                                        height: 50,
                                        child: IconButton(
                                            disabledColor: Color.fromARGB(255, 123, 123, 124),
                                            onPressed: () {toggleLike(0);},
                                            icon: Image(
                                                color: Color.fromARGB(255, 255, 255, 255),
                                                image: isDisLiked ? AssetImage(
                                                    'assets/images/unloveyes.png') : AssetImage(
                                                    'assets/images/unloveno.png'),
                                                width: 100
                                            ))),
                                    SizedBox(width: 50,
                                        height: 50,
                                        child: IconButton(
                                            disabledColor: canrevew ? Color.fromARGB(255, 255, 255, 255) : Color.fromARGB(255, 123, 123, 124),
                                            onPressed: canrevew ? previosmusic : null,
                                            icon: Image(
                                                color: canrevew ? Color.fromARGB(255, 255, 255, 255) : Color.fromARGB(255, 123, 123, 124),
                                                image: AssetImage(
                                                    'assets/images/reveuws.png'),
                                                width: 100
                                            ))),
                                    SizedBox(height: 50,
                                        width: 50,
                                        child: loadingmus ? CircularProgressIndicator() : IconButton(
                                            onPressed: () {
                                              setnewState(() {
                                                playpause();
                                              });
                                            },
                                            padding: EdgeInsets
                                                .zero,
                                            icon: AnimatedSwitcher(
                                                duration: Duration(milliseconds: 300),
                                                transitionBuilder: (Widget child, Animation<double> animation) {
                                                  return RotationTransition(
                                                    turns: Tween(begin: 0.75, end: 1.0).animate(animation),
                                                    child: ScaleTransition(scale: animation, child: child),
                                                  );
                                                }, child:  Icon(
                                              iconpla.icon,
                                              key: videoope ? ValueKey<bool>(controller.player.state.playing) : ValueKey<bool>(AudioService.playbackState.playing),
                                              size: 50,
                                              color: Colors
                                                  .white,)))),
                                    SizedBox(width: 50,
                                        height: 50,
                                        child: IconButton(
                                            disabledColor: cannext ? Color.fromARGB(255, 255, 255, 255) : Color.fromARGB(255, 123, 123, 124),
                                            onPressed: cannext ? nextmusic : null,
                                            icon: Image(
                                              color: cannext ? Color.fromARGB(255, 255, 255, 255) : Color.fromARGB(255, 123, 123, 124),
                                              image: AssetImage(
                                                  'assets/images/nexts.png'),
                                              width: 120,
                                              height: 120,
                                            ))),
                                    SizedBox(width: 50,
                                        height: 50,
                                        child: IconButton(
                                            onPressed: () {toggleLike(1);}, // () {installmusic(langData[0]);},
                                            icon: Image(
                                                color: Color.fromARGB(255, 255, 255, 255),
                                                image: isLiked ? AssetImage(
                                                    'assets/images/loveyes.png') : AssetImage(
                                                    'assets/images/loveno.png'),
                                                width: 100
                                            ))),
                                  ],)),
                            SizedBox(height: 22,),
                            AnimatedContainer(
                                duration: Duration(
                                    milliseconds: 400),
                                transform: Matrix4.translation(
                                    vector.Vector3(
                                        0, squareScaleA, 0)),
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
                                            padding: EdgeInsets
                                                .zero,
                                            icon: Icon(
                                              Icons
                                                  .devices_rounded,
                                              size: 50,
                                              color: Colors
                                                  .white,))),
                                    SizedBox(width: 50,
                                        height: 50,
                                        child: IconButton(
                                            disabledColor: Color.fromARGB(255, 123, 123, 124),
                                            onPressed: null,
                                            padding: EdgeInsets
                                                .zero,
                                            icon: Icon(
                                              Icons
                                                  .queue_music_rounded,
                                              size: 50,
                                              color: Color.fromARGB(255, 123, 123, 124),))),
                                    SizedBox(height: 50,
                                        width: 50,
                                        child: IconButton(
                                            disabledColor: Color.fromARGB(255, 123, 123, 124),
                                            onPressed: null,
                                            padding: EdgeInsets
                                                .zero,
                                            icon: Icon(Icons
                                                .settings_rounded,
                                              size: 50,
                                              color: Color.fromARGB(255, 123, 123, 124),))),
                                    SizedBox(width: 50,
                                        height: 50,
                                        child: IconButton(
                                            disabledColor: Color.fromARGB(255, 123, 123, 124),
                                            onPressed: langData[0]['vidos'] != "0" ? () {
                                              setnewState(() {
                                                setvi(shazid,true, false);
                                              });
                                            }: null,
                                            padding: EdgeInsets
                                                .zero,
                                            icon: Image(
                                              color: langData[0]['vidos'] != "0" ? Color.fromARGB( 255, 255, 255, 255) : Color.fromARGB(255, 123, 123, 124),
                                              image: AssetImage(videoope ? 'assets/images/musicon.png' : 'assets/images/video.png'),
                                              width: 120,
                                              height: 120,
                                            ))),
                                  ],))
                          ],)
                        ],))
                  ]);
            },
          )
          );}
    );
  }






  Widget smallscreenbottomshet(){
    Size size = MediaQuery
        .of(context)
        .size;

    return StreamBuilder(
        stream: AudioService.positionStream,
        builder: (context, snapshot) {
          return GestureDetector(
              onDoubleTapDown: (details) =>
                  _onDoubleTap(details, context), child:
     Stack(
        fit: StackFit.expand,
        children: [
          Container(
            color: const Color.fromARGB(
                255, 15, 15, 16),),
          Image.network(
            imgmus, // URL вашей фоновой картинки
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.black.withOpacity(
                0.5), // Контейнер для применения размытия
          ),
          BackdropFilter(
            filter: ImageFilter.blur(
                sigmaX: 10, sigmaY: 10),
            child: Container(
              color: Colors.black.withOpacity(
                  0), // Контейнер для применения размытия
            ),
            blendMode: BlendMode.srcATop,
          ),
          AnimatedContainer(duration: Duration(milliseconds: 400), child: AnimatedOpacity(duration: Duration(milliseconds: 400), opacity: controllershort.player.state.playing ? opac : 0,
              child: Video(
                fit: BoxFit.cover,
                controls: null,
                controller: controllershort,
              )),),
          AnimatedOpacity(duration: Duration(milliseconds: 400), opacity: controllershort.player.state.playing ? opac : 0,
          child: Container(
            color: Colors.black.withOpacity(
                0.3), // Контейнер для применения размытия
          )),
          Container(
              constraints: BoxConstraints(maxWidth: 800),
              height: size.height,
              child: Stack(children: [
                playerwis.playersmallmusic(context),
                Container(width: videoope ? size.width : dsadsa, child:
                playerwis.playersmallvideo(context)),  // playerik(context)
              ],))
        ])
          );
          });
  }

  Widget bigscreenbottomshet(){
    Size size = MediaQuery
        .of(context)
        .size;
    return StreamBuilder(
        stream: AudioService.positionStream,
        builder: (context, snapshot) {
          return GestureDetector(
              onDoubleTapDown: (details) =>
                  _onDoubleTap(details, context), child:
     Stack(
        fit: StackFit.expand,
        children: [
          Container(
            color: const Color.fromARGB(
                255, 15, 15, 16),),
          Image.network(
            imgmus, // URL вашей фоновой картинки
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.black.withOpacity(
                0.5), // Контейнер для применения размытия
          ),
          BackdropFilter(
            filter: ImageFilter.blur(
                sigmaX: 10, sigmaY: 10),
            child: Container(
              color: Colors.black.withOpacity(
                  0), // Контейнер для применения размытия
            ),
            blendMode: BlendMode.srcATop,
          ),
          AnimatedContainer(duration: Duration(milliseconds: 400), child: AnimatedOpacity(duration: Duration(milliseconds: 400), opacity: opac,
              child: Video(
                fit: BoxFit.cover,
                controls: null,
                controller: controllershort,
              )),),
          AnimatedOpacity(duration: Duration(milliseconds: 400), opacity: opac,
              child: Container(
                color: Colors.black.withOpacity(
                    0.3), // Контейнер для применения размытия
              )),
          Container(

              height: size.height,
              child: Stack(children: [
                  Row(children: [
                    Container(width: size.width / 2, child:
                    AnimatedOpacity(opacity: videoopacity,
          duration: Duration(
          milliseconds: 400),
          child: Container(

          margin: EdgeInsets.only(
          top: 30,bottom: 30, left: 20, right: 20),
          child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Container(child: MaterialDesktopVideoControlsTheme(
          normal: MaterialDesktopVideoControlsThemeData(
          // Modify theme options:
          seekBarThumbColor: Colors
              .blue,
          seekBarPositionColor: Colors
              .blue,
          toggleFullscreenOnDoublePress: false,
          ),
          fullscreen: const MaterialDesktopVideoControlsThemeData(
          seekBarThumbColor: Colors
              .blue,
          topButtonBarMargin: EdgeInsets
              .only(
          top: 20, left: 30),
          topButtonBar: [
          Text("blast!",
          style: TextStyle(
          fontSize: 40,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight
              .w900,
          color: Colors.white,
          ),)
          ],
          seekBarPositionColor: Colors
              .blue,),
          child:ClipRRect(
          borderRadius: borderRadius, // Make the border round
          child: GestureDetector(
              onTap: _toggleMute, // Обработчик клика на видео
              child: Video(
                controller: controller,
              )),
          ),
          ),))))), Container(width: size.width / 2.5, child: Center(child: AnimatedContainer(duration: Duration(milliseconds: 400),
          transform: Matrix4
              .translation(
          vector.Vector3(
          0, -60, 0)), alignment: Alignment.center,
                        constraints: BoxConstraints(maxWidth: size.width/2.5),
                        child:  Row(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [
                  AnimatedOpacity(opacity: videoopacity,
                      duration: Duration(seconds: 0),
                      child: AnimatedContainer(
                          alignment: Alignment
                              .centerLeft,
                          margin: EdgeInsets.only(
                              left: 20,
                              right: 20,
                              top: 20),
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
                                height: imgwh,
                                width: imgwh,
                                fit: BoxFit
                                    .contain, // Изображ
                              )))),
                  AnimatedOpacity(
                      opacity: videoopacity,
                      duration: Duration(
                          milliseconds: 400),
                      child: AnimatedContainer(
                        margin: EdgeInsets.only(
                            top: 20),
                        duration: Duration(
                            milliseconds: 400),
                        child:
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AutoSizeText(namemus,
                              textAlign: TextAlign
                                  .start,
                              overflow: TextOverflow
                                  .ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                  fontSize: 30,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight
                                      .w500,
                                  color: Color.fromARGB(
                                      255, 246, 244,
                                      244)
                              ),),
                            AutoSizeText(ispolmus,
                              overflow: TextOverflow
                                  .ellipsis,
                              maxLines: 1,
                              textAlign: TextAlign
                                  .start,
                              style: TextStyle(
                                  fontSize: 24,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight
                                      .w300,
                                  color: Color
                                      .fromARGB(
                                      255, 246, 244,
                                      244)
                              ),)
                          ],),))

                ],))))],),



                  Row( mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [Container(
          width: size.width/2, child: AnimatedOpacity(
          opacity: opacityi3,
          duration: Duration(
          milliseconds: 400),
          child:  Container(
                      constraints: BoxConstraints(maxWidth: 800, maxHeight: 800), child: AspectRatio(
                      aspectRatio: 1,
                      // Сохранение пропорций 1:1
                      child: AnimatedOpacity(
                          opacity: opacityi1,
                          duration: Duration(
                              milliseconds: 0),
                          child: AnimatedBuilder(
                              animation: animation,
                              builder: (context,
                                  child) {
                                return Align(
                                    alignment: animation
                                        .value,
                                    child:
                                    AnimatedContainer(
                                        constraints: BoxConstraints(maxWidth: 800, maxHeight: 800),
                                        margin: EdgeInsets
                                            .only(
                                            left: 30,
                                            right: 30,
                                            top: 30, bottom: 30),
                                        height: imgwh,
                                        width: imgwh,
                                        decoration: BoxDecoration(
                                          shape: BoxShape
                                              .rectangle,
                                          borderRadius: BorderRadius
                                              .circular(
                                              dsds),
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
                              })))))), Container(
          width: size.width/3, child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [AnimatedOpacity(opacity: opacity,
                      duration: Duration(
                          milliseconds: 400),
                      onEnd: () {
                        setnewState(() {
                          if (videoope) {
                            dsadsa = MediaQuery
                                .of(context)
                                .size.width;
                            opacityi1 = 0;
                            videoopacity = 1;
                          }
                        });
                      },
                      child: AnimatedContainer(
                          width: size.width,
                          duration: Duration(
                              milliseconds: 400),
                          transform: Matrix4
                              .translation(
                              vector.Vector3(
                                  0, 0, 0)),
                          child: AutoSizeText(namemus,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.fade,
                            maxLines: 1,
                            style: TextStyle(
                                fontSize: 30,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight
                                    .w500,
                                color: Color.fromARGB(
                                    255, 246, 244, 244)
                            ),))),
                    AnimatedOpacity(opacity: opacity,
                        duration: Duration(
                            milliseconds: 400),
                        child: AnimatedContainer(
                            duration: Duration(
                                milliseconds: 400),
                            transform: Matrix4
                                .translation(
                                vector.Vector3(
                                    0, 0, 0)),
                            child: AutoSizeText(ispolmus,
                              overflow: TextOverflow.fade,
                              maxLines: 1,

                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 24,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight
                                      .w300,
                                  color: Color.fromARGB(
                                      255, 246, 244, 244)
                              ),))),
                    AnimatedOpacity(opacity: opacity,
                        duration: Duration(
                            milliseconds: 400),
                        child: AnimatedContainer(
                            duration: Duration(
                                milliseconds: 400),
                            transform: Matrix4
                                .translation(
                                vector.Vector3(
                                    0, 0, 0)),
                            child: Padding(
                                padding: EdgeInsets.only(
                                    top: 16,
                                    left: 22,
                                    right: 22),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    AutoSizeText(formatDuration(
                                        Duration(
                                            milliseconds: currentPosition
                                                .toInt())),
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight
                                              .w400,
                                          color: Color
                                              .fromARGB(
                                              255, 246,
                                              244,
                                              244)
                                      ),),
                                    AutoSizeText(formatDuration(
                                        Duration(
                                            milliseconds: totalDuration
                                                .toInt())),
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight
                                              .w400,
                                          color: Color
                                              .fromARGB(
                                              255, 246,
                                              244,
                                              244)
                                      ),),
                                  ],)))),
                    SizedBox(height: 4,),
                    AnimatedOpacity(opacity: opacity,
                        duration: Duration(
                            milliseconds: 400),
                        child: AnimatedContainer(
                            duration: Duration(
                                milliseconds: 400),
                            transform: Matrix4
                                .translation(
                                vector.Vector3(
                                    0, 0, 0)),
                            child: SizedBox(
                                height: 8,
                                child:  StreamBuilder(
                                    stream: AudioService
                                        .positionStream,
                                    builder: (context,
                                        snapshot) {
                                      if (snapshot
                                          .hasData &&
                                          !snapshot
                                              .hasError &&
                                          totalDuration >
                                              0) {
                                        final position = snapshot
                                            .data as Duration;
                                        return GestureDetector(
                                          onTapDown: (_) {
                                            setState(() {
                                              isPressed = true; // Устанавливаем флаг нажатия
                                              scaleY = 1.4; // Увеличиваем слайдер по оси Y
                                              translateX = 12.0; // Сдвигаем слайдер влево
                                            });
                                          },
                                          onTapUp: (_) {
                                            setState(() {
                                              isPressed = false; // Сбрасываем флаг нажатия
                                              scaleY = 1.0; // Возвращаем слайдер к исходному размеру по оси Y
                                              translateX = 26.0; // Возвращаем слайдер в исходное положение
                                            });
                                          },
                                          child: AnimatedContainer(
                                            duration: Duration(milliseconds: 200),
                                            padding: EdgeInsets.symmetric(horizontal: translateX),
                                            curve: Curves.easeInOut,
                                            transform: Matrix4.identity()
                                              ..scale(1.0, scaleY), // Применяем масштаб
                                            child: FlutterSlider(
                                              values: isPressed ? [newposition] : [currentPosition],
                                              max: totalDuration,
                                              min: 0,
                                              tooltip: FlutterSliderTooltip(
                                                disabled: true, // Отключаем текст со значением
                                              ),
                                              handler: FlutterSliderHandler(
                                                decoration: BoxDecoration(
                                                  color: Colors.transparent, // Делаем thumb полностью прозрачным
                                                ),
                                                child: SizedBox.shrink(), // Полностью скрываем thumb
                                              ),
                                              onDragStarted: (handlerIndex, lowerValue, upperValue) {
                                                setState(() {
                                                  newposition = lowerValue;
                                                });
                                              },
                                              onDragging: (handlerIndex, lowerValue, upperValue) {
                                                // Обновляем текущую позицию слайдера, но не меняем масштаб
                                                setState(() {
                                                  newposition = lowerValue; // Обновляем текущую позицию слайдера
                                                  setState(() {
                                                    isPressed = true; // Устанавливаем флаг нажатия
                                                    scaleY = 1.4; // Увеличиваем слайдер по оси Y
                                                    translateX = 12.0; // Сдвигаем слайдер влево
                                                  });
                                                });
                                              },
                                              onDragCompleted: (handlerIndex, lowerValue, upperValue) {
                                                // Логика завершения перетаскивания
                                                setState(() {
                                                  currentPosition = lowerValue;
                                                });
                                                Duration jda = Duration(milliseconds: lowerValue.toInt());
                                                print("Position: ${jda.inMilliseconds} ms");
                                                setState(() {
                                                  isPressed = false; // Сбрасываем флаг нажатия
                                                  scaleY = 1.0; // Возвращаем слайдер к исходному размеру по оси Y
                                                  translateX = 26.0; // Возвращаем слайдер в исходное положение
                                                });
                                                if (devicecon) {
                                                  List<dynamic> sdc = [
                                                    {
                                                      "type": "media",
                                                      "what": "seekto",
                                                      "timecurrent": jda.inSeconds,
                                                      "iddevice": "2"
                                                    }
                                                  ];
                                                  String jsonString = jsonEncode(sdc[0]);
                                                  // Предполагается, что channeldev доступен и открыт для отправки
                                                  channeldev.sink.add(jsonString);
                                                } else {
                                                  if (instalumusa) {
                                                    AudioService.seekTo(Duration(milliseconds: lowerValue.toInt() * 2));
                                                  } else {
                                                    AudioService.seekTo(Duration(milliseconds: lowerValue.toInt()));
                                                  }
                                                }
                                              },
                                              trackBar: FlutterSliderTrackBar(
                                                activeTrackBarHeight: 8,
                                                inactiveTrackBarHeight: 8,
                                                activeTrackBar: BoxDecoration(
                                                  color: Colors.blue,
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                inactiveTrackBar: BoxDecoration(
                                                  color: Colors.blue.withOpacity(0.3),
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      } else {
                                        return GestureDetector(
                                          onTapDown: (_) {
                                            setState(() {
                                              isPressed = true; // Устанавливаем флаг нажатия
                                              scaleY = 1.4; // Увеличиваем слайдер по оси Y
                                              translateX = 12.0; // Сдвигаем слайдер влево
                                            });
                                          },
                                          onTapUp: (_) {
                                            setState(() {
                                              isPressed = false; // Сбрасываем флаг нажатия
                                              scaleY = 1.0; // Возвращаем слайдер к исходному размеру по оси Y
                                              translateX = 26.0; // Возвращаем слайдер в исходное положение
                                            });
                                          },
                                          child: AnimatedContainer(
                                            duration: Duration(milliseconds: 200),
                                            padding: EdgeInsets.symmetric(horizontal: translateX),
                                            curve: Curves.easeInOut,
                                            transform: Matrix4.identity()
                                              ..scale(1.0, scaleY), // Применяем масштаб
                                            child: FlutterSlider(
                                              values: isPressed ? [newposition] : [currentPosition],
                                              max: totalDuration,
                                              min: 0,
                                              tooltip: FlutterSliderTooltip(
                                                disabled: true, // Отключаем текст со значением
                                              ),
                                              handler: FlutterSliderHandler(
                                                decoration: BoxDecoration(
                                                  color: Colors.transparent, // Делаем thumb полностью прозрачным
                                                ),
                                                child: SizedBox.shrink(), // Полностью скрываем thumb
                                              ),
                                              onDragStarted: (handlerIndex, lowerValue, upperValue) {
                                                setState(() {
                                                  newposition = lowerValue;
                                                });
                                              },
                                              onDragging: (handlerIndex, lowerValue, upperValue) {
                                                // Обновляем текущую позицию слайдера, но не меняем масштаб
                                                setState(() {
                                                  newposition = lowerValue; // Обновляем текущую позицию слайдера
                                                  setState(() {
                                                    isPressed = true; // Устанавливаем флаг нажатия
                                                    scaleY = 1.4; // Увеличиваем слайдер по оси Y
                                                    translateX = 12.0; // Сдвигаем слайдер влево
                                                  });
                                                });
                                              },
                                              onDragCompleted: (handlerIndex, lowerValue, upperValue) {
                                                // Логика завершения перетаскивания
                                                setState(() {
                                                  currentPosition = lowerValue;
                                                });
                                                Duration jda = Duration(milliseconds: lowerValue.toInt());
                                                print("Position: ${jda.inMilliseconds} ms");
                                                setState(() {
                                                  isPressed = false; // Сбрасываем флаг нажатия
                                                  scaleY = 1.0; // Возвращаем слайдер к исходному размеру по оси Y
                                                  translateX = 26.0; // Возвращаем слайдер в исходное положение
                                                });
                                                if (devicecon) {
                                                  List<dynamic> sdc = [
                                                    {
                                                      "type": "media",
                                                      "what": "seekto",
                                                      "timecurrent": jda.inSeconds,
                                                      "iddevice": "2"
                                                    }
                                                  ];
                                                  String jsonString = jsonEncode(sdc[0]);
                                                  // Предполагается, что channeldev доступен и открыт для отправки
                                                  channeldev.sink.add(jsonString);
                                                } else {
                                                  if (instalumusa) {
                                                    AudioService.seekTo(Duration(milliseconds: lowerValue.toInt() * 2));
                                                  } else {
                                                    AudioService.seekTo(Duration(milliseconds: lowerValue.toInt()));
                                                  }
                                                }
                                              },
                                              trackBar: FlutterSliderTrackBar(
                                                activeTrackBarHeight: 8,
                                                inactiveTrackBarHeight: 8,
                                                activeTrackBar: BoxDecoration(
                                                  color: Colors.blue,
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                inactiveTrackBar: BoxDecoration(
                                                  color: Colors.blue.withOpacity(0.3),
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                  ),))),
                    SizedBox(height: 22,),
                    AnimatedContainer(
                        duration: Duration(
                            milliseconds: 400),
                        transform: Matrix4.translation(
                            vector.Vector3(
                                0, 0, 0)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment
                              .spaceAround,
                          crossAxisAlignment: CrossAxisAlignment
                              .center,
                          children: [
                            SizedBox(width: 50,
                                height: 50,
                                child: IconButton(
                                    disabledColor: Color.fromARGB(255, 123, 123, 124),
                                    onPressed: () {toggleLike(0);},
                                    icon: Image(
                                        color: Color.fromARGB(255, 255, 255, 255),
                                        image: isDisLiked ? AssetImage(
                                            'assets/images/unloveyes.png') : AssetImage(
                                            'assets/images/unloveno.png'),
                                        width: 100
                                    ))),
                            SizedBox(width: 50,
                                height: 50,
                                child: IconButton(
                                    disabledColor: canrevew ? Color.fromARGB(255, 255, 255, 255) : Color.fromARGB(255, 123, 123, 124),
                                    onPressed: canrevew ? previosmusic : null,
                                    icon: Image(
                                        color: canrevew ? Color.fromARGB(255, 255, 255, 255) : Color.fromARGB(255, 123, 123, 124),
                                        image: AssetImage(
                                            'assets/images/reveuws.png'),
                                        width: 100
                                    ))),
                            SizedBox(height: 50,
                                width: 50,
                                child: loadingmus ? CircularProgressIndicator() : IconButton(
                                    onPressed: () {
                                      setnewState(() {
                                        playpause();
                                      });
                                    },
                                    padding: EdgeInsets
                                        .zero,
                                    icon: AnimatedSwitcher(
                                        duration: Duration(milliseconds: 300),
                                        transitionBuilder: (Widget child, Animation<double> animation) {
                                          return RotationTransition(
                                            turns: Tween(begin: 0.75, end: 1.0).animate(animation),
                                            child: ScaleTransition(scale: animation, child: child),
                                          );
                                        }, child:  Icon(
                                      key: videoope ? ValueKey<bool>(controller.player.state.playing) : ValueKey<bool>(AudioService.playbackState.playing),
                                      iconpla.icon,
                                      size: 50,
                                      color: Colors
                                          .white,)))),
                            SizedBox(width: 50,
                                height: 50,
                                child: IconButton(
                                    disabledColor: cannext ? Color.fromARGB(255, 255, 255, 255) : Color.fromARGB(255, 123, 123, 124),
                                    onPressed: cannext ? nextmusic : null,
                                    icon: Image(
                                      color: cannext ? Color.fromARGB(255, 255, 255, 255) : Color.fromARGB(255, 123, 123, 124),
                                      image: AssetImage(
                                          'assets/images/nexts.png'),
                                      width: 120,
                                      height: 120,
                                    ))),
                            SizedBox(width: 50,
                                height: 50,
                                child: IconButton(
                                    onPressed: () {toggleLike(1);}, // () {installmusic(langData[0]);},
                                    icon: Image(
                                        color: Color.fromARGB(255, 255, 255, 255),
                                        image: isLiked ? AssetImage(
                                            'assets/images/loveyes.png') : AssetImage(
                                            'assets/images/loveno.png'),
                                        width: 100
                                    ))),
                          ],)),
                    SizedBox(height: 22,),
                    AnimatedContainer(
                        duration: Duration(
                            milliseconds: 400),
                        transform: Matrix4.translation(
                            vector.Vector3(
                                0, 0, 0)),
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
                                    padding: EdgeInsets
                                        .zero,
                                    icon: Icon(
                                      Icons
                                          .devices_rounded,
                                      size: 50,
                                      color: Colors
                                          .white,))),
                            SizedBox(width: 50,
                                height: 50,
                                child: IconButton(
                                    disabledColor: Color.fromARGB(255, 123, 123, 124),
                                    onPressed: null,
                                    padding: EdgeInsets
                                        .zero,
                                    icon: Icon(
                                      Icons
                                          .queue_music_rounded,
                                      size: 50,
                                      color: Color.fromARGB(255, 123, 123, 124),))),
                            SizedBox(height: 50,
                                width: 50,
                                child: IconButton(
                                    disabledColor: Color.fromARGB(255, 123, 123, 124),
                                    onPressed: null,
                                    padding: EdgeInsets
                                        .zero,
                                    icon: Icon(Icons
                                        .settings_rounded,
                                      size: 50,
                                      color: Color.fromARGB(255, 123, 123, 124),))),
                            SizedBox(width: 50,
                                height: 50,
                                child: IconButton(
                                    disabledColor: Color.fromARGB(255, 123, 123, 124),
                                    onPressed: langData[0]['vidos'] != "0" ? () {
                                      setnewState(() {
                                        setvi(shazid,true, false);
                                      });
                                    }: null,
                                    padding: EdgeInsets
                                        .zero,
                                    icon: Image(
                                      color: langData[0]['vidos'] != "0" ? Color.fromARGB( 255, 255, 255, 255) : Color.fromARGB(255, 123, 123, 124),
                                      image: AssetImage(videoope ? 'assets/images/musicon.png' : 'assets/images/video.png'),
                                      width: 120,
                                      height: 120,
                                    ))),
                          ],))],)), Container(width: size.width/10,) ],),

              ],))
        ])
          );}
    );
  }

  late BorderRadius borderRadius =  MediaQuery.of(context).size.width >= 800 ? BorderRadius.circular(20) : BorderRadius.circular(0);
  void _showModalSheet() {
    if (!_isBottomSheetOpen) { // Проверяем, открыт ли BottomSheet
      _isBottomSheetOpen = true;
      Size size = MediaQuery
          .of(context)
          .size;
      showModalBottomSheet(
          constraints: BoxConstraints(
            maxWidth:  100000000,
          ),
          context: context,
          isScrollControlled: true,
          builder: (builder) {
            return Container(width: double.infinity,
            child: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  setnewState = setState;
                  double screenWidth = MediaQuery.of(context).size.width;
                  double screenhfg = MediaQuery.of(context).size.height;
                  setState(() {
                  // Determine the border radius based on screen width
                  squareScaleA = videoope ? screenWidth > 800 ? -320 : -60 * (screenWidth / 280) : 0;
                  squareScaleB = videoope ? 0 : screenWidth > 800 ? -320 : 80 * (screenWidth / 280);
                  });
                  borderRadius = screenWidth >= 800
                      ? BorderRadius.circular(20)
                      : BorderRadius.circular(0);
                   return  essensionbool ? (screenWidth >= screenhfg ?
                   bigscreenbottomshet() : smallscreenesensionbottomshet()) : (screenWidth >= screenhfg ?
                        bigscreenbottomshet() : smallscreenbottomshet());

          }));
          }
      ).whenComplete(() {
        _isBottomSheetOpen = false; // Когда BottomSheet закрывается, сбрасываем флаг
      });
    }
  }

  var iconpla = Icon(Icons.play_arrow_rounded, size: 40, key:  ValueKey<bool>(AudioService.playbackState.playing),);

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
                setmdState = setState;
                return Container(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 20),
                  decoration: BoxDecoration(borderRadius: BorderRadius.vertical(top: Radius.circular(16)), color: Color.fromARGB(255, 15, 15, 16)),
                  child: _loaddevicelist(),);
              }
          );
        }
    );
  }
  late StateSetter setmdState;
  late StateSetter setnewState;

  void connectToWebSocket() {

    _showModalSheetu();
    getdivecs();

  }


  Container buildMyNavBar(BuildContext context) {
    return
      Container(
          height: 134+ MediaQuery.of(context).padding.bottom,
          decoration: const BoxDecoration(
              color: Color.fromARGB(200, 25, 24, 24),
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
                    color: Color.fromARGB(0, 25, 24, 24),
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

                              leading: Padding(padding: kIsWeb ? EdgeInsets.only(left: 10, top: 8) : Platform.isWindows ?  EdgeInsets.only(left: 10, top: 8) :  EdgeInsets.only(left: 10, top: 4),
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
                              title: AutoSizeText(
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
                              subtitle: AutoSizeText(
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
                                child: loadingmus ? CircularProgressIndicator() : IconButton(
                                  icon: AnimatedSwitcher(
                                    duration: Duration(milliseconds: 300),
                                    transitionBuilder: (Widget child, Animation<double> animation) {
                                      return RotationTransition(
                                        turns: Tween(begin: 0.75, end: 1.0).animate(animation),
                                        child: ScaleTransition(scale: animation, child: child),
                                      );
                                    },
                                    child:iconpla),
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
  Widget _buildNavigator(GlobalKey<NavigatorState> navigatorKey, Widget page) {
    return Navigator(
      key: navigatorKey,
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(
          builder: (context) => page,
        );
      },
    );
  }

  late List<Widget> pages = [
    _buildNavigator(_playlistNavigatorKey, PlaylistScreen(onCallback: (dynamic input) {
      getaboutmus(input, false, false, false, false);
    }, hie: (){_openSearchPage(_getNavigatorKey(pageIndex).currentContext!);}, showlog: showlogin, resdf: resetapp, onCallbackt: (dynamic input, dynamic inputi, String asdsa) { loadpalylisttoochered(input, inputi, asdsa); },)),
    _buildNavigator(_homeNavigatorKey, MusicScreen(key: _childKey, onCallbackt: (dynamic input, dynamic inputi) { loadpalylisttoochered(input, inputi, "Джем"); }, onCallback: (dynamic input) {
      getaboutmus(input, false, false, false, false);
    }, onCallbacki: postRequesty, hie: (){_openSearchPage(_getNavigatorKey(pageIndex).currentContext!);}, showlog: showlogin, resre: resetapp, essension: essension, parctx: context,)),
    _buildNavigator(_videoNavigatorKey, VideoScreen(onCallback: (dynamic input) {
      setvi(input, false, true);
    }, hie: (){_openSearchPage(_getNavigatorKey(pageIndex).currentContext!);}, showlog: showlogin, dsad: resetapp,)),
  ];

  bool isjemnow = false;


  Future<void> _startServer() async {
    try {
      // Bind the server to localhost on port 6732
      _server = await HttpServer.bind('localhost', 6732);
      setState(() {
        _isServerRunning = true;
        adddevicetopull();
      });
      print('WebSocket server is running on ws://localhost:6732');

      // Listen for incoming HTTP requests and upgrade them to WebSocket connections
      await for (HttpRequest request in _server!) {
        if (WebSocketTransformer.isUpgradeRequest(request)) {
          WebSocket socket = await WebSocketTransformer.upgrade(request);
          _handleClient(socket);
        } else {
          request.response
            ..statusCode = HttpStatus.forbidden
            ..close();
        }
      }
    } catch (e) {
      print('Error starting WebSocket server: $e');
    }
  }

  // Stop the WebSocket server
  void _stopServer() {
    _server?.close();
    _clients.forEach((client) => client.close());
    _clients.clear();
    setState(() {
      _isServerRunning = false;
    });
    print('WebSocket server stopped');
  }

  // Handle WebSocket client connection
  void _handleClient(WebSocket socket) {
    print('Client connected: ${socket.hashCode}');
    _clients.add(socket);

    // Listen for messages from the client
    socket.listen((message) {
      print('Received message: $message');
      dynamic dj = jsonDecode(message);
      if(dj["type"].toString() == "checkonline"){
        print('{"name":"'+_deviceName+'", "status":"true"}');
        _broadcastMessage('{"name":"$_deviceName", "status":"true"}');
      }else if(dj["type"].toString() == "connect"){
        dj.removeWhere("connect");
        print(dj);
        connectdeviceinme(dj);
      }
      _broadcastMessage(message);
    }, onDone: () {
      print('Client disconnected: ${socket.hashCode}');
      _clients.remove(socket);
    }, onError: (error) {
      print('WebSocket error: $error');
    });
  }

  // Broadcast message to all connected clients
  void _broadcastMessage(String message) {
    for (var client in _clients) {
      if (client.readyState == WebSocket.open) {
        client.add(message);
      }
    }
  }

  void resetapp(){
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
          (Route<dynamic> route) => false, // Удаление всех предыдущих маршрутов
    );
  }

  void showlogin(){
    Navigator.push(context, MaterialPageRoute(builder: (context) =>  LoginScreen(resetap: resetapp)));
  }

  @override
  void dispose() {
    _stopServer();
    _pageController.removeListener(_onPageChanged);
    _pageController.dispose();
    videob.dispose();
    videoshort.dispose();
    super.dispose();
  }
  String _jemData = "132";

  Future<void> postRequesty () async {
    if(!isjemnow) {
      String dff = await apiService.getJemRandom();
      print(dff);
      setState(() {
        _jemData = dff;
        getaboutmus(_jemData, true, false, false, false);
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
      setmdState(() {
        devicelis.clear();
        List<dynamic> dj = jsonDecode(dff);
        if(devici["id"]!= "0"){
          devicelis.add({
            "id": "0",
            "ip": "",
            "name": "Это устройство",
            "status": "true",
            "connected": "0"
          });
        }else {
          devicelis.add({
            "id": "0",
            "ip": "",
            "name": "Это устройство",
            "status": "true",
            "connected": "1"
          });
        }
        for (var num in dj) {
          if(num["id"]!=devici["id"]){
          String ipixa = num["ip"];
          try{
          final channel = WebSocketChannel.connect(
              Uri.parse('ws://' + ipixa + ':6732'));



          List<dynamic> sdc = [{"type": "checkonline"}];
          String jsonString = jsonEncode(sdc[0]);
          channel.sink.add(jsonString);
          channel.stream.listen((message) {
            List<dynamic> sdbf = [];
            print('Recived: $message');
            sdbf.add(jsonDecode(message));
            if (sdbf[0]["status"].toString() == "true") {
              print('Connected: $message');
              channel.sink.close(
                  status.normalClosure, 'Client closed connection');
              setState(() {
                setmdState(() {
              devicelis.add({
                "id": num["id"],
                "ip": num["ip"],
                "name": num["name"],
                "status": "true",
                "connected": "0"
              });
                });
              });
            } else {
              setmdState(() {
              devicelis.add({
                "id": num["id"],
                "ip": num["ip"],
                "name": num["name"],
                "status": "false",
                "connected": "0"

              });
              channel.sink.close(
                  status.normalClosure, 'Client closed connection');
              });
            }
          });

        }catch(eer){
            devicelis.add({
              "id": num["id"],
              "ip": num["ip"],
              "name": num["name"],
              "status": "false",
              "connected": "0"
            });
          }
          }else{
            setmdState(() {
            devicelis.add({
              "id": num["id"],
              "ip": num["ip"],
              "name": num["name"],
              "status": "true",
              "connected": "1"
            });
            });
          }
        }
      });
  }
  late WebSocketChannel channeldev;
  dynamic devici = {"id": "0"};
  bool devicecon = false;

  bool deviceconinme = false;
  dynamic devicinme = {"id": "0"};

  void connectdeviceinme(dynamic sdv){
    if(sdv["id"]!=devicinme["id"]) {
      devicinme = sdv;
      deviceconinme = true;
    }
  }

  void connectdevice(dynamic sdv){
    if(sdv["id"]!=devici["id"]) {
      channeldev =
          WebSocketChannel.connect(Uri.parse('ws://' + sdv["ip"] + ':6732'));
      List<dynamic> sdc = [{"type": "connect", "name": _deviceName, "id": "2"}];
      String jsonString = jsonEncode(sdc[0]);
      channeldev.sink.add(jsonString);
      print(jsonString);
      channeldev.stream.listen((message) {
        List<dynamic> sdbf = [];
        print('Recived: $message');
        sdbf.add(jsonDecode(message));
        if (sdbf[0]["status"].toString() == "true") {
          devici = sdv;
          devicecon = true;
          Duration sc = Duration(milliseconds: currentPosition.toInt());
          List<dynamic> sdc = [
            {
              "type": "openmus",
              "id": langData[0]["id"],
              "idshaz": langData[0]["idshaz"],
              "vidos": videoope.toString(),
              "timecurrent": sc.inSeconds.toString(),
              "iddevice": "2"
            }
          ];
          String jsonString = jsonEncode(sdc[0]);
          channeldev.sink.add(jsonString);
          print(jsonString);
        }else if (sdbf[0]["status"].toString() == "play") {
              if(sdbf[0]["playing"].toString() == "false"){
                setState(() {
                  setnewState(() {
                  iconpla = Icon(Icons.play_arrow_rounded, size: 40,key: ValueKey<bool>(AudioService.playbackState.playing));
                  if (isjemnow) {
                    _childKey.currentState?.toggleAnimation(false);
                    _childKey.currentState?.updateIcon(Icon(
                        Icons.play_arrow_rounded, size: 64, color: Colors.white,key: ValueKey<bool>(AudioService.playbackState.playing)));
                  }
                  if (essensionbool) {
                    _childKey.currentState?.toggleAnimationese(false);
                    _childKey.currentState?.updateIconese(Icon(
                        Icons.play_arrow_rounded, size: 64, color: Colors.white,key: ValueKey<bool>(AudioService.playbackState.playing)));
                  }
                  });
                });
              }else{
                setState(() {
                  setnewState(() {
                  iconpla = Icon(Icons.pause_rounded, size: 40,key: ValueKey<bool>(AudioService.playbackState.playing));
                  if (isjemnow) {
                    _childKey.currentState?.toggleAnimation(true);
                    _childKey.currentState?.updateIcon(
                        Icon(Icons.pause_rounded, size: 64, color: Colors.white,key: ValueKey<bool>(AudioService.playbackState.playing)));
                  }
                  if (essensionbool) {
                    _childKey.currentState?.toggleAnimationese(true);
                    _childKey.currentState?.updateIconese(Icon(
                        Icons.pause_rounded, size: 64, color: Colors.white,key: ValueKey<bool>(AudioService.playbackState.playing)));
                  }
                  });});
              }
        }else if (sdbf[0]["status"].toString() == "seek") {
          setnewState(() {
          Duration sdfsad = Duration(seconds:double.parse(sdbf[0]["timecur"].toString()).toInt());
          currentPosition = sdfsad.inMilliseconds.toDouble();
          });
          if(sdbf[0]["playing"].toString() == "false"){
            setState(() {
              setnewState(() {
              iconpla = Icon(Icons.play_arrow_rounded, size: 40,key: ValueKey<bool>(AudioService.playbackState.playing));
              if (isjemnow) {
                _childKey.currentState?.toggleAnimation(false);
                _childKey.currentState?.updateIcon(Icon(
                    Icons.play_arrow_rounded, size: 64, color: Colors.white,key: ValueKey<bool>(AudioService.playbackState.playing)));
              }
              if (essensionbool) {
                _childKey.currentState?.toggleAnimationese(false);
                _childKey.currentState?.updateIconese(Icon(
                    Icons.play_arrow_rounded, size: 64, color: Colors.white,key: ValueKey<bool>(AudioService.playbackState.playing)));
              }
              });});
          }else{
            setState(() {
              setnewState(() {
              iconpla = Icon(Icons.pause_rounded, size: 40,key: ValueKey<bool>(AudioService.playbackState.playing));
              if (isjemnow) {
                _childKey.currentState?.toggleAnimation(true);
                _childKey.currentState?.updateIcon(
                    Icon(Icons.pause_rounded, size: 64, color: Colors.white,key: ValueKey<bool>(AudioService.playbackState.playing)));
              }
              if (essensionbool) {
                _childKey.currentState?.toggleAnimationese(true);
                _childKey.currentState?.updateIconese(Icon(
                    Icons.pause_rounded, size: 64, color: Colors.white,key: ValueKey<bool>(AudioService.playbackState.playing)));
              }
              });});
          }
        }
        });
    }else{
      Duration sc = Duration(milliseconds: currentPosition.toInt());
      List<dynamic> sdc = [
        {
          "type": "openmus",
          "id": langData[0]["id"],
          "idshaz": langData[0]["idshaz"],
          "vidos": videoope.toString(),
          "timecurrent": sc.inSeconds.toString(),
          "iddevice": "2"
        }
      ];
      String jsonString = jsonEncode(sdc[0]);
      channeldev.sink.add(jsonString);
    }
    AudioService.pause();
    Navigator.pop(context);
  }

  String _deviceName = 'Unknown Device';
  String _os = 'Unknown OS';
  Future<void> getnamedevice() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        setState(() {
          _deviceName = androidInfo.model; // Gets the device model name for Android
          _os = "Android";
        });
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        setState(() {
          _deviceName = iosInfo.name; // Gets the name set by the user on iOS
          _os = "iOS";
        });
      } else if (Platform.isMacOS) {
        MacOsDeviceInfo macInfo = await deviceInfo.macOsInfo;
        setState(() {
          _deviceName = macInfo.computerName; // Gets the computer name on macOS
          _os = "macOS";
        });
      } else if (Platform.isWindows) {
        WindowsDeviceInfo windowsInfo = await deviceInfo.windowsInfo;
        setState(() {
          _deviceName = windowsInfo.computerName; // Gets the computer name on Windows
          _os = "Windows";
        });
      } else if (Platform.isLinux) {
        LinuxDeviceInfo linuxInfo = await deviceInfo.linuxInfo;
        setState(() {
          _deviceName = linuxInfo.name; // Gets the name of the Linux machine
          _os = "Linux";
        });
      } else if (kIsWeb) {
        setState(() {
          _deviceName = "Web Browser"; // Gets the browser's user agent string for Web
          _os = "Web";
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
              leading: SizedBox(width: 60,
                height: 60,
                child: Row(mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                          SizedBox(
                      width: 60,
                      height: 60,
                      child: Icon(Icons.device_unknown_rounded, color: devicelis[idx]['status'] == "true" ? Colors.white : Colors.grey,),),
                  ],),),
              title: AutoSizeText(
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


  Future<void> _getLocalIp() async {
    try {
      // Get the list of network interfaces
      List<NetworkInterface> interfaces = await NetworkInterface.list(
        includeLoopback: false, // Exclude loopback addresses
        type: InternetAddressType.IPv4, // We are interested in IPv4 addresses
      );

      // Select the first active interface's IP address
      if (interfaces.isNotEmpty) {
        setState(() {
          _localIp = interfaces.first.addresses.first.address;
        });
      } else {
        setState(() {
          _localIp = 'No active network interface found.';
        });
      }
    } catch (e) {
      setState(() {
        _localIp = 'Failed to get local IP: $e';
      });
    }
  }
  String? _localIp;
  Future<void> adddevicetopull() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tr = prefs.getString("token");
    http.Response response = await http.get(Uri.parse("https://kompot.site/getdeviceblast?createip="+_localIp!+"&tokeni="+tr!+"&name="+_deviceName+"&os="+_os));

  }

  void showtext(){
    if(!videoope){

    }
  }
  void _onDoubleTap(TapDownDetails details, BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final tapPosition = details.globalPosition.dx;

    // Если двойное нажатие произошло на левом краю экрана (первые 10% экрана)
    if (tapPosition < screenWidth * 0.2) {
      _skipBackward();
    }
    // Если двойное нажатие произошло на правом краю экрана (последние 10% экрана)
    else if (tapPosition > screenWidth * 0.8) {
      _skipForward();
    }
  }

  void _skipForward() async {
    final newPosition =  Duration(milliseconds: currentPosition.toInt()) + Duration(seconds: 5);
    AudioService.seekTo(newPosition);
  }

  void _skipBackward() async {
    final newPosition = Duration(milliseconds: currentPosition.toInt()) - Duration(seconds: 5);
    if (newPosition < Duration.zero) {
      AudioService.seekTo(Duration.zero); // Предотвращение отрицательной позиции
    } else {
      AudioService.seekTo(newPosition);
    }
  }




  Future<void> installmusic(dynamic mus) async {

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? sac = prefs.getStringList("installmusid");
    if (sac != null) {
      if (sac.isNotEmpty) {
        if (sac.contains(langData[0]["idshaz"])) {

        }else{
          ins(mus);
        }
      }else{
        ins(mus);
      }
    }else{
      ins(mus);
    }
  }

  Future<void> ins(dynamic mus) async {
    Directory tempDir = await getApplicationDocumentsDirectory();
    String tempPath = tempDir.path;
    String filename = mus["id"].toString() + ".mp3";
    File tempFile = File('$tempPath/$filename');

    http.Response response = await http.get(Uri.parse(mus["url"]));
    // todo - check status
    await tempFile.writeAsBytes(response.bodyBytes, flush: true);
    DateTime now = DateTime.now();
    String formattedDateTime = DateFormat('yyyyMMddHHmmss').format(now);
    String mrp = '{"id":"' + mus["id"] + '","idshaz":"' + mus["idshaz"] +
        '","img":"' + mus["img"] + '","name":"' + mus["name"] +
        '", "message":"' + mus["message"] + '","txt":"' + mus["txt"] +
        '", "url":"' + tempFile.uri.toString() + '","date":"' +
        formattedDateTime + '"}';
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? dfrd = prefs.getString("installmus");
    List<String>? sac = prefs.getStringList("installmusid");
    List<dynamic> ds = [];
    List<String> fsaf = [];
    if (dfrd != null) {
      ds = jsonDecode(dfrd);
    }
    if (sac != null) {
      fsaf = sac;
    }
    ds.add(mrp.toString());
    fsaf.add(mus["idshaz"]);
    await prefs.setStringList("installmusid", fsaf);
    await prefs.setString("installmus", jsonEncode(ds));
    print(mrp.toString());
  }

  bool ispalylistochered = false;

  void loadpalylisttoochered(var listokd, var index, String asdsa){
    // ocherd.clear();
    // for (var num in listokd) {
    //  ocherd.add(num["idshaz"]);
    //}
    // getaboutmus(ocherd[index], false, false, false, true);
    // ispalylistochered = true;

    List<MediaItem> playlist = [];
    for (var num in listokd) {
      playlist.add(MediaItem(
        id: num['id'],
        artUri: Uri.parse(num['img']),
        artist: num['message'],
        title: num['name'],
        extras: {
          'idshaz': num['idshaz'],
          'url': num['url'],
          'messageimg': num['messageimg'],
          'short': num['short'],
          'txt': num['txt'],
          'vidos': num['vidos'],
          'bgvideo': num['bgvideo'],
          'elir': num['elir'],
        },
      ));
    }
    setQueue(playlist, index);
    print("objectqueue");
    context.read<QueueManagerProvider>().setQueue(listokd);
    context.read<QueueManagerProvider>().setCurrentAlbum(asdsa);
    print("objectqueue");
  }


  Future<void> addToQueue(MediaItem track) async {
    Map<String, dynamic> trackData = {
      'id': track.id,
      'title': track.title,
      'artist': track.artist,
      'album': track.album,
      'artUri': track.artUri?.toString(),
      'extras': track.extras,
      'duration': track.duration?.inMilliseconds,
    };

    await AudioService.customAction('addToQueue', {'track': trackData});
  }



  Future<void> removeFromQueue(String trackId) async {
    await AudioService.customAction('removeFromQueue', {'trackId': trackId});
  }


  Future<void> setQueue(List<MediaItem> playlist, int inx) async {
    // Преобразуем список MediaItem в список Map<String, dynamic>
    List<Map<String, dynamic>> tracks = playlist.map((track) {
      return {
        'id': track.id,
        'title': track.title,
        'artist': track.artist,
        'album': track.album,
        'artUri': track.artUri?.toString(),
        'extras': track.extras,
        'duration': track.duration?.inMilliseconds,
      };
    }).toList();
    print("hnghngb"+tracks.toString());


    if(shazid != playlist[inx].extras?['idshaz']) {
      print("fdvsvsv1"+playlist[inx].extras!['vidos'].toString());
      if(playlist[inx].extras?['vidos'] != "0" && videoope == true) {
        print("fdvsvsv2");
        await AudioService.customAction('setQueue',
            {'playlist': tracks, 'startIndex': inx, 'needplay': false});
      }else{
        print("fdvsvsv");
        await AudioService.customAction('setQueue',
            {'playlist': tracks, 'startIndex': inx, 'needplay': true});
      }
      await getaboutmusmini(playlist[inx]);
    }else{
      await AudioService.customAction('setQueue', {'playlist': tracks, 'startIndex': inx, 'needplay': false});
      await getaboutmusmini(playlist[inx]);
    }
  }



  void showtextmus(){

  }

  void addplaylist(){

  }

  void deletemus(){

  }

  void sharemus(){

  }



  void setqualitymus(){

  }
  bool cannext = false;
  bool canrevew = false;
  Future<void> nextmusic() async {
     if (isLoading) return; // Блокируем повторное нажатие во время запроса
     setState(() {
       isLoading = true;
    });
    try {
    //   if (ispalylistochered) {
    //     int dsv = ocherd.indexOf(langData[0]["idshaz"]);
    //     if (dsv + 2 <= ocherd.length) {
    //       getaboutmus(ocherd[dsv + 1].toString(), false, false, false, true);
    //     }
    //   } else {
     //  }
      if(videoope){
        print("nextvid1");
        await AudioService.customAction('sendnexttrack', {});
      }else {
        await AudioService.customAction('next', {});
      }
     }finally{
       isLoading = false;
     }
  }


  Future<void> previosmusic() async {
    if (isLoading) return; // Блокируем повторное нажатие во время запроса
    setState(() {
      isLoading = true;
    });
    try {
      //   if (ispalylistochered) {
      //     int dsv = ocherd.indexOf(langData[0]["idshaz"]);
      //     if (dsv - 1 > 0) {
      //      getaboutmus(ocherd[dsv - 1].toString(), false, false, false, true);
      //   }
      // } else {
      // }
      if(videoope){
        await AudioService.customAction('sendprevioustrack', {});
      }else {
        await AudioService.customAction('previous', {});
      }
    }finally{
      isLoading = false;
    }
  }

}
void _audioPlayerTaskEntrypoint() async {
  await AudioServiceBackground.run(() => AudioPlayerTask());
}