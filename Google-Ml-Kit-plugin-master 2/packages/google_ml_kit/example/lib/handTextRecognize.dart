import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class handTextRecognize extends StatefulWidget {
  const handTextRecognize({Key? key}) : super(key: key);

  @override
  State<handTextRecognize> createState() => _handTextRecognizeState();
}

class _handTextRecognizeState extends State<handTextRecognize> {
  XFile? file;
  List<Map<String,dynamic>> data = [];
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('手写文字识别'),
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
        padding: EdgeInsets.only(left: 30,right: 30),
        children: [
          ElevatedButton(onPressed: () async{
            file = await ImagePicker().pickImage(source: ImageSource.gallery);
            setState(() {});
          }, child: Text('选择图片')),
          file!=null?Image.file(File(file?.path??'')):Container(),
          ElevatedButton(onPressed: () async{
            await imagetoBase64(file);
          }, child: Text('识别图片')),
          data.isNotEmpty?ListView.builder(itemBuilder: (context,index){
            return Text(data[index]["words"]);
          },itemCount: data.length,shrinkWrap: true,physics: NeverScrollableScrollPhysics(),):Container()
        ],
      ),
    ));
  }
  Future<String> imagetoBase64(XFile? file) async{
    Dio? _dio = Dio();
    _dio.options.contentType='application/x-www-form-urlencoded';
    _dio.options.responseType = ResponseType.json;
    String url ='https://aip.baidubce.com/rest/2.0/ocr/v1/handwriting?access_token=24.18ae9d7329d65f40a1327c501d242181.2592000.1674063660.282335-29169287%22';
    File _avataFile = File(file?.path??'');
    Uint8List  imageBytes = await _avataFile.readAsBytes();
    String base64 = base64Encode(imageBytes);
    String base64Image = "data:image/png;base64," + base64;
    String image = Uri.encodeFull(base64Image);
    Map map = {
      'image': image
    };
    Response? response = await _dio.post(url,data: map);
    print(response.data['words_result']);
    for(int i=0;i<response.data['words_result'].length;i++){
      data.add(response.data['words_result'][i]);
    }
    Clipboard.setData(ClipboardData(text:  data.toString()));
    Fluttertoast.showToast(msg: '已复制到剪切板');
    print(response.data['words_result']);
    setState(() {});
    return base64Image;
  }
}
