import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_screen.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> getlatloc() async {
    final prefs = await SharedPreferences.getInstance();

    final tk = prefs.getString('token') ?? "0";
    if(tk != "0"){
      Navigator.pushReplacement(context, PageRouteBuilder(pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation)  => const HomeScreen(), transitionDuration: const Duration(seconds: 0),));
    }else{
      Navigator.pushReplacement(context, PageRouteBuilder(pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation)  => const HomeScreen(), transitionDuration: const Duration(seconds: 0),));
    }
  }

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3), () {
      getlatloc();
    });
    //
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return
      Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(255, 15, 15, 16),
            Color.fromARGB(255, 15, 15, 16),
          ],
        ),
      ),
      child: SafeArea(child: Scaffold(
        //Make sure you make the scaffold background transparent
        backgroundColor: Colors.transparent,
        body: Stack(children: [
          Image.asset('assets/images/kol.png', width: 220, height: 220,),
          Container(padding: EdgeInsets.only(left: 12,top: 12),
              child:
          Text("blast!",
            style: TextStyle(
            fontSize: 40,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),)),
        ],),
      ),),
    );
  }
}
