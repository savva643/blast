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
import '../parts/buttons.dart';
import '../providers/list_manager_provider.dart';


const kBgColor = Color(0xFF1604E2);

class VideoScreen extends StatefulWidget {
  final  Function(dynamic) onCallback;
  final VoidCallback hie;
  final VoidCallback showlog;
  final VoidCallback dsad;
  const VideoScreen({Key? key, required this.onCallback, required this.hie, required this.showlog, required this.dsad}) : super(key: key);

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
        Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  child: Image.asset(
                    'assets/images/circlebg.png',
                    width: 420,
                    height: 420,
                  ),
                  top: -280,
                  left: -196,
                ),
          Row(children: [
            Container(padding: EdgeInsets.only(left: 12,top: 0),
                child:
                Text("blast!",
                  style: TextStyle(
                    fontSize: 40,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),)), Expanded(child: Container()),
            Container(alignment: Alignment.topRight, margin: EdgeInsets.only(top: 18), child: IconButton(onPressed: () {showsearch();}, icon: Icon(Icons.search_rounded, size: 40, color: Colors.white,)),),
            Container(alignment: Alignment.topRight, margin: EdgeInsets.only(top: 18), child: IconButton(onPressed: useri ? () { Navigator.push(context, MaterialPageRoute(builder: (context) =>  ProfileScreen(reseti:reseti))); } : showlog, icon: imgprofile!="" ? SizedBox(height: 44, width: 44, child: CachedNetworkImage(
              imageUrl: imgprofile, // Replace with your image URL
              imageBuilder: (context, imageProvider) => Container(
                margin: EdgeInsets.only(right: 3, top: 3),
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
              placeholder: (context, url) => CircularProgressIndicator(), // Placeholder while loading
              errorWidget: (context, url, error) => Icon(Icons.error), // Error icon if image fails to load
            )) : buttonlogin(showlog )),)
          ],),
          Container(padding: EdgeInsets.only(top: 80), height: size.height,
            child:size.width > 1200 ? _loadGridView() : size.width > 800 ? _loadGridView2() : _loadListView()
            ,),
        ],),


          ],
        ),
      ),

      ),
    );
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
          onCallback: (dynamic input) {onCallback(input);},
        );
      }),
    );
        });
  }

  Widget _loadGridView() {
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
        crossAxisCount: 4,
        mainAxisExtent: ((size.width/16)*3),
        crossAxisSpacing: 20,
        mainAxisSpacing: 10,
      ),
      children: List.generate(list.length, (idx) {
        return CustomTile(
          title: list[idx]['name'],
          subtitle: list[idx]['message'],
          imageUrl: list[idx]['imgvidos'],
          wih: size.width,
          urlo: list[idx]['idshaz'],
          onCallback: (dynamic input) {onCallback(input);},
        );
      }),
    );
        });
  }



  Widget _loadListView() {
    Size size = MediaQuery.of(context).size;
    return Container(height: size.height, child:
    Consumer<ListManagerProvider>(
        builder: (context, listManager, child)
    {
      final list = listManager.getList(
          'videosLast'); // Получить список из провайдера

      if (list.isEmpty) {
        return Center(child: Text('Нету видео'));
      }

      return ListView.builder(
      itemCount: list.length,
      itemBuilder: (BuildContext context, int idx)
      {
          return CustomTile(
            title: list[idx]['name'],
            subtitle: list[idx]['message'],
            imageUrl: list[idx]['imgvidos'],
            wih: size.width,
            urlo: list[idx]['idshaz'],
            onCallback: (dynamic input) {onCallback(input);},
          );
      },
    );
    })
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
  Function(dynamic) onCallback;
  CustomTile({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.wih,
    required this.urlo,
    required this.onCallback,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child:  Stack(children: [ Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [AspectRatio(aspectRatio: 16/9, child:
          CachedNetworkImage(
            imageUrl: imageUrl,
            imageBuilder: (context, imageProvider) =>
                Container(
                  padding: EdgeInsets.only(
                      left: 0, right: 0, bottom: 0, top: 0),
                  width: wih,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(18),
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.fitWidth),
                  ),
                ),
            placeholder: (context, url) =>
                CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),)
          ),
          SizedBox(height: 8),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                textAlign: TextAlign.start,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 246, 244, 244)
                ),
              ),
              Text(
                subtitle,
                textAlign: TextAlign.start,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w300,
                    color: Color.fromARGB(255, 246, 244, 244)
                ),
              ),],
          ),

          ],)

        ],
      ),SizedBox(height: ((size.width/16)*9)+40, width: size.width,  child: ElevatedButton(
        onPressed: () {
          onCallback(urlo);
        },

        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18), // Скругленные углы
          ),
          backgroundColor: Colors.transparent, // Прозрачный фон
          shadowColor: Colors.transparent, // Убираем тень
          elevation: 0, // Убираем эффект возвышенности
        ), child: Container(width: wih,),
      )),
        Container(alignment: Alignment.bottomCenter, child:
        Container(height: 62, child:
          Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Row(mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.end, children: [
          IconButton(

            icon: Icon(Icons.more_vert),
            color: Colors.white,
            onPressed: () {},
          )],)])))
      ],)
    );
  }


}



