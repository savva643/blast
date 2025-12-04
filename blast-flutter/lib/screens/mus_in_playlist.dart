import 'dart:async';
import 'dart:convert';

import '../api//api_install.dart';
import 'package:blast/screens/login.dart';
import 'package:blast/screens/profile_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../api/api_service.dart';
import '../parts/buttons.dart';
import '../parts/headers.dart';
import '../parts/music_cell.dart';
import '../providers/list_manager_provider.dart';
import 'need_install_app.dart';



const kBgColor = Color(0xFF1604E2);

class MusInPlaylistScreen extends StatefulWidget {
  final  Function(dynamic) onCallback;
  final String onCallbacki;
  final  Function(dynamic, dynamic, String) onCallbackt;
  final String name;
  final String img;
  final bool imgnd;
  final VoidCallback hie;
  final VoidCallback showlog;
  final VoidCallback resre;
  MusInPlaylistScreen({Key? key, required this.onCallback, required this.onCallbacki, required this.hie, required this.name, required this.img, required this.imgnd, required this.showlog, required this.resre, required this.onCallbackt}) : super(key: key);
  @override
  State<MusInPlaylistScreen> createState() => MusInPlaylistScreenState((dynamic input) {onCallback(input);},onCallbacki, hie, name, img, imgnd,showlog,resre,(dynamic input, dynamic inputi, String sdazc) {onCallbackt(input, inputi, sdazc);});




}

class MusInPlaylistScreenState extends State<MusInPlaylistScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


// В класс MusInPlaylistScreenState добавьте:
  late DownloadManager _downloadManager;
  List<DownloadModel> _activeDownloads = [];
  var iconpla = Icon(Icons.play_arrow_rounded, size: 64, color: Colors.white,);
  void updateIcon(Icon newIcon) {
    setState(() {
      iconpla = newIcon;
    });
  }
  late  Function(dynamic) onCallback;
  late  Function(dynamic,dynamic, String) dfv;
  late String palylsitid;
  late String palylsitname;
  late String palylsitimg;
  late bool palylsitimgnd;
  late VoidCallback showsearch;
  late VoidCallback showlog;
  late VoidCallback reset;

  MusInPlaylistScreenState(Function(dynamic) onk,String onki, VoidCallback fg,String erfw,String fdcdsc,bool fdsfad, VoidCallback dawsd, VoidCallback fgdfxg, Function(dynamic, dynamic, String) onkhngf){
    onCallback = onk;
    palylsitid = onki;
    showsearch = fg;
    palylsitname = erfw;
    palylsitimg = fdcdsc;
    palylsitimgnd = fdsfad;
    showlog = dawsd;
    reset = fgdfxg;
    dfv = onkhngf;
  }


  final ApiService apiService = ApiService();
  void load() async {
    setState(() {
      isRefreshing = true;
      showRefreshButton = true;
    });
    late var langData;
    var usera = await apiService.getUser();
    setState(() {
      if(usera['status'] != 'false') {
        useri = true;
        imgprofile = usera["img_kompot"];
      }else{
        useri = false;
      }
    });
    if(palylsitid != "install") {
      langData = await apiService.getMusicInPlaylist(palylsitid, 0);
      setState(() {
        showRefreshButton = false;
        context.read<ListManagerProvider>().createList('playlistid'+palylsitid.toString(), langData);
      });
    }else{
      langData = await apiService.getInstalledMusic();
      setState(() {
        showRefreshButton = false;
        context.read<ListManagerProvider>().createList('installedmusic', langData);
      });
    }
    await Future.delayed(Duration(milliseconds: 301));
    setState(() {
      isRefreshing = false;
    });
    print(usera.toString()+'kighj');
  }

  String imgprofile = "";
  bool useri = false;

  @override
  void initState()
  {
    _downloadManager = DownloadManager();
    _downloadManager.downloadStream.listen((downloads) {
      setState(() {
        _activeDownloads = downloads.where((d) => !d.isCompleted).toList();
      });
    });
    // Проверяем, если это веб-версия и открыта вкладка "Скачанные"
    if (kIsWeb && palylsitid == "install") {
      // Откладываем навигацию до следующего кадра
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => WebVersionScreen(),
          ),
        );
      });
      return; // Прекращаем дальнейшую инициализацию
    }
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
          child: standatbuildcustomlistviewStack(_loadListView(),_opacity, imgprofile, showlog, context, useri, widget.hie, widget.resre, palylsitname, _controller, _childController, _isAtTop, setState, _previousOffset, true, context, load, _playlistImg(), false, true)

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

  bool showRefreshButton = false;
  bool isRefreshing = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _playlistImg() {
    Size size = MediaQuery.of(context).size;
    return size.width > 600 ?
    Stack(
      clipBehavior: Clip.none,
      children: [
        AnimatedContainer(
            margin: EdgeInsets
                .only(
                left: 0,
                right: 0,
                top: 0),
            constraints: BoxConstraints(maxHeight: 400, maxWidth: 400),
            height: size.width/3,
            width: size.width/3,
            decoration: BoxDecoration(
              shape: BoxShape
                  .rectangle,
              borderRadius: BorderRadius
                  .only(bottomRight: Radius.circular(20) ),
            ),

            clipBehavior: Clip
                .hardEdge,
            duration: Duration(
                milliseconds: 0),
            child: AspectRatio(
                aspectRatio: 1,
                // Сохранение пропорций 1:1
                child: palylsitimgnd ? Image.network(
                  palylsitimg,
                  height: size.width,
                  width: size.width,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Image.asset(
                    'assets/images/playlist.png',
                    height: size.width,
                    width: size.width,
                    fit: BoxFit.cover,
                  ),
                ) : Image(image: AssetImage(palylsitimg), width: size.width,))),

        Container(margin: EdgeInsets.only(left: (size.width/3 >= 400 ? 400 : size.width/3 )+ 10, top: 20), child:
        Row(children: [Container(margin: EdgeInsets.only(top: 0), child: IconButton(onPressed: (){ Navigator.pop(context); }, icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.white, size: 34,)),),
          Text(palylsitname,
            style: TextStyle(
              fontSize: 30,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),)],)),
      ],)
        : Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            AnimatedContainer(
                margin: EdgeInsets
                    .only(
                    left: 0,
                    right: 0,
                    top: 0),
                height: size.width,
                width: size.width,
                decoration: BoxDecoration(
                  shape: BoxShape
                      .rectangle,
                  borderRadius: BorderRadius
                      .only(
                      bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20) ),
                ),

                clipBehavior: Clip
                    .hardEdge,
                duration: Duration(
                    milliseconds: 0),
                child: AspectRatio(
                    aspectRatio: 1,
                    // Сохранение пропорций 1:1
                    child: palylsitimgnd ? Image.network(
                      palylsitimg,
                      height: size.width,
                      width: size.width,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Image.asset(
                        'assets/images/playlist.png',
                        height: size.width,
                        width: size.width,
                        fit: BoxFit.cover,
                      ),
                    ) : Image(image: AssetImage(palylsitimg), width: size.width,))),
          ],),
      ],
    );
  }




  Widget _loadListView() {
    return Consumer<ListManagerProvider>(
        builder: (context, listManager, child) {
          late var list;
          if(palylsitid != "install") {
            list = listManager.getList('playlistid'+palylsitid.toString());
          } else {
            // Для раздела "Скачанные" объединяем загруженные треки и активные загрузки
            list = listManager.getList('installedmusic');

            // Добавляем активные загрузки в начало списка
            if(_activeDownloads.isNotEmpty) {
              list = [
                ..._activeDownloads.map((d) => {
                  'id': d.id,
                  'idshaz': d.idshaz,
                  'name': d.name,
                  'img': d.img,
                  'message': d.message,
                  'txt': d.txt,
                  'messageimg': d.messageimg,
                  'short': d.short,
                  'vidos': d.vidos,
                  'bgvideo': d.bgvideo,
                  'elir': d.elir,
                  'isDownloading': true,
                  'progress': d.progress,
                }),
                ...list
              ];
            }
          }

          if (list.isEmpty) {
            return Center(child: Text('Нету треков', style: TextStyle(color: Colors.white, fontSize: 28),));
          }

          return ListView.builder(
            shrinkWrap: true,
            controller: _childController,
            itemCount: list.length,
            itemBuilder: (BuildContext context, int idx) {
              return list[idx]['isDownloading'] == true ? MussicCellProgress(
                list[idx],
                    (){sendpalulit(idx, list);},
                    () {_downloadManager.cancelDownload(list['id']);},
                context,
                isDownloading: list[idx]['isDownloading'] == true,
                progress: list[idx]['progress']?.toDouble() ?? 0.0,
              ) : MussicCell(
                list[idx],
                    (){sendpalulit(idx, list);},
                context,
              );
            },
          );
        }
    );
  }

  void sendpalulit(var fdsvds, dynamic list){
    print(list.toString() + fdsvds.toString() + palylsitname+ "ghfghnf");
    dfv(list,fdsvds, palylsitname);
  }




}




