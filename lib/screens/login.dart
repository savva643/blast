import 'dart:async';
import 'dart:convert';
import 'dart:io';


import 'package:blast/screens/home_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;



const kBgColor = Color(0xFF1604E2);

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);
  @override
  State<LoginScreen> createState() => LoginScreenState();




}

class LoginScreenState extends State<LoginScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  var iconpla = Icon(Icons.play_arrow_rounded, size: 64, color: Colors.white,);
  void updateIcon(Icon newIcon) {
    setState(() {
      iconpla = newIcon;
    });
  }
  List _langData = [
    {
      'id': '1',
      'img': 'https://kompot.site/img/music.jpg',
      'name': 'Название',
      'message': 'Имполнитель',
    }
  ];


  LoginScreenState(){
  }

  @override
  void initState()
  {
    super.initState();
  }
  TextEditingController _login = TextEditingController();
  TextEditingController _pass = TextEditingController();
  
  String musicUrl = ""; // Insert your music URL
  String thumbnailImgUrl = "";
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
          child: Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    height: 80,width: 220,
                    child: OverflowBox(
                      maxWidth: double.infinity,
                      maxHeight: double.infinity,
                      child:
                      Container(
                        padding: EdgeInsets.only(top: 140),
                        child:
                        Image.asset('assets/images/kol.png',width: 220, height: 220, fit: BoxFit.cover,),),
                    ),),
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
                    Container(alignment: Alignment.topRight, margin: EdgeInsets.only(top: 18), child: IconButton(onPressed: () { Navigator.pop(context); }, icon: Icon(Icons.close_rounded, size: 46, color: Colors.white,)),)
                  ],),
                ],),
              Container(margin: EdgeInsets.only(top: 0),
                child:
                Stack(alignment: Alignment.center,
                  children: [
                    Container(width: size.width, height: size.height-214, child: Container(margin: EdgeInsets.only(left: 16,right: 16), decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(25)), color: Color.fromARGB(173, 75, 75, 75)), child: Container(margin: EdgeInsets.only(left: 12,right: 12), child: Column(children: [
                      SizedBox(height: 10,),
                      TextFormField(
                      controller: _login,
                      onChanged: (text) {},
                      cursorColor: const Color.fromARGB(255, 141, 141, 141),
                      style: const TextStyle(
                          fontSize: 14,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w400,
                          color: Color.fromARGB(255, 246, 244, 244)
                      ),
                      decoration: InputDecoration(
                        label: Text("Логин", style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w400,
                            color: Colors.white60
                        ),),
                        filled: true,
                        fillColor: Color.fromARGB(255, 15, 15, 16),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(width: 2, color: Color.fromARGB(255, 246, 244, 244)),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusColor: Color.fromARGB(255, 15, 15, 16),
                        enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(width: 2, color: Color.fromARGB(255, 141, 141, 141)),
                            borderRadius: BorderRadius.circular(15)),
                        contentPadding: const EdgeInsets.only(top: 2,bottom: 2, right: 0,left: 12),

                        suffixIconConstraints: const BoxConstraints(maxHeight: 23),
                      ),
                    ),SizedBox(height: 10,),
                      TextFormField(
                      controller: _pass,
                      onChanged: (text) {},
                      cursorColor: const Color.fromARGB(255, 141, 141, 141),

                      style: const TextStyle(
                          fontSize: 14,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w400,
                          color: Colors.white
                      ),
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(width: 2, color: Color.fromARGB(255, 246, 244, 244)),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        label: Text("Пароль", style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w400,
                            color: Colors.white60
                        ),),
                        fillColor: Color.fromARGB(255, 15, 15, 16),
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(width: 2, color: Color.fromARGB(255, 141, 141, 141)),
                            borderRadius: BorderRadius.circular(15)),
                        contentPadding: const EdgeInsets.only(top: 2,bottom: 2, right: 0,left: 12),

                        suffixIcon:  SizedBox( width: 36, height: 36, child: OverflowBox(alignment: Alignment.centerRight,minHeight:36, maxHeight:36, child: IconButton(icon:  Icon(Icons.visibility, color: Colors.white,), onPressed: () {  },),)),

                        suffixIconConstraints: const BoxConstraints(maxHeight: 23),

                      ),
                    ),SizedBox(height: 10,),
                      Container(width: size.width, height: 50, child: TextButton(style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Color.fromARGB(255, 15, 15, 16)), shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))))),  onPressed: (){login();}, child: Text("Войти", style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w700,
                          color: Colors.white
                      ),)),)
                    ],)),),
                    )
                  ],),),

            ],
          ),
        ),

      ),
    );
  }




  @override
  void dispose() {
    super.dispose();
  }


  void login(){
    postRequest(_login.text, _pass.text);
  }

  Future<void> postRequest (String text, String text2) async {
    if(text != '' && text2 != '') {
      var urli = Uri.parse(
          "https://kompot.site/anlog?login="+text+"&password=" + text2);

      var response = await http.get(urli);
      String dff = response.body.toString();

      setState(() async {
        _langData[0] = jsonDecode(dff);
        print(_langData[0]);
        if(_langData[0]['status'] == "true"){
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString("token", _langData[0]['token']);
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
                (Route<dynamic> route) => false, // Удаление всех предыдущих маршрутов
          );
        }
      });
    }else{

    }
  }




}




