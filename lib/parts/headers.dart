import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/list_manager_provider.dart';
import '../screens/profile_screen.dart';
import 'buttons.dart';

Widget headerwithblast(String imgprofile, VoidCallback showlog, BuildContext context, bool useri, VoidCallback hie, VoidCallback resdf) {
  return SliverToBoxAdapter(
    child: Stack(
      children: [
        Positioned(
          top: -230,
          left: -150,
          child: Opacity(
            opacity: 1,
            child: Image.asset(
              'assets/images/circlebg.png',
              width: 360,
              height: 360,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 12, top: 8, bottom: 50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "blast!",
                style: TextStyle(
                  fontSize: 40,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                // Центрирование по вертикали

                children: [
                  IconButton(
                    onPressed: hie,
                    icon: const Icon(
                      Icons.search_rounded,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 16), // Отступ между кнопками
                  Container(alignment: Alignment.topRight,
                    margin: const EdgeInsets.only(top: 0),
                    child: IconButton(onPressed: useri ? () {
                      Navigator.push(context, MaterialPageRoute(builder: (
                          context) => ProfileScreen(reseti: resdf,)));
                    } : showlog,
                        icon: imgprofile != "" ? SizedBox(
                            height: 44, width: 44, child: CachedNetworkImage(
                          imageUrl: imgprofile,
                          // Replace with your image URL
                          imageBuilder: (context, imageProvider) =>
                              Container(
                                margin: const EdgeInsets.only(right: 3, top: 3),
                                width: 100.0,
                                // Set the width of the circular image
                                height: 100.0,
                                // Set the height of the circular image
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit
                                        .cover, // Adjusts the image inside the circle
                                  ),
                                ),
                              ),
                          placeholder: (context,
                              url) => const CircularProgressIndicator(),
                          // Placeholder while loading
                          errorWidget: (context, url, error) =>
                          const Icon(
                              Icons.error), // Error icon if image fails to load
                        )) : buttonlogin(showlog)),)
                ],
              ),
            ],

          ),
        ),
      ],
    ),
  );
}

const kBgColor = Color.fromARGB(255, 15, 15, 16);

Widget headerfast(double opacity, String imgprofile, VoidCallback showlog, BuildContext context, bool useri, VoidCallback hie, VoidCallback resdf, String name, bool back, BuildContext childctx){
  return SliverAppBar(
    automaticallyImplyLeading: false,
    backgroundColor: Colors.transparent, // Прозрачный фон, чтобы блюр был виден
    pinned: true,
    toolbarHeight: 62,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(bottom: Radius.circular(14)),
    ),
    expandedHeight: 100,
    centerTitle: true,
    titleSpacing: 0,

    title: ClipRRect(
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(14)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          color: kBgColor.withOpacity(0.8), // Фон с прозрачностью
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              key: ValueKey<bool>(opacity == 1.0),
              child: Row(
                mainAxisAlignment: opacity != 1.0
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.spaceBetween, // Библиотека слева, кнопки справа
                crossAxisAlignment: CrossAxisAlignment.center, // Центрирование по вертикали
                children: [
                  if (back) ...[IconButton(onPressed: (){ Navigator.pop(childctx); }, icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.white, size: 34,)), Expanded(child: Container())],
                  Text(
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: opacity != 1.0 ? 30 : 20,
                    ),
                  ),
                  if (back) ...[Expanded(child: Container())],
                  if (opacity != 0.0 && back) ... [
                    Container(width: 34,)
                  ],
                  if (opacity == 1.0) ...[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center, // Центрирование по вертикали
                      children: [
                        IconButton(
                          onPressed: hie,
                          icon: const Icon(
                            Icons.search_rounded,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 16), // Отступ между кнопками
                        Container(
                          alignment: Alignment.topRight,
                          margin: const EdgeInsets.only(top: 0),
                          child: IconButton(
                            onPressed: useri
                                ? () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProfileScreen(
                                    reseti: resdf,
                                  ),
                                ),
                              );
                            }
                                : showlog,
                            icon: imgprofile != ""
                                ? SizedBox(
                              height: 44,
                              width: 44,
                              child: CachedNetworkImage(
                                imageUrl: imgprofile, // Replace with your image URL
                                imageBuilder: (context, imageProvider) => Container(
                                  margin: const EdgeInsets.only(right: 3, top: 3),
                                  width: 100.0, // Set the width of the circular image
                                  height: 100.0, // Set the height of the circular image
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover, // Adjusts the image inside the circle
                                    ),
                                  ),
                                ),
                                placeholder: (context, url) =>
                                const CircularProgressIndicator(), // Placeholder while loading
                                errorWidget: (context, url, error) =>
                                const Icon(Icons.error), // Error icon if image fails to load
                              ),
                            )
                                : buttonlogin(showlog),
                          ),
                        ),
                      ],
                    ),
                  ],
                  
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}



Widget standatbuild(List<Widget> widgets, double opacity, String imgprofile, VoidCallback showlog, BuildContext context, bool useri, VoidCallback hie, VoidCallback resdf, String name, ScrollController _controller, ScrollController _childController, bool _isAtTop, StateSetter setState, double _previousOffset, bool back, BuildContext childctx,) {
  return Scaffold(
    backgroundColor: kBgColor,
    body: NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification is ScrollUpdateNotification) {
          // Проверяем направление скроллинга в родительском ListView
          if (scrollNotification.metrics.axisDirection == AxisDirection.down) {
            return false; // Пропускаем вниз
          }

          if (_controller.offset < 0) {
            _controller.jumpTo(0); // Фиксируем родительский скроллинг
          }
        }
        return false;
      },
      child: CustomScrollView(
        physics: _isAtTop ? const ClampingScrollPhysics() : null,
        controller: _controller,
        slivers: [
          headerwithblast(imgprofile, showlog, context, useri, hie, resdf),
          headerfast(opacity, imgprofile, showlog, context, useri, hie, resdf, name, back, childctx),


          SliverToBoxAdapter(
            child: NotificationListener<ScrollNotification>(
              onNotification: (scrollNotification) {
                if (scrollNotification is ScrollUpdateNotification) {
                  // Определяем направление скроллинга
                  if (_childController.hasClients) {
                    final currentOffset = scrollNotification.metrics.pixels;

                    if (currentOffset > _previousOffset) {
                      // Скролл вниз
                      print('Scrolling Down');
                      setState(() {
                        _isAtTop = _childController.offset <= 0 || _controller.offset <= 0 ;
                      });

                    } else if (currentOffset < _previousOffset) {
                      // Скролл вверх
                      print('Scrolling Up');
                      if (currentOffset <= 0) {
                        setState(() {
                          _isAtTop = false;
                        });
                      }
                    }
                    _previousOffset = currentOffset; // Обновляем позицию
                  }
                }
                return false;
              },
              child: ListView(
                padding: EdgeInsets.only(left: 10, right: 10),
                controller: _childController,
                shrinkWrap: true,
                // physics: _isAtTop ? const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics(),) : const BouncingScrollPhysics(),
                children: widgets,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget standatbuildtavview(
    List<Widget> widgets,
    double opacity,
    String imgprofile,
    VoidCallback showlog,
    BuildContext context,
    bool useri,
    VoidCallback hie,
    VoidCallback resdf,
    String name,
    ScrollController _controller,
    ScrollController _childController,
    bool _isAtTop,
    StateSetter setState,
    double _previousOffset,
    TabController _tabController,
    bool back,
    BuildContext childctx,
    ) {
  return Scaffold(
    backgroundColor: kBgColor,
    body: NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification is ScrollUpdateNotification) {
          // Проверяем направление скроллинга в родительском ListView
          if (scrollNotification.metrics.axisDirection == AxisDirection.down) {
            return false; // Пропускаем вниз
          }

          if (_controller.offset < 0) {
            _controller.jumpTo(0); // Фиксируем родительский скроллинг
          }
        }
        return false;
      },
      child: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: _isAtTop ? const ClampingScrollPhysics() : null,
          controller: _controller,
          slivers: [
            // Заголовки
            headerwithblast(imgprofile, showlog, context, useri, hie, resdf),
            headerfast(opacity, imgprofile, showlog, context, useri, hie, resdf, name, back, childctx),

            // Контент с TabBar и TabBarView
            SliverFillRemaining(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  // Вкладки
                  TabBar(
                    controller: _tabController,
                    tabs: const [
                      Tab(text: "История устройства"),
                      Tab(text: "История аккаунта"),
                    ],
                    labelColor: Colors.white,
                    indicatorColor: Colors.blue,
                  ),
                  // Содержимое
                  SizedBox(
                    height: 20*200,
                    child: TabBarView(
                      controller: _tabController,
                      children: widgets,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}


Widget listviewka_withwidget(String nameList, StateSetter setState, bool isDragging, bool isRefreshing, Function load, ScrollController _scrollController, Size size, Widget widget1, Widget widget2){
  return Consumer<ListManagerProvider>(
      builder: (context, listManager, child)
      {
        final list = listManager.getList(nameList); // Получить список из провайдера


        if (list.isEmpty) {
          return Center(child: Text('Нету треков', style: TextStyle(color: Colors.white, fontSize: 28),));
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
              itemCount: list.length+1,
              itemBuilder: (BuildContext context, int idx)
              {
                if (idx == 0) {
                  return widget1;
                }else{
                  return widget2;
                }
              },
            )
        );
      });
}

Widget listviewka(String nameList, StateSetter setState, bool isDragging, bool isRefreshing, Function load, ScrollController _scrollController, Size size, Widget widget1){
  return Consumer<ListManagerProvider>(
      builder: (context, listManager, child)
      {
        final list = listManager.getList(nameList); // Получить список из провайдера


        if (list.isEmpty) {
          return Center(child: Text('Нету треков', style: TextStyle(color: Colors.white, fontSize: 28),));
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
              itemCount: list.length,
              itemBuilder: (BuildContext context, int idx)
              {
                  return widget1;

              },
            )
        );
      });
}