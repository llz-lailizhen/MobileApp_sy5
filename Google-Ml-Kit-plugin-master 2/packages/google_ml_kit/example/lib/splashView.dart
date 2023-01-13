import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 2),(){
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
              child: Center(
                child: Image.asset('assets/images/img.png',fit: BoxFit.fitWidth,),
              )
          ),
          Align(alignment: Alignment(0,0.7),child: Container(
            margin: EdgeInsets.only(left: 30,right: 30),
            width: Get.width,
            child: ElevatedButton(onPressed: (){
              Navigator.pushNamed(context, 'login');
            }, child: Text('进入')),
          ),)
        ],
      )
    );
  }
}
