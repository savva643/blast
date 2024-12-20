import 'dart:convert';

import 'package:audio_service/audio_service.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:blast/screens/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:just_audio/just_audio.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'package:marquee/marquee.dart';

import 'bottomsheet_about_music.dart';
import 'bottomsheet_queue.dart';

String formatDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  final minutes = twoDigits(duration.inMinutes.remainder(60));
  final seconds = twoDigits(duration.inSeconds.remainder(60));
  return '$minutes:$seconds';
}

bool shouldScroll(String text, TextStyle style, double maxWidth) {
  final TextPainter textPainter = TextPainter(
    text: TextSpan(text: text, style: style),
    maxLines: 1,
    textDirection: TextDirection.ltr,
  )..layout();

  return textPainter.width > maxWidth;
}
double getTextWidth(String text, TextStyle style) {
  final TextPainter textPainter = TextPainter(
    text: TextSpan(text: text, style: style),
    maxLines: 1,
    textDirection: TextDirection.ltr,
  )..layout();

  return textPainter.width; // Возвращает точную ширину текста
}


// Метод для отображения текста или Marquee
Widget buildTextOrMarquee(String text, TextStyle style, double maxWidth) {
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
    showFadingOnlyWhenScrolling: false,
    fadingEdgeEndFraction: 0.2,
    fadingEdgeStartFraction: 0.2,
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

class PlayerWidget {
  final Function connectToWebSocket;
  final List langData;
  final double opacityi3;
  final double opacityi1;

  final Animation<Alignment> animation;
  final double imgwh;
  final String imgmus;
  final double opacity;
  final bool videoope;
  final double opacityi2;
  final double squareScaleA;
  final double scaleY;
  final double translateX;
  final double translateY;
  final String shazid;
  final Function opka;
  final String namemus;
  final String imgispol;
  final String ispolmus;
  final double totalDuration;
  final Function tapdown1;
  final Function tapup1;
  final bool isPressed;
  final double newposition;
  final double currentPosition;
  final Function dragStarted1;
  final Function dragCompleted1;
  final Function toggleLike;
  final bool isDisLiked;
  final bool canrevew;
  final VoidCallback previosmusic;
  final bool loadingmus;
  final Function playpause;
  final dynamic iconpla;
  final VoidCallback nextmusic;
  final bool cannext;
  final Function setvi;
  final VideoController controller;
  final bool isLiked;
  final double squareScaleB;
  final double videoopacity;
  final GestureTapCallback toggleMute;
  final BorderRadius borderRadius;
  final Function tap2;
  final Function queuewidget;

  final bool isShuffleEnabled;
  final LoopMode repeatMode;

  final VideoController controllershort;

  // Constructor for PlayerWidget to accept data
  PlayerWidget({
    required this.tap2,
    required this.connectToWebSocket,
    required this.langData,
    required this.opacityi3,
    required this.opacityi1,
    required this.animation,
    required this.imgwh,
    required this.imgmus,
    required this.opacity,
    required this.videoope,
    required this.opacityi2,
    required this.squareScaleA,
    required this.scaleY,
    required this.translateX,
    required this.translateY,
    required this.shazid,
    required this.opka,
    required this.namemus,
    required this.imgispol,
    required this.ispolmus,
    required this.totalDuration,
    required this.tapdown1,
    required this.tapup1,
    required this.isPressed,
    required this.newposition,
    required this.currentPosition,
    required this.dragStarted1,
    required this.dragCompleted1,
    required this.toggleLike,
    required this.isDisLiked,
    required this.canrevew,
    required this.previosmusic,
    required this.loadingmus,
    required this.playpause,
    required this.iconpla,
    required this.nextmusic,
    required this.cannext,
    required this.setvi,
    required this.controller,
    required this.isLiked,
    required this.squareScaleB,
    required this.videoopacity,
    required this.toggleMute,
    required this.borderRadius,
    required this.queuewidget,
    required this.isShuffleEnabled,
    required this.repeatMode,
    required this.controllershort
  });




  Widget playersmallvideo(BuildContext context) {
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
    return Container(padding: EdgeInsets.only(bottom: 18), child: Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [


      Column(children: [AnimatedOpacity(opacity: videoopacity,
                    duration: Duration(
                        milliseconds: 400),
                    onEnd: (){//tap2();
         },
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
                                    onTap: toggleMute, // Обработчик клика на видео
                                    child: Video(
                                      controller: controller,
                                    )),
                              ),
                            ),)))),
                Row(children: [
                  AnimatedOpacity(opacity: videoopacity,
                      duration: Duration(milliseconds: 400),
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
                              milliseconds: 400),
                          child: RoundedImage(imageUrl: imgmus, size: 80))),
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
                          crossAxisAlignment: CrossAxisAlignment
                              .start,
                          children: [
                            Container(
                            height: 50,
                            alignment: Alignment.centerLeft,
                            width: MediaQuery
                                .of(context)
                                .size
                                .width - 32,
                            child: buildTextOrMarquee(
                                namemus, nameStyle, MediaQuery
                                .of(context)
                                .size
                                .width - 32),
                          ),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                    alignment: Alignment.centerLeft,
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
                            )
                          ],),))

                ],),],),

      // Кнопки управления
      AnimatedOpacity(opacity: videoopacity,
          duration: Duration(
              milliseconds: 400),
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
                        playpause();
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
      AnimatedOpacity(opacity: videoopacity,
          duration: Duration(
              milliseconds: 400),
          child: Row(
            mainAxisAlignment: MainAxisAlignment
                .spaceAround,
            crossAxisAlignment: CrossAxisAlignment
                .center,
            children: [
              SizedBox(width: 40,
                  height: 40,
                  child: IconButton(
                      disabledColor: Color.fromARGB(
                          255, 123, 123, 124),
                      onPressed: () => AudioService.customAction('toggleShuffle', {}),
                      padding: EdgeInsets
                          .zero,
                      icon: Icon(
                        isShuffleEnabled ? CupertinoIcons.shuffle : CupertinoIcons.shuffle_thick,
                        size: 32,
                        color: isShuffleEnabled ? Colors.white: Colors.grey,))),
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
                        setvi();
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
                      onPressed: () => AudioService.customAction('toggleRepeatMode', {}),
                      padding: EdgeInsets
                          .zero,
                      icon: Icon(
                        repeatMode == LoopMode.one
                            ? CupertinoIcons.repeat_1
                            : repeatMode == LoopMode.all
                            ? CupertinoIcons.repeat
                            : CupertinoIcons.repeat,
                        size: 32,
                        color: repeatMode != LoopMode.off ? Colors.white: Colors.grey,))),
            ],))
              ]));
  }


    Widget playersmallmusic(BuildContext context) {
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
        child: Container(padding: EdgeInsets.only(top: 10, bottom: 18),
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
                          Container(padding: EdgeInsets.only(left: 4),child:
                        SizedBox(width: 40,
                            height: 40,
                            child: IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                padding: EdgeInsets
                                    .zero,
                                icon: Icon(
                                  Icons
                                      .keyboard_arrow_down_rounded,
                                  size: 40,
                                  color: Colors
                                      .white,))),),

                          Expanded(child: Container()),
              Container(padding: EdgeInsets.only(top: 5),child:
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
                                      .white,))),),
                        SizedBox(width: 20,),
              Container(padding: EdgeInsets.only(top: 5),child:
                        SizedBox(width: 30,
                            height: 30,
                            child: IconButton(
                                disabledColor: Color.fromARGB(
                                    255, 123, 123, 124),
                                onPressed: (){queuewidget();},
                                padding: EdgeInsets
                                    .zero,
                                icon: Icon(
                                  Icons
                                      .queue_music_rounded,
                                  size: 30,
                                  color: Color.fromARGB(255, 255, 255, 255),))),),
                        SizedBox(width: 10,),
              Container(padding: EdgeInsets.only(top: 5, right: 6),child:
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
                                  color: Color.fromARGB(255, 255, 255, 255),))),),
                      ],)),
                  // Обложка, круглая картинка исполнителя и информация о песне
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                    AnimatedOpacity(
                    opacity: controllershort.player.state.playing ? opacityi3 : 1,
                    duration: Duration(
              milliseconds: 400),
              child:
                      AnimatedOpacity(
                          opacity: opacityi1,
                          duration: Duration(
                              milliseconds: 400),
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
                            print("hjjhgjg");
                            //opka();
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
                                            tapdown1();
                                          },
                                          onTapUp: (_) {
                                            tapup1();
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
                                                dragStarted1(lowerValue);
                                              },
                                              onDragging: (handlerIndex,
                                                  lowerValue, upperValue) {
                                                dragStarted1(lowerValue);
                                                tapdown1();
                                              },
                                              onDragCompleted: (handlerIndex,
                                                  lowerValue, upperValue) {
                                                // Логика завершения перетаскивания
                                                dragCompleted1(lowerValue);
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
                                          tapdown1();
                                        },
                                        onTapUp: (_) {
                                          tapup1();
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
                                              dragStarted1(lowerValue);
                                            },
                                            onDragging: (handlerIndex,
                                                lowerValue, upperValue) {
                                              // Обновляем текущую позицию слайдера, но не меняем масштаб
                                              dragStarted1(lowerValue);
                                              tapdown1();
                                            },
                                            onDragCompleted: (handlerIndex,
                                                lowerValue, upperValue) {
                                              // Логика завершения перетаскивания
                                              dragCompleted1(lowerValue);
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
                  AnimatedOpacity(opacity: opacity, duration: Duration(
                      milliseconds: 400), child:
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
                                    playpause();
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
                        ],))),

                  // Дополнительные кнопки
              AnimatedOpacity(opacity: opacity, duration: Duration(
              milliseconds: 400), child:
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
                                  disabledColor: Color.fromARGB(
                                      255, 123, 123, 124),
                                  onPressed: () => AudioService.customAction('toggleShuffle', {}),
                                  padding: EdgeInsets
                                      .zero,
                                  icon: Icon(
                                    isShuffleEnabled ? CupertinoIcons.shuffle : CupertinoIcons.shuffle_thick,
                                    size: 32,
                                    color: isShuffleEnabled ? Colors.white: Colors.grey,))),
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
                                    setvi();
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
                                  onPressed: () => AudioService.customAction('toggleRepeatMode', {}),
                                  padding: EdgeInsets
                                      .zero,
                                  icon: Icon(
                                    repeatMode == LoopMode.one
                                        ? CupertinoIcons.repeat_1
                                        : repeatMode == LoopMode.all
                                        ? CupertinoIcons.repeat
                                        : CupertinoIcons.repeat,
                                    size: 32,
                                    color: repeatMode != LoopMode.off ? Colors.white: Colors.grey,))),
                        ],)))
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
                      milliseconds: 400),
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

  Widget playerbigvideo(BuildContext context) {
    return Container();
  }

  Widget playerbigmusic(BuildContext context) {
    return Container();
  }
}