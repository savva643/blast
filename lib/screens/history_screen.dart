import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../api/api_service.dart';
import '../parts/headers.dart';
import '../parts/music_cell.dart';
import '../providers/list_manager_provider.dart';

class HistoryScreen extends StatefulWidget {
  final VoidCallback showlog;
  final dynamic  hie, resdf;
  final BuildContext parctx;
  final Function onCallbackt;
  final Function(dynamic) onCallback;
  const HistoryScreen({
    Key? key,
    required this.showlog,
    required this.hie,
    required this.resdf,
    required this.parctx,
    required this.onCallbackt,
    required this.onCallback,
  }) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _controller = ScrollController();
  late ScrollController _childController;
  double _previousOffset = 0;
  bool _isAtTop = true;
  bool isDragging = false;
  bool isRefreshing = false;


  @override
  void dispose() {
    _tabController.dispose();
    _controller.dispose();
    _childController.dispose();
    super.dispose();
  }


  double _opacity = 0.0;
  bool _isChildScrolling = false;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    _controller.addListener(_scrollListener);
    _childController = ScrollController();


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



  bool showRefreshButton = false;


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


  Widget build(BuildContext context) {
    return standatbuildtavview(
      [
        // История устройства
        SizedBox(
        height: 20*200,child:
        Consumer<ListManagerProvider>(
          builder: (context, listManager, child) {
            final list = listManager.getList('top20');
            if (list.isEmpty) {
              return const Center(
                child: Text(
                  'Нету треков',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }
            return ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: list.length,
              itemBuilder: (context, idx) {
                return MussicCell(
                  list[idx],
                      () {
                    widget.onCallbackt(list, idx);
                  },
                  widget.parctx,
                ) ;
              },
            );
          },
        )),
        // История аккаунта
        Center(
          child: const Text(
            'История аккаунта пока пуста',
            style: TextStyle(color: Colors.white),
          ),
        ),
        
      ],
      _opacity,
      imgprofile,
      widget.showlog,
      widget.parctx,
      useri,
      widget.hie,
      widget.resdf,
      'История',
      _controller,
      _childController,
      _isAtTop,
      setState,
      _previousOffset,
      _tabController, true, context
    );
  }





}
