import 'dart:async';
import 'dart:convert';
import 'dart:io';


import 'package:blast/screens/profile_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../api/api_service.dart';
import '../parts/bottomsheet_about_music.dart';
import '../parts/buttons.dart';
import '../parts/headers.dart';
import '../providers/list_manager_provider.dart';


const kBgColor = Color(0xFF1604E2);

class VideoScreen extends StatefulWidget {
  final  Function(dynamic) onCallback;
  final VoidCallback hie;
  final VoidCallback showlog;
  final VoidCallback dsad;
  final BuildContext prtctx;
  const VideoScreen({Key? key, required this.onCallback, required this.hie, required this.showlog, required this.dsad, required this.prtctx}) : super(key: key);

  @override
  State<VideoScreen> createState() => _VideoScreenState((dynamic input) {onCallback(input);}, hie,showlog,dsad);

}

class _VideoScreenState extends State<VideoScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late VoidCallback showsearch;
  late VoidCallback showlog;
  late Function(dynamic) onCallback;
  late VoidCallback reseti;

  final ApiService apiService = ApiService();
  void load() async {
    var usera = await apiService.getUser();
    setState(() {
      if(usera['status'] != 'false') {
        useri = true;
        imgprofile = usera["img_kompot"];
      }else{
        useri = false;
      }
    });
    var langData = await apiService.getVideosTop();

    setState(() {
      context.read<ListManagerProvider>().createList('videosLast', langData);
    });
  }


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
            _isAtTop = _childController.offset <= 0 || _controller.offset <= 0 ;
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
          backgroundColor: kBgColor,

          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: kBgColor,
            statusBarBrightness: Brightness.dark, // For iOS: (dark icons)
            statusBarIconBrightness: Brightness.light, // For Android: (dark icons)
          ),
        ),
      ),
      extendBody: true,
      body: SafeArea(
        bottom: false,
        child:
        Container(
          height: size.height,
          decoration: new BoxDecoration(
              gradient: new LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(255, 15, 15, 16),
                  Color.fromARGB(255, 15, 15, 16),
                ],
              )),
          child:
          standatbuildcustomlistview(size.width > 800 ? _loadGridView() :  _loadListView(),_opacity, imgprofile, showlog, context, useri, widget.hie, reseti, 'Видео', _controller, _childController, _isAtTop, setState, _previousOffset, false, context, load, null, false)

      ),

      ),
    );
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


  _VideoScreenState(Function(dynamic) onk, VoidCallback fg, VoidCallback dawsd, VoidCallback gbdfgb) {
    onCallback = onk;
    showsearch = fg;
    showlog = dawsd;
    reseti = gbdfgb;
  }


  @override
  void dispose() {
    super.dispose();
  }


  Widget _loadGridView2() {
    Size size = MediaQuery.of(context).size;
    return Consumer<ListManagerProvider>(
        builder: (context, listManager, child)
        {
          final list = listManager.getList(
              'videosLast'); // Получить список из провайдера

          if (list.isEmpty) {
            return Center(child: Text('Нету видео'));
          }

          return GridView(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,

        mainAxisExtent: ((size.width/16)*4.1),
        crossAxisSpacing: 20,
        mainAxisSpacing: 10,
      ),
      children:  List.generate(list.length, (idx) {
        return CustomTile(
          title: list[idx]['name'],
          subtitle: list[idx]['message'],
          imageUrl: list[idx]['imgvidos'],
          wih: size.width,
          urlo: list[idx]['idshaz'],
          onCallback: (dynamic input) {onCallback(input);}, list: list[idx], prtctx: widget.prtctx,
        );
      }),
    );
        });
  }

  Widget _loadGridView() {
    return Consumer<ListManagerProvider>(
      builder: (context, listManager, child) {
        final list = listManager.getList('videosLast');
        final size = MediaQuery.of(context).size;

        if (list.isEmpty) {
          return const SliverToBoxAdapter(
            child: Center(child: Text('Нету видео')),
          );
        }

        // Возвращаем SliverGrid напрямую (без обертки)
        return SliverGrid(
          delegate: SliverChildBuilderDelegate(
                (context, index) {
              final item = list[index];
              return CustomTile(
                title: item['name'] ?? '',
                subtitle: item['message'] ?? '',
                imageUrl: item['imgvidos'] ?? '',
                wih: size.width,
                urlo: item['idshaz'] ?? '',
                onCallback: onCallback, list: item, prtctx: widget.prtctx,
              );
            },
            childCount: list.length,
          ),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: size.width > 1200 ? 4 : size.width > 800 ? 3 : 2,
            mainAxisExtent: size.width > 1200 ? (size.width / 16) * 3 : ((size.width/16)*4.1),
            crossAxisSpacing: 20,
            mainAxisSpacing: 10,
          ),
        );
      },
    );
  }



  Widget _loadListView() {
    Size size = MediaQuery.of(context).size;
    return
    Consumer<ListManagerProvider>(
        builder: (context, listManager, child)
    {
      final list = listManager.getList(
          'videosLast'); // Получить список из провайдера

      if (list.isEmpty) {
        return Center(child: Text('Нету видео'));
      }

      return ListView.builder(
        shrinkWrap: true,
      controller: _childController,
      itemCount: list.length,
      itemBuilder: (BuildContext context, int idx)
      {
          return CustomTile(
            title: list[idx]['name'],
            subtitle: list[idx]['message'],
            imageUrl: list[idx]['imgvidos'],
            wih: size.width,
            urlo: list[idx]['idshaz'],
            onCallback: (dynamic input) {onCallback(input);}, list: list[idx], prtctx: widget.prtctx,
          );
      },
    );
    }
    );
  }



  String imgprofile = "";
  bool useri = false;


}
class CustomTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;
  final double wih;
  final String urlo;
  final dynamic list;
  final Function(dynamic) onCallback;
  final BuildContext prtctx;

  const CustomTile({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.wih,
    required this.urlo,
    required this.onCallback,
    Key? key, required this.list, required this.prtctx,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final imageWidth = wih;
    final textMaxWidth = imageWidth - 32; // Оставляем отступы по 16 с каждой стороны

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: imageWidth,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Видео превью
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      width: imageWidth,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[800],
                        child: Icon(Icons.error, color: Colors.white),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Текстовая информация
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: textMaxWidth,
                        child: Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        width: textMaxWidth,
                        child: Text(
                          subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w300,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Кликабельная кнопка поверх всего
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => onCallback(urlo),
                  child: Container(),
                ),
              ),
            ),

            // Кнопка меню в правом нижнем углу картинки
            Positioned(
              right: 0,
              bottom: 0, // Располагаем над текстовым блоком
              child: IconButton(
                icon: const Icon(Icons.more_vert, color: Colors.white),
                onPressed: () {
                  // Действие при нажатии на меню
                  showTrackOptionsBottomSheet(prtctx, list);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}



