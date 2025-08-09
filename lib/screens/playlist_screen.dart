import 'dart:async';
import 'dart:convert';
import 'dart:io';


import 'package:blast/screens/mus_in_playlist.dart';
import 'package:blast/screens/profile_screen.dart';
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

import '../api/api_service.dart';
import '../parts/buttons.dart';
import '../parts/headers.dart';
import '../parts/music_cell.dart';
import '../providers/list_manager_provider.dart';
import 'login.dart';



const kBgColor = Color(0xFF1604E2);

class PlaylistScreen extends StatefulWidget {
  final  Function(dynamic) onCallback;
  final  Function(dynamic, dynamic, String) onCallbackt;
  final VoidCallback hie;
  final VoidCallback showlog;
  final VoidCallback resdf;
  final BuildContext prtctx;
  const PlaylistScreen({Key? key, required this.onCallback, required this.hie, required this.showlog, required this.resdf, required this.onCallbackt, required this.prtctx}) : super(key: key);
  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState((dynamic input) {onCallback(input);}, hie,showlog,resdf,(dynamic input,dynamic inputi, String asdsa) {onCallbackt(input, inputi, asdsa);});




}

class _PlaylistScreenState extends State<PlaylistScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late VoidCallback showsearch;
  late Function(dynamic) onCallback;
  late Function(dynamic, dynamic, String) onCallbackrfdg;
  late VoidCallback showlog;
  late VoidCallback reseti;
  _PlaylistScreenState(Function(dynamic) onk, VoidCallback fg, VoidCallback dawsd, VoidCallback gbdfgb, Function(dynamic,dynamic inputi, String) onksd) {
    onCallback = onk;
    showsearch = fg;
    showlog = dawsd;
    reseti = gbdfgb;
    onCallbackrfdg = onksd;
  }




  final ApiService apiService = ApiService();



  @override
  void initState()
  {
    load();
    _controller.addListener(_scrollListener);
    _childController.addListener(() {
      if (_isChildScrolling &&
          _childController.offset <= _childController.position.minScrollExtent) {
        // Возврат управления родительскому списку
        setState(() {
          _isChildScrolling = false;
          if(_childController.offset <= 0){
            _isAtTop = _childController.offset <= 0 || _controller.offset <= 0;
          }
        });
      }
    });
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
            child: standatbuildcustomlistview(size.width > 800 ? _loadGridView() :  _onlylist(),_opacity, imgprofile, showlog, context, useri, widget.hie, widget.resdf, 'Плейлисты', _controller, _childController, _isAtTop, setState, _previousOffset, true, context, load, null, false)

        ),

      ),
    );
  }

  String imgprofile = "";
  bool useri = false;



  @override
  void dispose() {
    super.dispose();
  }

  void _openSearchPage(BuildContext context, String fds, String name, String img, bool imgnd) {

    // Navigator.of(context).push(_createSearchRoute(fds, name, img, imgnd));

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MusInPlaylistScreen(
          onCallback: (dynamic input) => onCallback(input),
          onCallbacki: fds,
          hie: showsearch,
          name: name,
          img: img,
          imgnd: imgnd,
          showlog: showlog,
          resre: reseti,
          onCallbackt: (dynamic input, dynamic inputi, String fds) =>
              onCallbackrfdg(input, inputi, fds),
        ),
      ),
    );

  }



  void load() async {
    setState(() {
      isRefreshing = true;
      showRefreshButton = true;
    });
    var usera = await apiService.getUser();
    setState(() {
      if(usera['status'] != 'false') {
        useri = true;
        imgprofile = usera["img_kompot"];
      }else{
        useri = false;
      }
    });
    var langData1 = await apiService.getPlayLists(0);
    setState(() {
      showRefreshButton = false;
      context.read<ListManagerProvider>().createList('playlist', langData1);
    });
    await Future.delayed(Duration(milliseconds: 301));
    setState(() {
      isRefreshing = false;
    });
  }
  double _previousOffset = 0.0;
  final ScrollController _controller = ScrollController();
  double _opacity = 0.0;
  late ScrollController _childController  = ScrollController();
  bool _isChildScrolling = false;
  bool _isAtTop = true;
  void _scrollListener() {
    setState(() {
      // Меняем прозрачность в зависимости от прокрутки
      _opacity = _controller.offset > 100 ? 1.0 : 0.0;
      print(_controller.offset);
      if(_controller.offset <= 0){
        _controller.jumpTo(0);
      }
      _isAtTop = _controller.offset == 0;
    });
  }

  bool showRefreshButton = false;
  bool isRefreshing = false;
  Widget _onlylist() {
    Size size = MediaQuery.of(context).size;
    return Consumer<ListManagerProvider>(
        builder: (context, listManager, child) {
          final list = listManager.getList(
              'playlist'); // Получить список из провайдера

          if (list.isEmpty) {
            return Center(child: Text('Нету плейлистов'));
          }

          return ListView.builder(
            shrinkWrap: true,
            controller: _childController,
            itemCount: list.length,
            itemBuilder: (BuildContext context, int idx) {
              return PlaylistCell(list[idx], () {
                _openSearchPage(context, list[idx]['id'],list[idx]['name'], list[idx]['img'], true);
              }, widget.prtctx
              );
            },
          );
        });
  }

  Widget _loadGridView() {
    return Consumer<ListManagerProvider>(
      builder: (context, listManager, child) {
        final list = listManager.getList('playlist');
        final size = MediaQuery.of(context).size;

        if (list.isEmpty) {
          return const SliverToBoxAdapter(
            child: Center(child: Text('Нет плейлистов')),
          );
        }

        final crossAxisCount = size.width > 1200 ? 4 : size.width > 800 ? 3 : 2;
        final itemWidth = size.width / crossAxisCount;

        return SliverGrid(
          delegate: SliverChildBuilderDelegate(
                (context, index) {
              final item = list[index];
              return CustomTile(
                title: item['name'],
                imageUrl: item['img'],
                availableWidth: itemWidth,
                useFallbackImage: false,
                onTap: () => _openSearchPage(context, item['id'], item['name'], item['img'], true),
              );
            },
            childCount: list.length,
          ),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisExtent: itemWidth * 1.2, // Место для обложки + текста с иконкой
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
        );
      },
    );
  }


  Widget hl(BuildContext co){
    return Container();
  }

}


class CustomTile extends StatelessWidget {
  final String title;
  final String imageUrl;
  final double availableWidth;
  final bool useFallbackImage;
  final VoidCallback onTap;

  CustomTile({
    required this.title,
    required this.imageUrl,
    required this.availableWidth,
    required this.useFallbackImage,
    required this.onTap,
  });

  ImageProvider _getSafeImageProvider(String url) {
    try {
      if (url.isNotEmpty && url != 'https://kompot.keep-pixel.ru/') {
        return NetworkImage(url);
      }
    } catch (e) {
      return const AssetImage('assets/images/playlist.png');
    }
    return const AssetImage('assets/images/playlist.png');
  }

  @override
  Widget build(BuildContext context) {
    final imageSize = availableWidth * 0.9; // Крупная обложка (90% ширины)
    final tileWidth = availableWidth;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: tileWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Обложка плейлиста
            Container(
              width: imageSize,
              height: imageSize,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: useFallbackImage
                      ? const AssetImage('assets/images/playlist.png')
                      : _getSafeImageProvider(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Нижняя строка (название + иконка)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: SizedBox(
                width: imageSize,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Название плейлиста
                    Expanded(
                      child: Padding(padding: EdgeInsets.only(right: 8, left: 8), child:  Text(
                        title,
                        
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      )),
                    ),

                    // Иконка меню (теперь снизу, рядом с текстом)
                    IconButton(
                      icon: const Icon(Icons.more_vert, size: 24),
                      color: Colors.white,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        // Действие меню
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}