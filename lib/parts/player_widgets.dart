import 'dart:convert';

import 'package:audio_service/audio_service.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:blast/screens/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'package:marquee/marquee.dart';

import 'bottomsheet_about_music.dart';


bool _shouldScroll(String text, TextStyle style, double maxWidth) {
  final TextPainter textPainter = TextPainter(
    text: TextSpan(text: text, style: style),
    maxLines: 1,
    textDirection: TextDirection.ltr,
  )..layout();

  return textPainter.width > maxWidth;
}
double _getTextWidth(String text, TextStyle style) {
  final TextPainter textPainter = TextPainter(
    text: TextSpan(text: text, style: style),
    maxLines: 1,
    textDirection: TextDirection.ltr,
  )..layout();

  return textPainter.width; // Возвращает точную ширину текста
}


// Метод для отображения текста или Marquee
Widget _buildTextOrMarquee(String text, TextStyle style, double maxWidth) {
  final TextPainter textPainter = TextPainter(
    text: TextSpan(text: text, style: style),
    maxLines: 1,
    textDirection: TextDirection.ltr,
  )..layout();

  final bool shouldScroll = textPainter.width > maxWidth;

  if (!shouldScroll) {
    // Если текст помещается, отображаем его статично
    return Text(
      text,
      style: style,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      textAlign: TextAlign.center,
    );
  }

  // Если текст не помещается, включаем Marquee
  return Marquee(
    text: text,
    style: style,
    scrollAxis: Axis.horizontal,
    blankSpace: 20.0,
    velocity: 50.0,
    pauseAfterRound: const Duration(seconds: 1),
    startPadding: 10.0,
    accelerationDuration: const Duration(seconds: 1),
    accelerationCurve: Curves.linear,
    decelerationDuration: const Duration(milliseconds: 500),
    decelerationCurve: Curves.easeOut,
  );
}

class RoundedImage extends StatelessWidget {
  final String imageUrl;
  final double size;

  const RoundedImage({
    required this.imageUrl,
    required this.size,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(size / 10), // Закругление
      child: Image.network(
        imageUrl,
        width: size,
        height: size,
        fit: BoxFit.cover, // Заполнение без искажений
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                  (loadingProgress.expectedTotalBytes ?? 1)
                  : null,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) => const Icon(
          Icons.error,
          size: 50,
          color: Colors.red,
        ),
      ),
    );
  }
}

class PlayerWidget extends StatefulWidget {
  final GlobalKey<HomeScreenState> page;
  const PlayerWidget({Key? key, required this.page}) : super(key: key);

  @override
  PlayerWidgetState createState() => PlayerWidgetState();
}

class PlayerWidgetState extends State<PlayerWidget> {

  @override
  Widget build(BuildContext context) {
    final homi = widget.page.currentState!;
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
      backgroundColor: const Color(0xFF0f0f10),
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
                                  homi.connectToWebSocket();
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
                                  showTrackOptionsBottomSheet(context, homi.langData[0]);
                                },
                                padding: EdgeInsets
                                    .zero,
                                icon: Icon(Icons
                                    .more_vert_rounded,
                                  size: 30,
                                  color: Color.fromARGB(255, 123, 123, 124),)))
                      ],)),
                  // Обложка, круглая картинка исполнителя и информация о песне
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      AnimatedOpacity(
                          opacity: homi.opacityi1,
                          duration: Duration(
                              milliseconds: 0),
                          child: AnimatedBuilder(
                              animation: homi.animation,
                              builder: (context,
                                  child) {
                                return Align(
                                    alignment: homi.animation
                                        .value,
                                    child:
                                    AnimatedContainer(
                                      constraints: BoxConstraints(maxWidth: 800, maxHeight: 800),
                                      margin: EdgeInsets
                                          .only(
                                        left: 30,
                                        right: 30,),
                                      height: homi.imgwh == 80 ? homi.imgwh : imageHeight,
                                      width: homi.imgwh == 80 ? homi.imgwh : imageHeight,
                                      duration: Duration(
                                          milliseconds: 400),
                                      child: RoundedImage(imageUrl: homi.imgmus, size: imageHeight),
                                    ));})),

                      const SizedBox(height: 16),
                      AnimatedOpacity(opacity: homi.opacity,
                          duration: Duration(
                              milliseconds: 400),
                          onEnd: () {
                            homi.setnewState(() {
                              if (homi.videoope) {
                                homi.opacityi1 = 0;
                                homi.opacityi2 = 1;
                              }
                            });
                          },
                          child: AnimatedContainer(
                              duration: Duration(
                                  milliseconds: 400),
                              transform: Matrix4
                                  .translation(
                                  vector.Vector3(
                                      0, homi.squareScaleA, 0)),
                              child: Container(
                                height: 50,
                                alignment: Alignment.center,
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width - 32,
                                child: _buildTextOrMarquee(
                                    homi.namemus, nameStyle, MediaQuery
                                    .of(context)
                                    .size
                                    .width - 32),
                              ))),
                      AnimatedOpacity(opacity: homi.opacity,
                          duration: Duration(
                              milliseconds: 400),
                          child: AnimatedContainer(
                            alignment: Alignment.center,
                            duration: Duration(
                                milliseconds: 400),
                            transform: Matrix4
                                .translation(
                                vector.Vector3(
                                    0, homi.squareScaleA, 0)),
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
                                      "https://via.placeholder.com/150", // Ссылка на изображение исполнителя
                                    ),
                                    backgroundColor: Colors
                                        .grey[800], // Цвет фона, если изображения нет
                                  ),
                                  const SizedBox(width: 8),
                                  // Имя исполнителя
                                  Container(
                                    height: 50,
                                    alignment: Alignment.center,
                                    width: _shouldScroll(
                                        homi.ispolmus, artistStyle, MediaQuery
                                        .of(context)
                                        .size
                                        .width - 120) ? MediaQuery
                                        .of(context)
                                        .size
                                        .width - 120 : _getTextWidth(
                                        homi.ispolmus, artistStyle) + 16,
                                    child: _buildTextOrMarquee(
                                      homi.ispolmus,
                                      artistStyle,
                                      _shouldScroll(
                                          homi.ispolmus, artistStyle, MediaQuery
                                          .of(context)
                                          .size
                                          .width - 120) ? MediaQuery
                                          .of(context)
                                          .size
                                          .width - 120 : _getTextWidth(
                                          homi.ispolmus, artistStyle) + 16,
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
                      AnimatedOpacity(opacity: homi.opacity,
                          duration: Duration(
                              milliseconds: 400),
                          child: AnimatedContainer(
                              duration: Duration(
                                  milliseconds: 400),
                              transform: Matrix4
                                  .translation(
                                  vector.Vector3(
                                      0, homi.squareScaleA, 0)),
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
                                        homi.totalDuration >
                                            0) {
                                      final position = snapshot
                                          .data as Duration;
                                      return
                                        GestureDetector(
                                          onTapDown: (_) {
                                            homi.setState(() {
                                              homi.isPressed =
                                              true; // Устанавливаем флаг нажатия
                                              homi.scaleY =
                                              1.4; // Увеличиваем слайдер по оси Y
                                              homi.translateX =
                                              12.0; // Сдвигаем слайдер влево
                                              homi.translateY = 10.0;
                                            });
                                          },
                                          onTapUp: (_) {
                                            homi.setState(() {
                                              homi.isPressed =
                                              false; // Сбрасываем флаг нажатия
                                              homi.scaleY =
                                              1.0; // Возвращаем слайдер к исходному размеру по оси Y
                                              homi.translateX =
                                              26.0; // Возвращаем слайдер в исходное положение
                                              homi.translateY = 4.0;
                                            });
                                          },
                                          child: AnimatedContainer(
                                            duration: Duration(
                                                milliseconds: 200),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: homi.translateX),
                                            curve: Curves.easeInOut,
                                            transform: Matrix4.identity()
                                              ..scale(1.0, homi.scaleY),
                                            // Применяем масштаб
                                            child: FlutterSlider(
                                              values: homi.isPressed
                                                  ? [homi.newposition]
                                                  : [homi.currentPosition],
                                              max: homi.totalDuration,
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
                                                homi.setState(() {
                                                  homi.newposition = lowerValue;
                                                });
                                              },
                                              onDragging: (handlerIndex,
                                                  lowerValue, upperValue) {
                                                // Обновляем текущую позицию слайдера, но не меняем масштаб
                                                homi.setState(() {
                                                  homi.newposition =
                                                      lowerValue; // Обновляем текущую позицию слайдера
                                                  homi.setState(() {
                                                    homi.isPressed =
                                                    true; // Устанавливаем флаг нажатия
                                                    homi.scaleY =
                                                    1.4; // Увеличиваем слайдер по оси Y
                                                    homi.translateX =
                                                    12.0; // Сдвигаем слайдер влево
                                                    homi.translateY = 10.0;
                                                  });
                                                });
                                              },
                                              onDragCompleted: (handlerIndex,
                                                  lowerValue, upperValue) {
                                                // Логика завершения перетаскивания
                                                homi.setState(() {
                                                  homi.currentPosition = lowerValue;
                                                });
                                                Duration jda = Duration(
                                                    milliseconds: lowerValue
                                                        .toInt());
                                                print("Position: ${jda
                                                    .inMilliseconds} ms");
                                                homi.setState(() {
                                                  homi.isPressed =
                                                  false; // Сбрасываем флаг нажатия
                                                  homi.scaleY =
                                                  1.0; // Возвращаем слайдер к исходному размеру по оси Y
                                                  homi.translateX =
                                                  26.0; // Возвращаем слайдер в исходное положение
                                                  homi.translateY = 4.0;
                                                });
                                                if (homi.devicecon) {
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
                                                  homi.channeldev.sink.add(jsonString);
                                                } else {
                                                  if (homi.instalumusa) {
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
                                          homi.setState(() {
                                            homi.isPressed =
                                            true; // Устанавливаем флаг нажатия
                                            homi.scaleY =
                                            1.4; // Увеличиваем слайдер по оси Y
                                            homi.translateX =
                                            12.0; // Сдвигаем слайдер влево
                                            homi.translateY = 10.0;
                                          });
                                        },
                                        onTapUp: (_) {
                                          homi.setState(() {
                                            homi.isPressed =
                                            false; // Сбрасываем флаг нажатия
                                            homi.scaleY =
                                            1.0; // Возвращаем слайдер к исходному размеру по оси Y
                                            homi.translateX =
                                            26.0; // Возвращаем слайдер в исходное положение
                                            homi.translateY = 4.0;
                                          });
                                        },
                                        child: AnimatedContainer(
                                          duration: Duration(milliseconds: 200),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: homi.translateX),
                                          curve: Curves.easeInOut,
                                          transform: Matrix4.identity()
                                            ..scale(1.0, homi.scaleY),
                                          // Применяем масштаб
                                          child: FlutterSlider(
                                            values: homi.isPressed
                                                ? [homi.newposition]
                                                : [homi.currentPosition],
                                            max: homi.totalDuration,
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
                                              homi.setState(() {
                                                homi.newposition = lowerValue;
                                              });
                                            },
                                            onDragging: (handlerIndex,
                                                lowerValue, upperValue) {
                                              // Обновляем текущую позицию слайдера, но не меняем масштаб
                                              homi.setState(() {
                                                homi.newposition =
                                                    lowerValue; // Обновляем текущую позицию слайдера
                                                homi.setState(() {
                                                  homi.isPressed =
                                                  true; // Устанавливаем флаг нажатия
                                                  homi.scaleY =
                                                  1.4; // Увеличиваем слайдер по оси Y
                                                  homi.translateX =
                                                  12.0; // Сдвигаем слайдер влево
                                                  homi.translateY = 10.0;
                                                });
                                              });
                                            },
                                            onDragCompleted: (handlerIndex,
                                                lowerValue, upperValue) {
                                              // Логика завершения перетаскивания
                                              homi.setState(() {
                                                homi.currentPosition = lowerValue;
                                              });
                                              Duration jda = Duration(
                                                  milliseconds: lowerValue
                                                      .toInt());
                                              print("Position: ${jda
                                                  .inMilliseconds} ms");
                                              homi.setState(() {
                                                homi.isPressed =
                                                false; // Сбрасываем флаг нажатия
                                                homi.scaleY =
                                                1.0; // Возвращаем слайдер к исходному размеру по оси Y
                                                homi.translateX =
                                                26.0; // Возвращаем слайдер в исходное положение
                                                homi.translateY = 4.0;
                                              });
                                              if (homi.devicecon) {
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
                                                homi.channeldev.sink.add(jsonString);
                                              } else {
                                                 if (homi.instalumusa) {
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
                      AnimatedPadding(
                        padding: EdgeInsets.only(left: 18 + homi.translateX,
                            right: 18 + homi.translateX,
                            top: homi.translateY),
                        duration: Duration(milliseconds: 200),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 200),
                              // Длительность анимации
                              style: TextStyle(
                                fontSize: homi.isPressed ? 16 : 14,
                                // Увеличиваем текст при нажатии
                                color: homi.isPressed ? Colors.white : Colors.grey,
                                // Меняем цвет
                                fontWeight: FontWeight.bold,
                              ),
                              child: Text(
                                homi.formatDuration(Duration(
                                    milliseconds: homi.currentPosition.toInt())),
                              ),
                            ),
                            AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 200),
                              // Длительность анимации
                              style: TextStyle(
                                fontSize: homi.isPressed ? 16 : 14,
                                // Увеличиваем текст при нажатии
                                color: homi.isPressed ? Colors.white : Colors.grey,
                                // Меняем цвет
                                fontWeight: FontWeight.bold,
                              ),
                              child: Text(
                                homi.formatDuration(Duration(
                                    milliseconds: homi.totalDuration.toInt())),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // Кнопки управления
                  AnimatedContainer(
                      duration: Duration(
                          milliseconds: 400),
                      transform: Matrix4.translation(
                          vector.Vector3(
                              0, homi.squareScaleA, 0)),
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
                                    homi.toggleLike(0);
                                  },
                                  icon: Image(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      image: homi.isDisLiked
                                          ? AssetImage(
                                          'assets/images/unloveyes.png')
                                          : AssetImage(
                                          'assets/images/unloveno.png'),
                                      width: 100
                                  ))),
                          SizedBox(width: 50,
                              height: 50,
                              child: IconButton(
                                  disabledColor: homi.canrevew ? Color.fromARGB(
                                      255, 255, 255, 255) : Color.fromARGB(
                                      255, 123, 123, 124),
                                  onPressed: homi.canrevew ? homi.previosmusic : null,
                                  icon: Image(
                                      color: homi.canrevew ? Color.fromARGB(
                                          255, 255, 255, 255) : Color.fromARGB(
                                          255, 123, 123, 124),
                                      image: AssetImage(
                                          'assets/images/reveuws.png'),
                                      width: 100
                                  ))),
                          SizedBox(height: 50,
                              width: 50,
                              child: homi.loadingmus
                                  ? CircularProgressIndicator()
                                  : IconButton(
                                  onPressed: () {
                                    homi.setnewState(() {
                                      homi.playpause();
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
                                    homi.iconpla.icon,
                                     key: homi.videoope ? ValueKey<bool>(homi.controller.player.state.playing) : ValueKey<bool>(AudioService.playbackState.playing),
                                    size: 50,
                                    color: Colors
                                        .white,)))),
                          SizedBox(width: 50,
                              height: 50,
                              child: IconButton(
                                  disabledColor: homi.cannext ? Color.fromARGB(
                                      255, 255, 255, 255) : Color.fromARGB(
                                      255, 123, 123, 124),
                                  onPressed: homi.cannext ? homi.nextmusic : null,
                                  icon: Image(
                                    color: homi.cannext ? Color.fromARGB(
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
                                    homi.toggleLike(1);
                                  }, // () {installmusic(_langData[0]);},
                                  icon: Image(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      image: homi.isLiked
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
                              0, homi.squareScaleA, 0)),
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
                                  onPressed: homi.langData[0]['vidos'] != "0" ? () {
                                    homi.setnewState(() {
                                      homi.setvi(homi.shazid, true, false);
                                    });
                                  } : null,
                                  padding: EdgeInsets
                                      .zero,
                                  icon: Image(
                                    color: homi.langData[0]['vidos'] != "0" ? Color
                                        .fromARGB(255, 255, 255, 255) : Color
                                        .fromARGB(255, 123, 123, 124),
                                    image: AssetImage(homi.videoope
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



  Widget playersmallmusic_old(BuildContext context){
    final homi = homa.currentState!;
    return Column( children: [
      AnimatedOpacity(
          opacity: homi.opacityi3,
          duration: Duration(
              milliseconds: 400),
          child: Container(
              constraints: BoxConstraints(maxWidth: 800, maxHeight: 800), child: AspectRatio(
              aspectRatio: 1,
              // Сохранение пропорций 1:1
              child: AnimatedOpacity(
                  opacity: homi.opacityi1,
                  duration: Duration(
                      milliseconds: 0),
                  child: AnimatedBuilder(
                      animation: homi.animation,
                      builder: (context,
                          child) {
                        return Align(
                            alignment: homi.animation
                                .value,
                            child:
                            AnimatedContainer(
                                constraints: BoxConstraints(maxWidth: 800, maxHeight: 800),
                                margin: EdgeInsets
                                    .only(
                                  left: 30,
                                  right: 30,
                                  top: homi.dsds2,),
                                height: homi.imgwh,
                                width: homi.imgwh,
                                decoration: BoxDecoration(
                                  shape: BoxShape
                                      .rectangle,
                                  borderRadius: BorderRadius
                                      .circular(
                                      homi.dsds),
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
                                      homi.imgmus,
                                      height: homi.imgwh,
                                      width: homi.imgwh,
                                      fit: BoxFit
                                          .cover, // Изображ
                                    ))));
                      }))))),
      AnimatedOpacity(opacity: homi.opacity,
          duration: Duration(
              milliseconds: 400),
          onEnd: () {
            homi.setnewState(() {
              if (homi.videoope) {
                homi.opacityi1 = 0;
                homi.opacityi2 = 1;
              }
            });
          },
          child: AnimatedContainer(
              width: MediaQuery
                  .of(context)
                  .size.width,
              duration: Duration(
                  milliseconds: 400),
              transform: Matrix4
                  .translation(
                  vector.Vector3(
                      0, homi.squareScaleA, 0)),
              child: AutoSizeText(homi.namemus,
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
      AnimatedOpacity(opacity: homi.opacity,
          duration: Duration(
              milliseconds: 400),
          child: AnimatedContainer(
              duration: Duration(
                  milliseconds: 400),
              transform: Matrix4
                  .translation(
                  vector.Vector3(
                      0, homi.squareScaleA, 0)),
              child: AutoSizeText(homi.ispolmus,
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
      AnimatedOpacity(opacity: homi.opacity,
          duration: Duration(
              milliseconds: 400),
          child: AnimatedContainer(
              duration: Duration(
                  milliseconds: 400),
              transform: Matrix4
                  .translation(
                  vector.Vector3(
                      0, homi.squareScaleA, 0)),
              child: Padding(
                  padding: EdgeInsets.only(
                      top: 16,
                      left: 22,
                      right: 22),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment
                        .spaceBetween,
                    children: [
                      AutoSizeText(homi.formatDuration(
                          Duration(
                              milliseconds: homi.currentPosition
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
                      AutoSizeText(homi.formatDuration(
                          Duration(
                              milliseconds: homi.totalDuration
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
      AnimatedOpacity(opacity: homi.opacity,
          duration: Duration(
              milliseconds: 400),
          child: AnimatedContainer(
              duration: Duration(
                  milliseconds: 400),
              transform: Matrix4
                  .translation(
                  vector.Vector3(
                      0, homi.squareScaleA, 0)),
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
                        homi.totalDuration >
                            0) {
                      final position = snapshot
                          .data as Duration;
                      return
                        GestureDetector(
                          onTapDown: (_) {
                            homi.setState(() {
                              homi.isPressed = true; // Устанавливаем флаг нажатия
                              homi.scaleY = 1.4; // Увеличиваем слайдер по оси Y
                              homi.translateX = 12.0; // Сдвигаем слайдер влево
                            });
                          },
                          onTapUp: (_) {
                            homi.setState(() {
                              homi.isPressed = false; // Сбрасываем флаг нажатия
                              homi.scaleY = 1.0; // Возвращаем слайдер к исходному размеру по оси Y
                              homi.translateX = 26.0; // Возвращаем слайдер в исходное положение
                            });
                          },
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 200),
                            padding: EdgeInsets.symmetric(horizontal: homi.translateX),
                            curve: Curves.easeInOut,
                            transform: Matrix4.identity()
                              ..scale(1.0, homi.scaleY), // Применяем масштаб
                            child: FlutterSlider(
                              values: homi.isPressed ? [homi.newposition] : [homi.currentPosition],
                              max: homi.totalDuration,
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
                                homi.setState(() {
                                  homi.newposition = lowerValue;
                                });
                              },
                              onDragging: (handlerIndex, lowerValue, upperValue) {
                                // Обновляем текущую позицию слайдера, но не меняем масштаб
                                homi.setState(() {
                                  homi.newposition = lowerValue; // Обновляем текущую позицию слайдера
                                  homi.setState(() {
                                    homi.isPressed = true; // Устанавливаем флаг нажатия
                                    homi.scaleY = 1.4; // Увеличиваем слайдер по оси Y
                                    homi.translateX = 12.0; // Сдвигаем слайдер влево
                                  });
                                });
                              },
                              onDragCompleted: (handlerIndex, lowerValue, upperValue) {
                                // Логика завершения перетаскивания
                                homi.setState(() {
                                  homi.currentPosition = lowerValue;
                                });
                                Duration jda = Duration(milliseconds: lowerValue.toInt());
                                print("Position: ${jda.inMilliseconds} ms");
                                homi.setState(() {
                                  homi.isPressed = false; // Сбрасываем флаг нажатия
                                  homi.scaleY = 1.0; // Возвращаем слайдер к исходному размеру по оси Y
                                  homi.translateX = 26.0; // Возвращаем слайдер в исходное положение
                                });
                                if (homi.devicecon) {
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
                                  homi.channeldev.sink.add(jsonString);
                                } else {
                                  if (homi.instalumusa) {
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
                          homi.setState(() {
                            homi.isPressed = true; // Устанавливаем флаг нажатия
                            homi.scaleY = 1.4; // Увеличиваем слайдер по оси Y
                            homi.translateX = 12.0; // Сдвигаем слайдер влево
                          });
                        },
                        onTapUp: (_) {
                          homi.setState(() {
                            homi.isPressed = false; // Сбрасываем флаг нажатия
                            homi.scaleY = 1.0; // Возвращаем слайдер к исходному размеру по оси Y
                            homi.translateX = 26.0; // Возвращаем слайдер в исходное положение
                          });
                        },
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 200),
                          padding: EdgeInsets.symmetric(horizontal: homi.translateX),
                          curve: Curves.easeInOut,
                          transform: Matrix4.identity()
                            ..scale(1.0, homi.scaleY), // Применяем масштаб
                          child: FlutterSlider(
                            values: homi.isPressed ? [homi.newposition] : [homi.currentPosition],
                            max: homi.totalDuration,
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
                              homi.setState(() {
                                homi.newposition = lowerValue;
                              });
                            },
                            onDragging: (handlerIndex, lowerValue, upperValue) {
                              // Обновляем текущую позицию слайдера, но не меняем масштаб
                              homi.setState(() {
                                homi.newposition = lowerValue; // Обновляем текущую позицию слайдера
                                homi.setState(() {
                                  homi.isPressed = true; // Устанавливаем флаг нажатия
                                  homi.scaleY = 1.4; // Увеличиваем слайдер по оси Y
                                  homi.translateX = 12.0; // Сдвигаем слайдер влево
                                });
                              });
                            },
                            onDragCompleted: (handlerIndex, lowerValue, upperValue) {
                              // Логика завершения перетаскивания
                              homi.setState(() {
                                homi.currentPosition = lowerValue;
                              });
                              Duration jda = Duration(milliseconds: lowerValue.toInt());
                              print("Position: ${jda.inMilliseconds} ms");
                              homi.setState(() {
                                homi.isPressed = false; // Сбрасываем флаг нажатия
                                homi.scaleY = 1.0; // Возвращаем слайдер к исходному размеру по оси Y
                                homi.translateX = 26.0; // Возвращаем слайдер в исходное положение
                              });
                              if (homi.devicecon) {
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
                                homi.channeldev.sink.add(jsonString);
                              } else {
                                if (homi.instalumusa) {
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
                  0, homi.squareScaleA, 0)),
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
                      onPressed: () {homi.toggleLike(0);},
                      icon: Image(
                          color: Color.fromARGB(255, 255, 255, 255),
                          image: homi.isDisLiked ? AssetImage(
                              'assets/images/unloveyes.png') : AssetImage(
                              'assets/images/unloveno.png'),
                          width: 100
                      ))),
              SizedBox(width: 50,
                  height: 50,
                  child: IconButton(
                      disabledColor: homi.canrevew ? Color.fromARGB(255, 255, 255, 255) : Color.fromARGB(255, 123, 123, 124),
                      onPressed: homi.canrevew ? homi.previosmusic : null,
                      icon: Image(
                          color: homi.canrevew ? Color.fromARGB(255, 255, 255, 255) : Color.fromARGB(255, 123, 123, 124),
                          image: AssetImage(
                              'assets/images/reveuws.png'),
                          width: 100
                      ))),
              SizedBox(height: 50,
                  width: 50,
                  child: homi.loadingmus ? CircularProgressIndicator() : IconButton(
                      onPressed: () {
                        homi.setnewState(() {
                          homi.playpause();
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
                        homi.iconpla.icon,
                        key: homi.videoope ? ValueKey<bool>(homi.controller.player.state.playing) : ValueKey<bool>(AudioService.playbackState.playing),
                        size: 50,
                        color: Colors
                            .white,)))),
              SizedBox(width: 50,
                  height: 50,
                  child: IconButton(
                      disabledColor: homi.cannext ? Color.fromARGB(255, 255, 255, 255) : Color.fromARGB(255, 123, 123, 124),
                      onPressed: homi.cannext ? homi.nextmusic : null,
                      icon: Image(
                        color: homi.cannext ? Color.fromARGB(255, 255, 255, 255) : Color.fromARGB(255, 123, 123, 124),
                        image: AssetImage(
                            'assets/images/nexts.png'),
                        width: 120,
                        height: 120,
                      ))),
              SizedBox(width: 50,
                  height: 50,
                  child: IconButton(
                      onPressed: () {homi.toggleLike(1);}, // () {installmusic(langData[0]);},
                      icon: Image(
                          color: Color.fromARGB(255, 255, 255, 255),
                          image: homi.isLiked ? AssetImage(
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
                  0, homi.squareScaleA, 0)),
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
                        homi.connectToWebSocket();
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
                      onPressed: () {showTrackOptionsBottomSheet(context, homi.langData[0]);},
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
                      onPressed: homi.langData[0]['vidos'] != "0" ? () {
                        homi.setnewState(() {
                          homi.setvi(homi.shazid,true, false);
                        });
                      }: null,
                      padding: EdgeInsets
                          .zero,
                      icon: Image(
                        color: homi.langData[0]['vidos'] != "0" ? Color.fromARGB( 255, 255, 255, 255) : Color.fromARGB(255, 123, 123, 124),
                        image: AssetImage(homi.videoope ? 'assets/images/musicon.png' : 'assets/images/video.png'),
                        width: 120,
                        height: 120,
                      ))),
            ],))
    ],);
  }


}