import 'package:audio_service/audio_service.dart';
import 'package:blast/screens/profile_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/api_service.dart';
import '../parts/buttons.dart';
import '../parts/headers.dart';
import '../parts/music_cell.dart';
import '../providers/list_manager_provider.dart';



const kBgColor = Color.fromARGB(255, 15, 15, 16);

class MusicScreen extends StatefulWidget {
  final  Function(dynamic) onCallback;
  final VoidCallback onCallbacki;
  final VoidCallback hie;
  final VoidCallback showlog;
  final VoidCallback resre;
  final VoidCallback essension;
  final BuildContext parctx;
  final Function(dynamic input, dynamic inputi) onCallbackt;
  MusicScreen({Key? key, required this.onCallback, required this.onCallbacki, required this.hie, required this.showlog, required this.resre, required this.essension, required this.parctx, required this.onCallbackt}) : super(key: key);
  @override
  State<MusicScreen> createState() => MusicScreenState((dynamic input) {onCallback(input);},onCallbacki, hie, showlog, resre,essension);




}

class MusicScreenState extends State<MusicScreen> with TickerProviderStateMixin{
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late AnimationController controllermuscircle;

  late AnimationController _controllere;
  double dragValue = 0.0;


  var iconplaese = Icon(Icons.play_arrow_rounded, size: 64, color: Colors.white,key: ValueKey<bool>(AudioService.playbackState.playing));
  var iconpla = Icon(Icons.play_arrow_rounded, size: 64, color: Colors.white,key: ValueKey<bool>(AudioService.playbackState.playing));
  void updateIcon(Icon newIcon) {
    setState(() {
      iconpla = newIcon;
    });
  }
  void updateIconese(Icon newIcon) {
    setState(() {
      iconplaese = newIcon;
    });
  }


  bool showRefreshButton = false;
  bool isRefreshing = false;

  late  Function(dynamic) onCallback;
  late VoidCallback onCallbacki;
  late VoidCallback essension;
  late VoidCallback showsearch;
  late VoidCallback showlog;
  late VoidCallback reseti;
  var player;




  final String listKey = "top20";

  void _showSmallDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(child: Container(margin: const EdgeInsets.only(right: 100, left: 100, bottom: 80, top: 80), padding: const EdgeInsets.only(right: 60, left: 60, bottom: 60, top: 60), decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(40)), color: Color.fromARGB(255, 15, 15, 16)),child:
        Column(mainAxisSize: MainAxisSize.min,
          children: [
          const Text("blast! находится в alpha",
          style: TextStyle(
            fontSize: 30,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),),
          const Text("История обновления",
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),),
        Expanded(child:
        ListView.builder(
        itemCount: 1,
        itemBuilder: (BuildContext context, int idx)
        {
        return const Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [Text("Функция Эссенция",
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),),
          Text("Это инструмент, который позволяет пользователю познакомиться с треками через наиболее выразительные и запоминающиеся фрагменты. Каждая песня в библиотеке имеет короткий отрывок, специально подобранный для максимального впечатления, который и составляет её Эссенцию.",
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),)
        ],);

        },
        ))
        ],),));
      },
    );
  }





  MusicScreenState(Function(dynamic) onk,VoidCallback onki, VoidCallback fg, VoidCallback dawsd, VoidCallback dsacf, VoidCallback dsacfdcs){
    onCallback = onk;
    onCallbacki = onki;
    showsearch = fg;
    showlog = dawsd;
    reseti = dsacf;
    essension = dsacfdcs;
  }
  late Animation<double> _animation;
  late Animation<double> _animationi;
  bool isAnimating = false;
  bool isAnimatingi = false;
  void toggleAnimation(bool ds) {
    setState(() {
      if (ds) {
        controllermuscircle.repeat();
      } else {
        controllermuscircle.animateTo(controllermuscircle.value+0.01, duration: const Duration(seconds: 1));
      }
      isAnimating = ds;
    });
  }


  void toggleAnimationese(bool ds) {
    setState(() {
      if (ds) {
        _controllere.repeat();
      } else {
        _controllere.animateTo(_controllere.value+0.01, duration: const Duration(seconds: 1));
      }
      isAnimatingi = ds;
    });
  }
  final ApiService apiService = ApiService();
  void load() async {
    setState(() {
      isRefreshing = true;
      showRefreshButton = true;
    });
    var usera = await apiService.getUser();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if(usera['status'] != 'false') {
        useri = true;
        imgprofile = usera["img_kompot"];
      }else{
        useri = false;
      }
    });
    var langData = await apiService.getTopMusic();
    setState(() {
      showRefreshButton = false;
      context.read<ListManagerProvider>().createList('top20', langData);
    });
    await Future.delayed(Duration(milliseconds: 301));
    setState(() {
      isRefreshing = false;
      isDragging = false;
    });
  }

  bool isDragging = false;

  void _showMainBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      backgroundColor: Colors.black87,
      builder: (context) {
        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            String category = categories.keys.elementAt(index);
            List<String> options = categories[category]!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: options.map((option) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context); // Закрываем BottomSheet
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(12))),content: Center(child: Text('Вы выбрали: $option'))),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[850], // Темная кнопка
                            foregroundColor: Colors.white, // Белый текст
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                          ),
                          child: Text(option),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 16), // Отступ между категориями
              ],
            );
          },
        );
      },
    );
  }

  // Данные категорий и их опций
  final Map<String, List<String>> categories = {
    "По занятию": ["Тренировка", "Работа", "Учёба", "Прогулка"],
    "По характеру": ["Энергичная", "Спокойная", "Мотивирующая", "Расслабляющая"],
    "Под настроение": ["Весёлое", "Грустное", "Романтичное", "Нейтральное"],
    "По языку": ["Английский", "Русский", "Испанский", "Французский"],
  };


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


    controllermuscircle = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 50),
    )..repeat();

    _controllere = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30), // Задаем время полного оборота
    );

    _animation = CurvedAnimation(
      parent: controllermuscircle,
      curve: Curves.easeInOut,  // Плавное ускорение и замедление
    );

    _animationi = CurvedAnimation(
      parent: _controllere,
      curve: Curves.easeInOut,  // Плавное ускорение и замедление
    );
    super.initState();
  }
  void _handleMouseEnterFromOutside() {
    setState(() => showRefreshButton = true);
  }

  void _handleMouseExitFromInside() {
    setState(() {
      showRefreshButton = false;

    });
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
        body: Stack(children: [
          SafeArea(
            top: false,
            bottom: false,
            child:
            Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromARGB(0, 15, 15, 16),
                      Color.fromARGB(0, 15, 15, 16),
                    ],
                  )),
              child: size.width > 800 ? SizedBox(width: size.width, height: size.height, child: SizedBox(width: size.width, height: size.height, child: Row(children: [ SizedBox(height: size.height, width: size.width/2, child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, mainAxisSize: MainAxisSize.max, children: [Stack(
                clipBehavior: Clip.none,
                children: [




                ],), Expanded(child: _loadListViewMore()) ],)),  SizedBox(width: size.width/2,
                  child: Stack(alignment: Alignment.topRight, children: [ Center(child:
                  Stack(alignment: Alignment.center,
                    children: [
                      PageView(
                        physics: const BouncingScrollPhysics(),
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 32, right: 32),
                            alignment: Alignment.center,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                RotationTransition(
                                  turns: Tween(begin: 0.0, end: 1.0).animate(controllermuscircle),
                                  child: Image.asset('assets/images/circleblast.png', width: 600),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(left: 12, top: 12),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(right: 8),
                                        child: const Text(
                                          "Джем",
                                          style: TextStyle(
                                            fontSize: 40,
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(right: 8),
                                        child: IconButton(
                                          onPressed: () {
                                            onCallbacki();
                                          },
                                          iconSize: 64,
                                          icon: AnimatedSwitcher(
                                            duration: const Duration(milliseconds: 300),
                                            transitionBuilder: (Widget child, Animation<double> animation) {
                                              return RotationTransition(
                                                turns: Tween(begin: 0.75, end: 1.0).animate(animation),
                                                child: ScaleTransition(scale: animation, child: child),
                                              );
                                            },
                                            child: iconpla,
                                          ),
                                        ),
                                      ),
                                      // Кнопка для "Настроить джем"
                                      Container(
                                        margin: const EdgeInsets.only(top: 16),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            _showMainBottomSheet(widget.parctx);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.grey[850]?.withOpacity(0.4),
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 24, vertical: 12),
                                          ),
                                          child: const Text(
                                            "Настроить джем",
                                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(width: 600, height: 600, child:   Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(margin: const EdgeInsets.only(left: 12,right: 12), child:
                              RotationTransition(
                                  turns: Tween(begin: 0.0, end: 1.0).animate(_controllere),
                                  child:Image.asset('assets/images/forclock.png', width: 600,))),
                              // Часовая стрелка (короче)
                              Container(height: 360, width: 360, child:
                              RotationTransition(
                                turns: Tween(begin: 0.0, end: 1.0).animate(
                                  CurvedAnimation(
                                    parent: _controllere,
                                    curve: Curves.linear,
                                  ),
                                ),
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  child: Container(
                                    height: 200, // Половина длины для часовой стрелки
                                    width: 40,
                                    decoration: const BoxDecoration(color: Colors.purpleAccent,borderRadius: BorderRadius.all(Radius.circular(200))),
                                  ),
                                ),
                              )),
                              // Минутная стрелка (длиннее)
                              Container(height: 280, width: 280, child:
                              RotationTransition(
                                turns: Tween(begin: 0.0, end: 12.0).animate(
                                  CurvedAnimation(
                                    parent: _controllere,
                                    curve: Curves.linear,
                                  ),
                                ),
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  child: Container(
                                    height: 160, // Длина минутной стрелки чуть больше
                                    width: 40,
                                    decoration: const BoxDecoration(color: Colors.purple,borderRadius: BorderRadius.all(Radius.circular(200))),
                                  ),
                                ),
                              )),
                              Container(padding: const EdgeInsets.only(left: 12,top: 12),
                                  child:
                                  Column(mainAxisAlignment: MainAxisAlignment.center, children: [ Container(margin: const EdgeInsets.only(right: 8), child:const Text("Эссенция",
                                    style: TextStyle(
                                      fontSize: 40,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),)),Container(margin: const EdgeInsets.only(right: 8), child:
                                  IconButton(onPressed: ()  {
                                    essension();
                                  }, iconSize: 64,
                                      icon: AnimatedSwitcher(
                                          duration: const Duration(milliseconds: 300),
                                          transitionBuilder: (Widget child, Animation<double> animation) {
                                            return RotationTransition(
                                              turns: Tween(begin: 0.75, end: 1.0).animate(animation),
                                              child: ScaleTransition(scale: animation, child: child),
                                            );
                                          },
                                          child:iconplaese)))],)
                              ),
                            ],
                          ),
                          )

                        ],),

                    ],),)],)),],),))

                  : standatbuildcustomlistview(_onlylist(),_opacity, imgprofile, showlog, context, useri, widget.hie, widget.resre, 'Чарт', _controller, _childController, _isAtTop, setState, _previousOffset, false, context, load, jemandessension(), false),
            ),

          ),

        ],)
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







  Widget jemandessension(){
    Size size = MediaQuery.of(context).size;
    return Container(child: SizedBox(height: size.width,
      child:
      PageView(
        physics: const BouncingScrollPhysics(),
        children: [
          Container(margin: const EdgeInsets.only(
              left: 32, right: 32),
              alignment: Alignment.center,
              child:
              Stack(alignment: Alignment.center,
                children: [
                  RotationTransition(
                      turns: Tween(begin: 0.0, end: 1.0)
                          .animate(controllermuscircle),
                      child: Image.asset(
                        'assets/images/circleblast.png',
                        width: 600,)),
                  Container(padding: const EdgeInsets.only(
                      left: 12, top: 12),
                      child:
                      Column(
                        mainAxisAlignment: MainAxisAlignment
                            .center,
                        children: [
                          Container(
                              margin: const EdgeInsets.only(
                                  right: 8),
                              child: const Text("Джем",
                                style: TextStyle(
                                  fontSize: 40,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),)),
                          Container(
                              margin: const EdgeInsets.only(
                                  right: 8), child:
                          IconButton(onPressed: () {
                            onCallbacki();
                          }, iconSize: 64,
                              icon: AnimatedSwitcher(
                                  duration: const Duration(
                                      milliseconds: 300),
                                  transitionBuilder: (
                                      Widget child, Animation<
                                          double> animation) {
                                    return RotationTransition(
                                      turns: Tween(begin: 0.75,
                                          end: 1.0).animate(
                                          animation),
                                      child: ScaleTransition(
                                          scale: animation,
                                          child: child),
                                    );
                                  },
                                  child: iconpla))),
                          // Кнопка для "Настроить джем"
                          Container(
                            margin: const EdgeInsets.only(
                                top: 16),
                            child: ElevatedButton(
                              onPressed: () {
                                _showMainBottomSheet(
                                    widget.parctx);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors
                                    .grey[850]?.withOpacity(
                                    0.4),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius
                                      .circular(20),
                                ),
                                padding: const EdgeInsets
                                    .symmetric(
                                    horizontal: 24,
                                    vertical: 12),
                              ),
                              child: const Text(
                                "Настроить джем",
                                style: TextStyle(fontSize: 16,
                                    fontWeight: FontWeight
                                        .bold),
                              ),
                            ),
                          ),
                        ],)
                  ),
                ],)),
          SizedBox(width: 600, height: 600, child:
          Container(
            margin: const EdgeInsets.only(left: 32, right: 32),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(padding: const EdgeInsets.only(
                    left: 12, right: 12), child:
                RotationTransition(
                    turns: Tween(begin: 0.0, end: 1.0).animate(
                        _controllere),
                    child: Image.asset(
                      'assets/images/forclock.png',
                      width: 600,))),
                // Часовая стрелка (короче)
                Container(height: 360, width: 360, child:
                RotationTransition(
                  turns: Tween(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                      parent: _controllere,
                      curve: Curves.linear,
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      height: 200,
                      // Половина длины для часовой стрелки
                      width: 40,
                      decoration: const BoxDecoration(
                          color: Colors.purpleAccent,
                          borderRadius: BorderRadius.all(
                              Radius.circular(200))),
                    ),
                  ),
                )),
                // Минутная стрелка (длиннее)
                Container(height: 280, width: 280, child:
                RotationTransition(
                  turns: Tween(begin: 0.0, end: 12.0).animate(
                    CurvedAnimation(
                      parent: _controllere,
                      curve: Curves.linear,
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      height: 160,
                      // Длина минутной стрелки чуть больше
                      width: 40,
                      decoration: const BoxDecoration(
                          color: Colors.purple,
                          borderRadius: BorderRadius.all(
                              Radius.circular(200))),
                    ),
                  ),
                )),
                Container(padding: const EdgeInsets.only(
                    left: 12, top: 12),
                    child:
                    Column(mainAxisAlignment: MainAxisAlignment
                        .center,
                      children: [
                        Container(
                            margin: const EdgeInsets.only(
                                right: 8),
                            child: const Text("Эссенция",
                              style: TextStyle(
                                fontSize: 40,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),)),
                        Container(
                            margin: const EdgeInsets.only(
                                right: 8), child:
                        IconButton(onPressed: () {
                          essension();
                        }, iconSize: 64,
                            icon: AnimatedSwitcher(
                                duration: const Duration(
                                    milliseconds: 300),
                                transitionBuilder: (
                                    Widget child, Animation<
                                        double> animation) {
                                  return RotationTransition(
                                    turns: Tween(
                                        begin: 0.75, end: 1.0)
                                        .animate(animation),
                                    child: ScaleTransition(
                                        scale: animation,
                                        child: child),
                                  );
                                },
                                child: iconplaese)))
                      ],)
                ),
              ],
            ),
          ))

        ],)

      ,),);
  }


  @override
  void dispose() {
    controllermuscircle.dispose();
    _scrollController.dispose();
    _controllere.dispose();
    super.dispose();
  }


  final ScrollController _scrollController = ScrollController();

  Widget _loadListViewMore() {

    return Consumer<ListManagerProvider>(
        builder: (context, listManager, child)
    {
      final list = listManager.getList(
          'top20'); // Получить список из провайдера

      if (list.isEmpty) {
        return Center(child: Text('Нету треков'));
      }

      return NotificationListener<ScrollNotification>(
          onNotification: (notification) {
        if (notification is OverscrollNotification && !isRefreshing) {
          setState(() => isDragging = true);
        }
        if (notification is ScrollEndNotification && isDragging) {
          load();
        }
        return false;
      },
      child: ListView.builder(
        controller: _scrollController,
        itemCount: list.length + 1,
        itemBuilder: (BuildContext context, int idx) {
          return SizedBox(child: idx == 0 ? const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10,),
              Center(child: Text("Чарт",
                style: TextStyle(
                  fontSize: 30,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),),),
              SizedBox(height: 10,),

            ],
          )
              :
          MussicCellNumber(idx, list[idx - 1], () {
            widget.onCallbackt(list, idx-1);
          }, widget.parctx)
          );
        },
      ),
      );
    });
  }



  Widget _onlylist() {
    Size size = MediaQuery.of(context).size;
    return Consumer<ListManagerProvider>(
        builder: (context, listManager, child) {
          final list = listManager.getList(
              'top20'); // Получить список из провайдера

          if (list.isEmpty) {
            return Center(child: Text('Нету треков'));
          }

          return ListView.builder(
            shrinkWrap: true,
            controller: _childController,
            itemCount: list.length,
            itemBuilder: (BuildContext context, int idx) {
              return MussicCellNumber(idx+1, list[idx], () {
                widget.onCallbackt(list, idx);
              }, widget.parctx
              );
            },
          );
        });
  }

  String imgprofile = "";
  bool useri = false;


}




