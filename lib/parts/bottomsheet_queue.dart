import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:provider/provider.dart';

import '../providers/queue_manager_provider.dart';
import 'music_cell.dart';



class QueueWidget {
  final Function playpause;
  final bool loadingmus;
  final dynamic iconpla;
  final bool videoope;
  final VideoController controller;

  late StateSetter setnewStatesxa;

  QueueWidget(this.playpause, this.loadingmus, this.iconpla, this.videoope, this.controller);

  void showQueueBottomSheet(BuildContext context, Function sert) {
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
                    return  Consumer<QueueManagerProvider>(
                  builder: (context, queueManager, child) {
                    return Column(
                            children: [
                              // Header for Bottom Sheet
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Text(
                                          'Очередь:',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        if (queueManager.currentAlbum != null)
                                          Text(
                                            queueManager.currentAlbum!,
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.normal,
                                              color: Colors.white,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                      ],
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(top: 8), child:
                                    IconButton(
                                      icon: const Icon(
                                          Icons.close, color: Colors.white),
                                      onPressed: () => Navigator.pop(context),
                                    )),
                                  ],
                                ),
                              ),


                              // "Сейчас играет" секция
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                child: Row(
                                  children: [
                                    // Обложка трека
                                    CachedNetworkImage(
                                      imageUrl: queueManager
                                          .currentTrack?['img'] ??
                                          "https://kompot.keep-pixel.ru/img/music.jpg",
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                            width: 60,
                                            height: 60,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.rectangle,
                                              borderRadius: BorderRadius
                                                  .circular(8),
                                              image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.cover),
                                            ),
                                          ),
                                      placeholder: (context, url) =>
                                      const CircularProgressIndicator(
                                          color: Colors.white),
                                      errorWidget: (context, url, error) =>
                                      const Icon(
                                          Icons.error, color: Colors.red),
                                    ),
                                    const SizedBox(width: 16),

                                    // Текущая композиция
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: [
                                          Text(
                                            queueManager
                                                .currentTrack?['name'] ??
                                                "Название",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            queueManager
                                                .currentTrack?['message'] ??
                                                "Имполнитель",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    SizedBox(height: 50,
                                        width: 50,
                                        child: loadingmus
                                            ? CircularProgressIndicator()
                                            : IconButton(
                                            onPressed: () {
                                              setState(() {
                                                playpause();
                                              });
                                            },
                                            padding: EdgeInsets
                                                .zero,
                                            icon: AnimatedSwitcher(
                                                duration: Duration(
                                                    milliseconds: 300),
                                                transitionBuilder: (
                                                    Widget child,
                                                    Animation<
                                                        double> animation) {
                                                  return RotationTransition(
                                                    turns: Tween(
                                                        begin: 0.75, end: 1.0)
                                                        .animate(animation),
                                                    child: ScaleTransition(
                                                        scale: animation,
                                                        child: child),
                                                  );
                                                }, child: Icon(
                                              iconpla.icon,
                                              key: videoope ? ValueKey<bool>(
                                                  controller.player.state
                                                      .playing) : ValueKey<
                                                  bool>(
                                                  AudioService.playbackState
                                                      .playing),
                                              size: 50,
                                              color: Colors
                                                  .white,)))),
                                  ],
                                ),
                              ),
                              const Divider(color: Colors.grey, thickness: 0.5),

                              // Секция очереди
                              Expanded(
                                child: ListView.builder(
                                  controller: scrollController,
                                  itemCount: queueManager.queue.length,
                                  itemBuilder: (context, index) {
                                    final track = queueManager.queue[index];
                                    return MussicCell(
                                      track,
                                          () async {
                                        await AudioService.customAction(
                                            'setindex', {'index': index});
                                      },
                                      context,
                                    );
                                  },
                                ),
                              ),
                            ],
                          );
                        });
                  },
                ),
          ),
    );
  }

  Widget queueWidget(BuildContext context, ScrollController scrollController, StateSetter sdafassd , Function sert){
    bool _isFirstBuild = true; // Флаг для выполнения прокрутки только при открытии
    return Consumer<QueueManagerProvider>(
        builder: (context, queueManager, child) {
          if (_isFirstBuild && queueManager.currentTrack != null) {
            _isFirstBuild = false; // Сбрасываем флаг после выполнения
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              int  dcs = await queueManager.getItemByIndex(queueManager.currentTrack!);
              print("ghghfgh"+dcs.toString());
              scrollController.animateTo(
                82.0 * dcs.toDouble(), // Прокрутка к нужной позиции
                duration: Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            });
          }
          return Column(
            children: [
              // Header for Bottom Sheet
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment
                      .spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Очередь:',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (queueManager.currentAlbum != null)
                          Text(
                            queueManager.currentAlbum!,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.normal,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 8), child:
                    IconButton(
                      icon: const Icon(
                          Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    )),
                  ],
                ),
              ),


              // "Сейчас играет" секция
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 8.0),
                child: Row(
                  children: [
                    // Обложка трека
                    CachedNetworkImage(
                      imageUrl: queueManager
                          .currentTrack?['img'] ??
                          "https://kompot.keep-pixel.ru/img/music.jpg",
                      imageBuilder: (context, imageProvider) =>
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius
                                  .circular(8),
                              image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover),
                            ),
                          ),
                      placeholder: (context, url) =>
                      const CircularProgressIndicator(
                          color: Colors.white),
                      errorWidget: (context, url, error) =>
                      const Icon(
                          Icons.error, color: Colors.red),
                    ),
                    const SizedBox(width: 16),

                    // Текущая композиция
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment
                            .start,
                        children: [
                          Text(
                            queueManager
                                .currentTrack?['name'] ??
                                "Название",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            queueManager
                                .currentTrack?['message'] ??
                                "Имполнитель",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    SizedBox(height: 50,
                        width: 50,
                        child: loadingmus
                            ? CircularProgressIndicator()
                            : IconButton(
                            onPressed: () {
                              print("sczc"+ iconpla.toString());
                              sdafassd(() {playpause();});
                              print("sczc"+ iconpla.toString());
                            },
                            padding: EdgeInsets
                                .zero,
                            icon: AnimatedSwitcher(
                                duration: Duration(
                                    milliseconds: 300),
                                transitionBuilder: (
                                    Widget child,
                                    Animation<
                                        double> animation) {
                                  return RotationTransition(
                                    turns: Tween(
                                        begin: 0.75, end: 1.0)
                                        .animate(animation),
                                    child: ScaleTransition(
                                        scale: animation,
                                        child: child),
                                  );
                                }, child: Icon(
                              iconpla.icon,
                              key: videoope ? ValueKey<bool>(
                                  controller.player.state
                                      .playing) : ValueKey<
                                  bool>(
                                  AudioService.playbackState
                                      .playing),
                              size: 50,
                              color: Colors
                                  .white,)))),
                  ],
                ),
              ),
              const Divider(color: Colors.grey, thickness: 0.5),

              // Секция очереди
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: queueManager.queue.length,
                  itemBuilder: (context, index) {
                    final track = queueManager.queue[index];
                    return MussicCell(
                      track,
                          ()  { sert(index, track["idshaz"], false); },
                      context,
                    );
                  },
                ),
              ),
            ],
          );
        });
  }
}