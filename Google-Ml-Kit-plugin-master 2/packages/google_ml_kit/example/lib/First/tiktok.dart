import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class TikTok extends StatefulWidget {
  const TikTok({Key? key}) : super(key: key);

  @override
  State<TikTok> createState() => _TikTokState();
}

class _TikTokState extends State<TikTok> {
  String videoUrl = '';
  TextEditingController controller = TextEditingController();
  VideoPlayerController? videoPlayerController;
  bool? isShowVide = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('视频去水印'),
          //左侧菜单
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back),
          ),
          //右侧更多
        ),
        body: WillPopScope(
          onWillPop: () async{
            if(videoPlayerController!=null){
              isShowVide = false;
              setState(() {});
              videoPlayerController?.dispose();
              return true;
            }
            else{
              Navigator.pop(context);
              return true;
            }
          },
          child: Scaffold(
            body: ListView(
              padding: EdgeInsets.only(left: 20,right: 20,top: 50),
              children: [
              TextFormField(
                maxLength: 100,
                decoration: InputDecoration(
                    labelText: '要去水印的视频链接',
                    labelStyle: TextStyle(color: Colors.black, fontSize: 18)),
                onChanged: (v){
                  videoUrl = v;
                },
              ),
                ElevatedButton(onPressed: (){
                  getVideo(videoUrl);
                }, child: Text('去水印')),
                SizedBox(height: 30,),
                TextFormField(
                  enabled: false,
                  controller: controller,
                  maxLength: 1000,
                  decoration: InputDecoration(
                      labelText: '已去水印的链接',
                      labelStyle: TextStyle(color: Colors.black, fontSize: 18)),
                ),
            isShowVide!?AspectRatio(
              aspectRatio: videoPlayerController?.value.aspectRatio??0.0,
              child: VideoPlayer(videoPlayerController!),
            ):Container()
            ],
            )
          ),
        ),
      ),
    );
  }
  void getVideo(String url) async{
    final int index = url.indexOf('https');
    url = url.substring(index,index+29);
    Response response;
    final dio = Dio();
    response = await dio.get('https://api.23bt.cn/api/dsp/index', queryParameters: {'key': 'p4nO8xtFGDwwKsfo590cEXceHm','url': url});
    controller.text = response.data['url'];//处理好的视频链接
    String videoUrl = response.data['url'];
    videoUrl = videoUrl.replaceFirst('http', 'https');//替换https
    videoPlayerController = VideoPlayerController.network(
        videoUrl)
      ..initialize().then((_) {
        isShowVide = true;
        videoPlayerController?.play();
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
    setState(() {});
    print(response.data['url']);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
