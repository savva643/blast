import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/list_manager_provider.dart';
import '../screens/profile_screen.dart';
import 'buttons.dart';

// Добавьте в начало файла headers.dart
enum DeviceType { phone, tablet, carAudio, pc, tv }

DeviceType getDeviceType(BuildContext context) {
  final size = MediaQuery.of(context).size;
  final isTablet = size.width >= 600;
  final isCarAudio = size.width >= 600 && size.height <= 400; // Примерные параметры для магнитолы

  // Для тестирования - всегда считаем устройство планшетом/магнитолой
  // В реальном приложении замените на:
  // return isCarAudio ? DeviceType.carAudio : (isTablet ? DeviceType.tablet : DeviceType.phone);
  return DeviceType.tablet;
}

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
                          context) => ProfileScreen(reseti: resdf,), settings: const RouteSettings(name: '/profile')));
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

Widget carAudioHeader(
    String imgprofile,
    VoidCallback showlog,
    BuildContext context,
    bool useri,
    VoidCallback resdf,
    double opacity,
    String name,
    bool back,
    ) {
  final bool isTablet = MediaQuery.of(context).size.width >= 600;

  return SliverAppBar(
    backgroundColor: Colors.transparent,
    pinned: true,
    expandedHeight: isTablet ? 140 : 100,
    toolbarHeight: isTablet ? 80 : 60,
    centerTitle: true,
    title: AnimatedOpacity(
      opacity: opacity,
      duration: const Duration(milliseconds: 200),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(
          name,
          style: TextStyle(
            fontSize: isTablet ? 28 : 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    ),
    leading: back ? IconButton(
      icon: Icon(Icons.arrow_back, size: isTablet ? 36 : 30, color: Colors.white),
      onPressed: () => Navigator.pop(context),
    ) : null,
    actions: [
      Padding(
        padding: const EdgeInsets.only(right: 12.0),
        child: GestureDetector(
          onTap: useri
              ? () => Navigator.push(context, MaterialPageRoute(
              builder: (context) => ProfileScreen(reseti: resdf),
              settings: const RouteSettings(name: '/profile')))
              : showlog,
          child: Container(
            width: isTablet ? 60 : 48,
            height: isTablet ? 60 : 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: ClipOval(
              child: imgprofile.isNotEmpty
                  ? CachedNetworkImage(
                imageUrl: imgprofile,
                fit: BoxFit.cover,
                placeholder: (context, url) => Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                ),
                errorWidget: (context, url, error) => Icon(
                  Icons.person,
                  size: isTablet ? 32 : 24,
                  color: Colors.white,
                ),
              )
                  : Icon(
                Icons.person,
                size: isTablet ? 32 : 24,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    ],
    flexibleSpace: FlexibleSpaceBar(
      background: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.8),
              Colors.transparent,
            ],
          ),
        ),
      ),
    ),
  );
}

Widget carAudioScaffold({
  required List<Widget> widgets,
  required String imgprofile,
  required VoidCallback showlog,
  required BuildContext context,
  required bool useri,
  required VoidCallback resdf,
  required String name,
  required bool back,
  required VoidCallback load,
  Widget? bottomPlayer,
}) {
  final size = MediaQuery.of(context).size;
  final bool isTablet = size.width >= 600;

  return Scaffold(
    backgroundColor: Colors.black,
    body: Stack(
      children: [
        // Фоновое изображение
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/car_bg.jpg'),
                fit: BoxFit.cover,
                opacity: 0.3,
              ),
            ),
          ),
        ),

        // Основной контент
        CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            carAudioHeader(imgprofile, showlog, context, useri, resdf, 1.0, name, back),

            SliverPadding(
              padding: EdgeInsets.all(isTablet ? 20 : 12),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isTablet ? 4 : 2,
                  crossAxisSpacing: isTablet ? 20 : 12,
                  mainAxisSpacing: isTablet ? 20 : 12,
                  childAspectRatio: isTablet ? 1.3 : 1.1,
                ),
                delegate: SliverChildBuilderDelegate(
                      (context, index) => widgets[index],
                  childCount: widgets.length,
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: SizedBox(height: bottomPlayer != null ? (isTablet ? 120 : 80) : 20),
            ),
          ],
        ),

        // Кнопка обновления вверху
        Positioned(
          top: isTablet ? 30 : 15,
          right: isTablet ? 30 : 15,
          child: GestureDetector(
            onTap: load,
            child: Container(
              padding: EdgeInsets.all(isTablet ? 12 : 8),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.7),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.refresh,
                size: isTablet ? 32 : 24,
                color: Colors.white,
              ),
            ),
          ),
        ),

        // Плеер внизу (если есть)
        if (bottomPlayer != null)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: bottomPlayer,
          ),
      ],
    ),
  );
}

Widget carAudioButton({
  required String text,
  required IconData icon,
  required VoidCallback onPressed,
  required BuildContext context,
  Color? color,
}) {
  final isTablet = MediaQuery.of(context).size.width >= 600;

  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: color ?? Colors.blue.withOpacity(0.8),
      padding: EdgeInsets.all(isTablet ? 20 : 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: isTablet ? 36 : 24,
          color: Colors.white,
        ),
        SizedBox(height: isTablet ? 12 : 6),
        Text(
          text,
          style: TextStyle(
            fontSize: isTablet ? 18 : 14,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}

Widget carAudioList({
  required List<Widget> items,
  required ScrollController controller,
}) {
  return ListView.builder(
    controller: controller,
    physics: const BouncingScrollPhysics(),
    padding: const EdgeInsets.all(12),
    itemCount: items.length,
    itemBuilder: (context, index) {
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.grey[900]!.withOpacity(0.6),
          borderRadius: BorderRadius.circular(12),
        ),
        child: items[index],
      );
    },
  );
}


Widget headerwithblastwihoutSilver(String imgprofile, VoidCallback showlog, BuildContext context, bool useri, VoidCallback hie, VoidCallback resdf) {
  return Stack(
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
                          context) => ProfileScreen(reseti: resdf,), settings: const RouteSettings(name: '/profile')));
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
  );
}

const kBgColor = Color.fromARGB(255, 15, 15, 16);

Widget headerfast(double opacity, String imgprofile, VoidCallback showlog, BuildContext context, bool useri, VoidCallback hie, VoidCallback resdf, String name, bool back, BuildContext childctx, bool notshowbackinpc){
  Size size = MediaQuery.of(context).size;
  return SliverAppBar(
    automaticallyImplyLeading: false,
    backgroundColor: Colors.transparent,
    pinned: true,
    toolbarHeight: 62,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(bottom: Radius.circular(14)),
    ),
    expandedHeight: 100,
    centerTitle: true,
    titleSpacing: 0,
    title: AnimatedOpacity(
      opacity: notshowbackinpc && opacity != 1.0 && size.width > 600 ? 0 : 1,
      duration: const Duration(milliseconds: 300),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(14)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            color: kBgColor.withOpacity(0.8),
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
                      : size.width > 800 ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (back) ...[IconButton(onPressed: (){ Navigator.pop(childctx); }, icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.white, size: 34,)), Expanded(child: Container())],
                    if (opacity == 1.0 && size.width <= 800 ) ...[
                      Container(width: 34,)
                    ],
                    Container(
                        alignment: Alignment.center,
                        height: 72,
                        child: Text(
                          name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'Montserrat',
                            fontSize: opacity != 1.0 ? 30 : 20,
                          ),
                        )
                    ),
                    if (back) ...[Expanded(child: Container())],
                    if (opacity == 0.0 && back) ... [
                      Opacity(opacity: 0, child: IconButton(onPressed: (){ }, icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.white, size: 34,)),)
                    ],
                    if (opacity == 1.0 && size.width <= 800 ) ...[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: hie,
                            icon: const Icon(
                              Icons.search_rounded,
                              size: 40,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 16),
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
                                      settings: const RouteSettings(name: '/profile')
                                  ),
                                );
                              }
                                  : showlog,
                              icon: imgprofile != ""
                                  ? SizedBox(
                                height: 44,
                                width: 44,
                                child: CachedNetworkImage(
                                  imageUrl: imgprofile,
                                  imageBuilder: (context, imageProvider) => Container(
                                    margin: const EdgeInsets.only(right: 3, top: 3),
                                    width: 100.0,
                                    height: 100.0,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
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
    ),
  );
}






Widget standatbuild(List<Widget> widgets, double opacity, String imgprofile, VoidCallback showlog, BuildContext context, bool useri, VoidCallback hie, VoidCallback resdf, String name, ScrollController _controller, ScrollController _childController, bool _isAtTop, StateSetter setState, double _previousOffset, bool back, BuildContext childctx,
    VoidCallback load,
    Widget? beforewidgets
    ) {


  Size size = MediaQuery.of(context).size;

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
          if(size.width <= 800 ) headerwithblast(imgprofile, showlog, context, useri, hie, resdf),
          if(beforewidgets != null)
            SliverToBoxAdapter(
                child: beforewidgets),
          headerfast(opacity, imgprofile, showlog, context, useri, hie, resdf, name, back, childctx, false),

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


Widget standatbuildcustomlistview(
    Widget widgets,
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
    bool back,
    BuildContext childctx,
    VoidCallback load,
    Widget? beforewidgets,
    bool toTop,
    ) {
  final size = MediaQuery.of(context).size;
  final isMobile = size.width <= 800;
  bool _showRefreshButton = false;

  Widget buildContent() {
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification is ScrollUpdateNotification) {
          if (scrollNotification.metrics.axisDirection == AxisDirection.down) {
            return false;
          }
          if (_controller.offset < 0) {
            _controller.jumpTo(0);
          }
        }
        return false;
      },
      child: CustomScrollView(
        physics: _isAtTop ? const ClampingScrollPhysics() : null,
        controller: _controller,
        slivers: [
          if (isMobile)
            carAudioHeader(imgprofile, showlog, context, useri, resdf, opacity, name, back),
          if (beforewidgets != null)
            SliverToBoxAdapter(child: beforewidgets),
          headerfast(opacity, imgprofile, showlog, context, useri, hie, resdf, name, back, childctx, false),
          if (size.width > 1200)
            widgets
          else if (size.width > 800)
            widgets
          else
            SliverToBoxAdapter(child: widgets),
        ],
      ),
    );
  }

  return Scaffold(
    backgroundColor: kBgColor,
    body: Stack(
      clipBehavior: Clip.none,

      children: [
        // Основной контент
        isMobile
            ? RefreshIndicator(
          displacement: 40,
          color: Colors.white,
          backgroundColor: Colors.black.withOpacity(0.7),
          strokeWidth: 2.5,
          triggerMode: RefreshIndicatorTriggerMode.anywhere,
          onRefresh: () async {
            load();
            await Future.delayed(Duration(seconds: 1));
          },
          child: buildContent(),
        )
            : buildContent(),

        // Для ПК: прозрачная область детектирования вверху
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 40, // Высота области детектирования
            child: MouseRegion(
              onEnter: (_) {
                setState(() => _showRefreshButton = true);
                print(_showRefreshButton.toString()+"344r53w");
              },
              onExit: (_) => setState(() => _showRefreshButton = false),
              child: Container(color: Colors.transparent),
            ),
          ),

        // Кнопка обновления для ПК
        AnimatedSlide(
          offset: _showRefreshButton ? Offset(0, 0) : Offset(0, -1),
          duration: Duration(milliseconds: 300),
          child: MouseRegion(
            onExit: (_) => setState(() => _showRefreshButton = false),
            child: Container(
              color: Colors.black.withOpacity(0),
              height: 60,
              child: Center(
                child: ElevatedButton(
                  onPressed: load,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  child: Text(
                    'Обновить',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget standatbuildcustomlistviewStack(
    Widget widgets,
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
    bool back,
    BuildContext childctx,
    VoidCallback load,
    Widget? beforewidgets,
    bool toTop,
    bool needSilverBox
    ) {
  final size = MediaQuery.of(context).size;
  final isMobile = size.width <= 800;
  bool _showRefreshButton = false;

  Widget buildContent() {
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification is ScrollUpdateNotification) {
          if (scrollNotification.metrics.axisDirection == AxisDirection.down) {
            return false;
          }
          if (_controller.offset < 0) {
            _controller.jumpTo(0);
          }
        }
        return false;
      },
      child: CustomScrollView(
        physics: _isAtTop ? const ClampingScrollPhysics() : null,
        controller: _controller,
        slivers: [
      SliverToBoxAdapter(child:
        Stack(children: [
          if (beforewidgets != null)
            beforewidgets,
          if (isMobile)
            headerwithblastwihoutSilver(imgprofile, showlog, context, useri, hie, resdf),
        ],)),

          headerfast(opacity, imgprofile, showlog, context, useri, hie, resdf, name, back, childctx, true),
          if (size.width > 1200 && !needSilverBox)
            widgets
          else if (size.width > 800 && !needSilverBox)
            widgets
          else
            SliverToBoxAdapter(child: widgets),
        ],
      ),
    );
  }

  return Scaffold(
    backgroundColor: kBgColor,
    body: Stack(
      clipBehavior: Clip.none,

      children: [
        // Основной контент
        isMobile
            ? RefreshIndicator(
          displacement: 40,
          color: Colors.white,
          backgroundColor: Colors.black.withOpacity(0.7),
          strokeWidth: 2.5,
          triggerMode: RefreshIndicatorTriggerMode.anywhere,
          onRefresh: () async {
            load();
            await Future.delayed(Duration(seconds: 1));
          },
          child: buildContent(),
        )
            : buildContent(),

        // Для ПК: прозрачная область детектирования вверху
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: 40, // Высота области детектирования
          child: MouseRegion(
            onEnter: (_) {
              setState(() => _showRefreshButton = true);
              print(_showRefreshButton.toString()+"344r53w");
            },
            onExit: (_) => setState(() => _showRefreshButton = false),
            child: Container(color: Colors.transparent),
          ),
        ),

        // Кнопка обновления для ПК
        AnimatedSlide(
          offset: _showRefreshButton ? Offset(0, 0) : Offset(0, -1),
          duration: Duration(milliseconds: 300),
          child: MouseRegion(
            onExit: (_) => setState(() => _showRefreshButton = false),
            child: Container(
              color: Colors.black.withOpacity(0),
              height: 60,
              child: Center(
                child: ElevatedButton(
                  onPressed: load,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  child: Text(
                    'Обновить',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
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
    double contentHeight,
    ) {
  Size size = MediaQuery.of(context).size;
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
            if(size.width <= 800 ) headerwithblast(imgprofile, showlog, context, useri, hie, resdf),
            headerfast(opacity, imgprofile, showlog, context, useri, hie, resdf, name, back, childctx, false),

            // Контент с TabBar и TabBarView
        SliverToBoxAdapter(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: "История устройства"),
                  Tab(text: "История аккаунта"),
                ],
                labelColor: Colors.white,
                indicatorColor: Colors.blue,
              ),
              SizedBox(
                height: contentHeight, // Можно попробовать убрать или сделать `null`
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