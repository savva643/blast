import 'dart:ui';

import 'package:blast/screens/playlist_screen.dart';
import 'package:blast/screens/profile_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/api_service.dart';
import '../parts/buttons.dart';
import '../parts/headers.dart';
import '../parts/music_cell.dart';
import '../providers/list_manager_provider.dart';
import 'history_screen.dart';
import 'mus_in_playlist.dart';
import 'need_login.dart';

const kBgColor = Color.fromARGB(255, 15, 15, 16);

class LibraryScreen extends StatefulWidget {

  final BuildContext parctx;
  final Function(dynamic) onCallback;
  final Function(dynamic, dynamic, String) onCallbackt;
  final VoidCallback hie;
  final VoidCallback showlog;
  final VoidCallback resdf;
  final VoidCallback hie2;
  const LibraryScreen({Key? key, required this.onCallback, required this.hie, required this.showlog, required this.resdf, required this.onCallbackt, required this.parctx, required this.hie2, }) : super(key: key);
  @override
  State<LibraryScreen> createState() => LibraryScreenState();




}

class LibraryScreenState extends State<LibraryScreen>{

  final ScrollController _controller = ScrollController();
  double _opacity = 0.0;
  late ScrollController _childController  = ScrollController();
  bool _isChildScrolling = false;
  @override
  void initState() {
    super.initState();
    _checkAuthAndLoad();
    _controller.addListener(_scrollListener);

    // Слушаем прокрутку дочернего списка
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
  }
  bool _isLoggedIn = false;
  Future<void> _checkAuthAndLoad() async {
    final prefs = await SharedPreferences.getInstance();
    final hasToken = prefs.getString('token') != null;

    if (!mounted) return;

    setState(() {
      _isLoggedIn = hasToken;
    });

    if (hasToken) {
      load(); // Загружаем данные только если пользователь авторизован
    } else {
      // Перенаправляем на экран входа
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => NeedLoginScreen(type: LoginType.library, showBackButton: false, showlog: widget.showlog,),
          ),
        );
      });
    }
  }


  @override
  void dispose() {
    _controller.removeListener(_scrollListener);
    _controller.dispose();
    _childController.dispose();
    super.dispose();
  }

  bool isDragging = false;
  bool showRefreshButton = false;
  bool isRefreshing = false;


  String imgprofile = "";
  bool useri = false;

  final ApiService apiService = ApiService();
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
    var langData = await apiService.getMusicInPlaylist("0", 9);
    var langData1 = await apiService.getPlayLists(4);
    var langData2 = await apiService.getAlbum(4);
    setState(() {
      showRefreshButton = false;
      context.read<ListManagerProvider>().createList('lovelast9', langData);
      context.read<ListManagerProvider>().createList('playlistlast4', langData1);
      context.read<ListManagerProvider>().createList('albumlast4', langData2);
    });
    await Future.delayed(Duration(milliseconds: 301));
    setState(() {
      isRefreshing = false;
      isDragging = false;
    });
  }
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

  void sendpalulit(var fdsvds, dynamic list){
    print(list.toString() + fdsvds.toString()+ "loveghfghnf");
    widget.onCallbackt(list,fdsvds, 'Любимые песни');
  }

  void _openSearchPage(BuildContext context, String fds, String name, String img, bool imgnd, bool history, bool love, bool install) {

    // Navigator.of(context).push(_createSearchRoute(fds, name, img, imgnd));

    if(install) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) =>
              MusInPlaylistScreen(
                onCallback: (dynamic input) => widget.onCallback(input),
                onCallbacki: fds,
                hie: widget.hie,
                name: name,
                img: img,
                imgnd: imgnd,
                showlog: widget.showlog,
                resre: widget.resdf,
                onCallbackt: (dynamic input, dynamic inputi, String fds) =>
                    widget.onCallbackt(input, inputi, fds),
              ),
        ),
      );
    }else if(history) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) =>
              HistoryScreen(
                onCallback: (dynamic input) => widget.onCallback(input),
                hie: widget.hie,
                showlog: widget.showlog,
                resdf: widget.resdf,
                onCallbackt: (dynamic input, dynamic inputi, String fds) =>
                    widget.onCallbackt(input, inputi, fds), parctx: widget.parctx,
              ),
        ),
      );
    }else if(love) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) =>
              MusInPlaylistScreen(
                onCallback: (dynamic input) => widget.onCallback(input),
                onCallbacki: fds,
                hie: widget.hie,
                name: name,
                img: img,
                imgnd: imgnd,
                showlog: widget.showlog,
                resre: widget.resdf,
                onCallbackt: (dynamic input, dynamic inputi, String fds) =>
                    widget.onCallbackt(input, inputi, fds),
              ),
        ),
      );
    }else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) =>
              MusInPlaylistScreen(
                onCallback: (dynamic input) => widget.onCallback(input),
                onCallbacki: fds,
                hie: widget.hie,
                name: name,
                img: img,
                imgnd: imgnd,
                showlog: widget.showlog,
                resre: widget.resdf,
                onCallbackt: (dynamic input, dynamic inputi, String fds) =>
                    widget.onCallbackt(input, inputi, fds),
              ),
        ),
      );
    }

  }


  Widget build(BuildContext context) {
    return standatbuild([LibrarySection(
      title: 'Любимые песни',
      child: LikedSongsGrid(parctxj: widget.parctx, sendpalulit: (int fdsvds, list) { sendpalulit(fdsvds, list); },),
      onViewAll: () {_openSearchPage(context, "0","Мне нравится", 'assets/images/loveplaylist.gif', false, false, true, false);}, need: true,
    ),
      buttonWithImg("История", (){_openSearchPage(context, "-1","История",'assets/images/history.png', false, true, false, false);}, context, 'assets/images/history.png'),
      buttonWithImg("Скаченное", (){_openSearchPage(context, "install","Скаченное",'assets/images/installmus.png', false, false, false, true);}, context, 'assets/images/installmus.png'),
      Consumer<ListManagerProvider>(
          builder: (context, listManager, child)
          {
            final list = listManager.getList("playlistlast4"); // Получить список из провайдера


            if (list.isEmpty) {
              return LibrarySection(
                title: 'Мои плейлесты',
                child: ItemsGrid(
                  items: [{'name': 'Нету плейлестов'}],
                  dfs: true, has: false, aptouch: (String img, String name, String id) { _openSearchPage(context, id, name, img, true, false, false, true);  },
                ),
                onViewAll: () {}, need: false,
              );
            }

            return  LibrarySection(
                  title: 'Мои плейлесты',
                  child: ItemsGrid(
                    items: list,
                    dfs: true, has: true, aptouch: (String img, String name, String id) { _openSearchPage(context, id, name, img, true, false, false, true);   },
                  ),
                  onViewAll: () {Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          PlaylistScreen(
                            onCallback: (dynamic input) => widget.onCallback(input),
                            hie: widget.hie,
                            showlog: widget.showlog,
                            resdf: widget.resdf,
                            onCallbackt: (dynamic input, dynamic inputi, String fds) =>
                                widget.onCallbackt(input, inputi, fds), prtctx: widget.parctx,
                          ),
                    ),
                  );}, need: false,
                );
          }),

      Consumer<ListManagerProvider>(
          builder: (context, listManager, child)
          {
            final list = listManager.getList("albumlast4"); // Получить список из провайдера


            if (list.isEmpty) {
              return LibrarySection(
                title: 'Любимые альбомы',
                child: ItemsGrid(
                  items: [{'name': 'Нету любимых альбомов'}],
                  dfs: true, has: false, aptouch: (String img, String name, String id) { _openSearchPage(context, id, name, img, true, false, false, true); },
                ),
                onViewAll: () {

                }, need: false,
              );
            }

            return  LibrarySection(
              title: 'Любимые альбомы',
              child: ItemsGrid(
                items: list,
                dfs: true, has: true, aptouch: (String img, String name, String id) { _openSearchPage(context, id, name, img, true, false, false, true);  },
              ),
              onViewAll: () {}, need: false,
            );
          }),
      Container(height: 134+ MediaQuery.of(context).padding.bottom,)
    ], _opacity, imgprofile, widget.showlog, context, useri, widget.hie, widget.resdf, 'Библиотека', _controller, _childController, _isAtTop, setState, _previousOffset, false, context, load, null);
  }


  void _handleMouseEnterFromOutside() {
    setState(() => showRefreshButton = true);
  }

  void _handleMouseExitFromInside() {
    setState(() {
      showRefreshButton = false;

    });
  }
  double _previousOffset = 0.0;









}


class LibrarySection extends StatelessWidget {
  final String title;
  final Widget child;
  final VoidCallback onViewAll;
  final bool need;
  LibrarySection({
    required this.title,
    required this.child,
    required this.onViewAll,
    required this.need,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0.0),
      child: Column(
        mainAxisSize:  MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              need ?  Container() :
              Opacity(opacity: 0, child: TextButton(
                onPressed: (){},
                child: Text('Все', style: TextStyle(color: Colors.blue)),
              ),),
              need ?
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    image: AssetImage("assets/images/loveplaylist.gif"),
                    fit: BoxFit.cover,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                )) : Expanded(child: Container()),
              need ? SizedBox(width: 10,) : Container(),
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              need ? Expanded(child: Container()) : Expanded(child: Container()),
              TextButton(
                onPressed: onViewAll,
                child: Text('Все', style: TextStyle(color: Colors.blue)),
              ),
            ],
          ),
          SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class LikedSongsGrid extends StatelessWidget {
  final BuildContext parctxj;
  final Function(int fdsvds, dynamic list) sendpalulit;
  const LikedSongsGrid({super.key, required this.parctxj, required this.sendpalulit});

  @override
  Widget build(BuildContext context) {


    return Container(
      height: 252,
      child: Consumer<ListManagerProvider>(
        builder: (context, listManager, child) {
      final list = listManager.getList('lovelast9');
      final listlast = listManager.getList('playlistid0');

      if (list.isEmpty) {
        return const Center(
          child: Text(
            'У вас нет любимых треков',
            style: TextStyle(color: Colors.white),
          ),
        );
      }
      //_updateHeight(list.length * 82);
      return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: (list.length / 3).ceil(),
        itemBuilder: (context, columnIndex) {
          final start = columnIndex * 3;
          final end = (start + 3 < list.length) ? start + 3 : list.length;
          final columnSongs = list.sublist(start, end);

          return Padding(
            padding: const EdgeInsets.only(right: 2.0),
            child: Column(
              children: columnSongs.map((song) {
                final songIndex = list.indexOf(song);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 2.0),
                  child:MussicCellStaticWidth(song, (){sendpalulit(songIndex, listlast);}, parctxj),
                );
              }).toList(),
            ),
          );
        },
      );
        },
      ),
    );
  }
}

class ItemsGrid extends StatelessWidget {
  final dynamic items;
  final bool dfs;
  final bool has;
  final Function(String img, String name, String id) aptouch;
  ItemsGrid({required this.items, required this.dfs, required this.has, required this.aptouch});

  ImageProvider _getSafeImageProvider(Map<String, dynamic> item) {
    try {
      // Пытаемся загрузить изображение из item
      if (item['img'] != null && item['img'].isNotEmpty && item['img'] != 'https://kompot.keep-pixel.ru/') {
        print("fsdfvdsv"+item['img']);
        return NetworkImage(item['img']!);
      }
    } catch (e) {
      // В случае ошибки возвращаем fallback изображение
      print("fsdfvdsv");
      return AssetImage('assets/images/playlist.png');
    }
    // Если изображение не указано, возвращаем fallback
    print("fsdfvdsv");
    return AssetImage('assets/images/playlist.png');
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return has ? GridView.builder(
      shrinkWrap: true,
      padding: dfs? EdgeInsets.only(bottom:  16) : null,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: size.width > 800 ? 4 : 2,
        childAspectRatio: 1,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return GestureDetector(
          onTap: () {
            // Navigate to item details
            aptouch(item['img']!, item['name']!, item['id']!);
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                image: _getSafeImageProvider(item),
              fit: BoxFit.cover,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            alignment: Alignment.bottomLeft,
            padding: EdgeInsets.all(12),
            child: Text(
              item['name']!,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    offset: Offset(1, 1),
                    blurRadius: 4,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ) : Center(child:
    Container(
      height: 100,
      padding: EdgeInsets.all(12),
      child: Text(
        items[0]['name']!,
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    ));
  }
}
