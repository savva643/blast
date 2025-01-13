import 'dart:ui';

import 'package:blast/screens/profile_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../api/api_service.dart';
import '../parts/buttons.dart';
import '../parts/headers.dart';
import '../providers/list_manager_provider.dart';
import 'history_screen.dart';
import 'mus_in_playlist.dart';

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
  late ScrollController _childController;
  bool _isChildScrolling = false;
  @override
  void initState() {
    super.initState();
    _controller.addListener(_scrollListener);
    _childController = ScrollController();
    load();

    // Слушаем прокрутку дочернего списка
    _childController.addListener(() {
      if (_isChildScrolling &&
          _childController.offset <= _childController.position.minScrollExtent) {
        // Возврат управления родительскому списку
        setState(() {
          _isChildScrolling = false;
          if(_childController.offset <= 0){
            _isAtTop = _childController.offset <= 0 || _controller.offset <= 0 ;
          }
        });
      }
    });
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
      child: LikedSongsGrid(),
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
                  dfs: true, has: false,
                ),
                onViewAll: () {}, need: false,
              );
            }

            return  LibrarySection(
                  title: 'Мои плейлесты',
                  child: ItemsGrid(
                    items: list,
                    dfs: true, has: true,
                  ),
                  onViewAll: () {}, need: false,
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
                  dfs: true, has: false,
                ),
                onViewAll: () {}, need: false,
              );
            }

            return  LibrarySection(
              title: 'Любимые альбомы',
              child: ItemsGrid(
                items: list,
                dfs: true, has: true,
              ),
              onViewAll: () {}, need: false,
            );
          }),
      Container(height: 134+ MediaQuery.of(context).padding.bottom,)
    ], _opacity, imgprofile, widget.showlog, context, useri, widget.hie, widget.resdf, 'Библиотека', _controller, _childController, _isAtTop, setState, _previousOffset, false, context);
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
  @override
  Widget build(BuildContext context) {
    final songs = [
      {'title': 'Song 1', 'artist': 'Artist 1'},
      {'title': 'Song 2', 'artist': 'Artist 2'},
      {'title': 'Song 3', 'artist': 'Artist 3'},
      {'title': 'Song 4', 'artist': 'Artist 4'},
      {'title': 'Song 5', 'artist': 'Artist 5'},
      {'title': 'Song 6', 'artist': 'Artist 6'},
      {'title': 'Song 7', 'artist': 'Artist 7'},
      {'title': 'Song 8', 'artist': 'Artist 8'},
      {'title': 'Song 8', 'artist': 'Artist 9'},
    ];

    return Container(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: (songs.length / 3).ceil(),
        itemBuilder: (context, columnIndex) {
          final start = columnIndex * 3;
          final end = (start + 3 < songs.length) ? start + 3 : songs.length;
          final columnSongs = songs.sublist(start, end);

          return Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Column(
              children: columnSongs.map((song) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Container(
                    width: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Icon(Icons.music_note, color: Colors.white, size: 32),
                        SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              song['title']!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              song['artist']!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
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
  ItemsGrid({required this.items, required this.dfs, required this.has});

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
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                image: AssetImage(item['img']!),
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
