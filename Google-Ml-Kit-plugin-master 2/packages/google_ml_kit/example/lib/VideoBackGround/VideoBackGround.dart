import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

class VideoBackGround extends StatefulWidget {
  const VideoBackGround({Key? key}) : super(key: key);

  @override
  State<VideoBackGround> createState() => _VideoBackGroubndState();
}

class _VideoBackGroubndState extends State<VideoBackGround> {
  bool isShowVideo = false;
  late VideoPlayerController videoPlayerController;
  late VideoPlayerController selectPlayerController;
  String videoPath = '';
  String imagePath = '';
  final FijkPlayer player = FijkPlayer();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('视频换背景'),
        //左侧菜单
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        //右侧更多
      ),
      body: ListView(
        padding: EdgeInsets.only(left: 10,right: 10),
        children:[ElevatedButton(
          onPressed: () async{
            final ImagePicker _picker = ImagePicker();
            final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
            videoPath = video?.path??'';
            selectPlayerController = VideoPlayerController.file(File(videoPath))
              ..initialize().then((_) {
                selectPlayerController.play();
                setState(() {});
              });
            print(video?.path);
          },
          child: Text('选择视频'),
        ),videoPath!=''?Container(
            height: 200,
            child: AspectRatio(
              aspectRatio: selectPlayerController.value.aspectRatio,
              child: VideoPlayer(selectPlayerController),
            )
        ):Container(),
          ElevatedButton(
          onPressed: () async{
            final ImagePicker _picker = ImagePicker();
            final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
            imagePath = image?.path??'';
            print(image?.path);
            setState(() {});
          },
          child: Text('选择图片'),
        ),imagePath!=''?Container(
              child: Image.file(File(imagePath),
                height: 200,),
          ):Container(),
          ElevatedButton(
          onPressed: () async{
            uploadVideo();
          },
          child: Text('上传'),
        ),
          isShowVideo?Container(
            height: 200,
            child: AspectRatio(
              aspectRatio: videoPlayerController.value.aspectRatio,
              child: VideoPlayer(videoPlayerController),
            )
          ):Container(),
        ]
      ),
    ));
  }
  void uploadVideo() async{
    EasyLoading.show(status: 'loading');
    String url ='http://132.232.84.17';
    final FormData formData = FormData.fromMap({
      'file': [
        await MultipartFile.fromFile(videoPath,filename: 'input.mp4'),
      ],
      'bj': [
        await MultipartFile.fromFile(imagePath,filename: 'bj.jpg'),
      ]
    });
    final Response response = await Dio().post(url, data: formData);
    dioDownload(response.data);
    setState(() {});
    print(response.data);
  }
  Future dioDownload(String url) async {
    final Dio dio = Dio();
    Directory directory = await getTemporaryDirectory();
    String path = directory.path;
    Response response = await dio.download(
        url, path+"/test.avi", onReceiveProgress: (received, total) {
      if (total != -1) {
        print((received / total * 100).toStringAsFixed(0) + "%");
      }
    });
    File file = File(path+"/test.avi");
    videoPlayerController = VideoPlayerController.file(file)
      ..initialize().then((_) {
        isShowVideo = true;
        videoPlayerController.play();
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
    EasyLoading.dismiss();
  }
}
