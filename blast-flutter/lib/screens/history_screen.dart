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
    _tabController.addListener(_updateTabHeight);
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
    var langData = await apiService.getMusicInPlaylist("0", 0);
    setState(() {
      showRefreshButton = false;
      context.read<ListManagerProvider>().createList('historyaccount', langData);
    });
    await Future.delayed(Duration(milliseconds: 301));
    setState(() {
      isRefreshing = false;
      isDragging = false;
    });
  }


  double _contentHeight = 300; // Начальная высота
  final double _defaultEmptyHeight = 100;

  void _updateHeight(double height) {
    if (_contentHeight != height) {
      setState(() {
        _contentHeight = height;
      });
    }
  }

  void _updateTabHeight() {
    if (!mounted) return;

    if (_tabController.index == 1) {
      // Вторая вкладка (История аккаунта) -> высота экрана
      //_updateHeight(MediaQuery.of(context).size.height-MediaQuery.of(context).padding.bottom-134);
      final listLength = context.read<ListManagerProvider>().getList('historyaccount').length;
      _updateHeight(listLength > 0 ? (listLength * 82)+ MediaQuery.of(context).padding.bottom : _defaultEmptyHeight);
    } else {
      // Первая вкладка -> вычисляемая высота списка
      final listLength = context.read<ListManagerProvider>().getList('historydevice').length;
      _updateHeight(listLength > 0 ? (listLength * 82)+ MediaQuery.of(context).padding.bottom : _defaultEmptyHeight);
    }
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
          child: Consumer<ListManagerProvider>(
            builder: (context, listManager, child) {
              final list = listManager.getList('historydevice');
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (_tabController.index == 0) {
                  _updateHeight(list.isNotEmpty ? (list.length * 82) + MediaQuery.of(context).padding.bottom : _defaultEmptyHeight);
                }
              });
              if (list.isEmpty) {
                return const Center(
                  child: Text(
                    'История устройства пуста',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }
              //_updateHeight(list.length * 82);
              return Column(
                mainAxisSize: MainAxisSize.max, // Не даёт колонке занимать всё доступное пространство
                children: list.map((track) {
                  return MussicCell(
                    track,
                        () {
                      widget.onCallbackt(list, list.indexOf(track));
                    },
                    widget.parctx,
                  );
                }).toList(),
              );
            },
          ),
        ),
        // История аккаунта
        SizedBox(
          child: Consumer<ListManagerProvider>(
            builder: (context, listManager, child) {
              final list = listManager.getList('historyaccount');
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (_tabController.index == 1) {
                  _updateHeight(list.isNotEmpty ? (list.length * 82) + MediaQuery.of(context).padding.bottom : _defaultEmptyHeight);
                }
              });
              if (list.isEmpty) {
                return const Center(
                  child: Text(
                    'История аккаунта пуста',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }
              //_updateHeight(list.length * 82);
              return Column(
                mainAxisSize: MainAxisSize.max, // Не даёт колонке занимать всё доступное пространство
                children: list.map((track) {
                  return MussicCell(
                    track,
                        () {
                      widget.onCallbackt(list, list.indexOf(track));
                    },
                    widget.parctx,
                  );
                }).toList(),
              );
            },
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
      _tabController, true, context, _contentHeight
    );
  }





}
