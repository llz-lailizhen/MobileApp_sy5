//@dart=2.9
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_ml_kit_example/TextRecognize.dart';
import 'package:google_ml_kit_example/VideoBackGround/VideoBackGround.dart';
import 'package:google_ml_kit_example/handTextRecognize.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'First/tiktok.dart';
import 'Login/loginPageView.dart';
import 'nlp_detector_views/entity_extraction_view.dart';
import 'nlp_detector_views/language_identifier_view.dart';
import 'nlp_detector_views/language_translator_view.dart';
import 'nlp_detector_views/smart_reply_view.dart';
import 'recognizer_screen.dart';
import 'splashView.dart';
import 'package:get/get.dart';
import 'vision_detector_views/barcode_scanner_view.dart';
import 'vision_detector_views/digital_ink_recognizer_view.dart';
import 'vision_detector_views/face_detector_view.dart';
import 'vision_detector_views/label_detector_view.dart';
import 'vision_detector_views/object_detector_view.dart';
import 'vision_detector_views/pose_detector_view.dart';
import 'vision_detector_views/selfie_segmenter_view.dart';
import 'vision_detector_views/text_detector_view.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  cameras = await availableCameras();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/', // 默认加载的界面，这里为RootPage
      routes: {
        'main':(context) =>Home(),
        'login':(context) =>LoginView(),
      },
      home: SplashView(),
      builder: EasyLoading.init(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentIndex = 0;
  String name = '';
  String year,month,day;
  String sex;
  String title = '主页面';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserInfo();
  }
  void getUserInfo() async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    name = sp.getString('userName');
    year = sp.getString('year');
    month = sp.getString('month');
    day = sp.getString('day');
    sex = sp.getString('sex');
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(title),
        //左侧菜单
        automaticallyImplyLeading: false, //设置没有返回按钮
        //右侧更多
      ),
      body: SafeArea(
          child: Stack(
            children: [
              buildWidget(),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 60,width: Get.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(child: Column(
                        children: [
                          Icon(Icons.home,size: 30,),
                          Text('主页面')
                        ],
                      ),onTap: (){
                        currentIndex = 0;
                        title = '主页面';
                        setState(() {});
                      },),
                      InkWell(child: Column(
                        children: [
                          Icon(Icons.accessibility_sharp,size: 30,),
                          Text('识别demo')
                        ],
                      ),onTap: (){
                        currentIndex = 1;
                        title = '识别demo';
                        setState(() {});
                      },),
                      InkWell(child: Column(
                        children: [
                          Icon(Icons.send,size: 30,),
                          Text('语言分析')
                        ],
                      ),onTap: (){
                        currentIndex = 2;
                        title = '语言分析';
                        setState(() {});
                      },),
                      InkWell(child: Column(
                        children: [
                          Icon(Icons.person,size: 30,),
                          Text('我的')
                        ],
                      ),onTap: (){
                        currentIndex = 3;
                        title = '我的';
                        setState(() {});
                      },),
                    ],
                  ),
                ),
              )
            ],
          )
      ),
    );
  }
  Widget buildWidget(){
    if(currentIndex==0){
      return SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(bottom: 50,left: 20,right: 20),
          child: Column(
            children: [
              ExpansionTile(
                initiallyExpanded:true,
                title: Text(title),
                children: [
                  CustomCard('视频去水印', TikTok()),
                  CustomCard('视频换背景', VideoBackGround()),
                  CustomCard('手写数字识别', RecognizerScreen()),
                  CustomCard('通用文字识别', TextRecognize()),
                  CustomCard('手写文字识别', handTextRecognize()),
                ],
              ),
            ],
          ),
        ),
      );
    }
    else if(currentIndex==1){
      return SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(bottom: 50,left: 20,right: 20),
          child: Column(
            children: [
              ExpansionTile(
                initiallyExpanded:true,
                title: Text(title),
                children: [
                  CustomCard('条形码扫描', BarcodeScannerView()),
                  CustomCard('面部识别', FaceDetectorView()),
                  CustomCard('物体识别', ObjectDetectorView()),
                  CustomCard('文字识别', TextRecognizerView()),
                  CustomCard('骨骼识别', PoseDetectorView()),
                  CustomCard('视频背景', SelfieSegmenterView()),
                ],
              ),
            ],
          ),
        ),
      );
    }
    else if(currentIndex==2){
      return Container(
        margin: EdgeInsets.only(bottom: 50,left: 20,right: 20),
        child: ExpansionTile(
          initiallyExpanded:true,
          title: Text(title),
          children: [
            CustomCard('语言类别分析', LanguageIdentifierView()),
            CustomCard('On-device Translation', LanguageTranslatorView()),
            CustomCard('Smart Reply', SmartReplyView()),
            CustomCard('Entity Extraction', EntityExtractionView()),
          ],
        ),
      );
    }
    else{
      return SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(bottom: 50,left: 20,right: 20),
          child: Column(
            children: [
              SizedBox(height: 50,),
              Container(height: 100,child: Center(
                child: ClipOval(
                  child: FlutterLogo(size: 160,),
                ),
              ),),
              SizedBox(height: 50,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('用户名',style: TextStyle(fontSize: 20),),
                  Text(name,style: TextStyle(fontSize: 20),)
                ],
              ),
              SizedBox(height: 50,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('生日',style: TextStyle(fontSize: 20),),
                  Text('$year/$month/$day',style: TextStyle(fontSize: 20),)
                ],
              ),
              SizedBox(height: 50,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('性别',style: TextStyle(fontSize: 20),),
                  sex=="1"?Text('男',style: TextStyle(fontSize: 20),):Text('女',style: TextStyle(fontSize: 20),)
                ],
              )
            ],
          ),
        ),
      );
    }
  }
}

class CustomCard extends StatelessWidget {
  final String _label;
  final Widget _viewPage;
  final bool featureCompleted;

  const CustomCard(this._label, this._viewPage, {this.featureCompleted = true});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.only(bottom: 10),
      child: ListTile(
        tileColor: Theme.of(context).primaryColor,
        title: Text(
          _label,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        onTap: () {
          if (!featureCompleted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content:
                    const Text('This feature has not been implemented yet')));
          } else {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => _viewPage));
          }
        },
      ),
    );
  }
}
