import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:google_ml_kit_example/Login/MyRadioOption.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  _LoginViewPageState createState() => _LoginViewPageState();
}

class _LoginViewPageState extends State<LoginView> {
  final GlobalKey _formKey = GlobalKey<FormState>();
  late String _userName, _password;
  bool _isObscure = true;
  Color _eyeColor = Colors.grey;
  int? _year,_month,_day;
  String? _groupValue;
  bool? isLogin;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _year = 1970;
    _month = 01;
    _day = 01;
    isLogin = false;
    _userName = '';
    _password = '';
    checkLoginOrRegister();
  }
  void checkLoginOrRegister()async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    String? userName = sp.getString('userName');
    if(userName==null){
      isLogin = false;
    }
    else{
      isLogin = true;
      Navigator.pushNamed(context, "main");
    }
    setState(() {});
  }
  ValueChanged<String?> _valueChangedHandler() {
    return (value) => setState(() => _groupValue = value!);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey, // 设置globalKey，用于后面获取FormStat
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            SizedBox(height: kToolbarHeight), // 距离顶部一个工具栏的高度
            buildTitle(), // Login
            buildTitleLine(), // Login下面的下划线
            SizedBox(height: 60),
            buildUserNameTextField(), // 输入邮箱
            SizedBox(height: 30),
            buildPasswordTextField(context), // 输入密码
            Visibility(visible: !isLogin!,child: SizedBox(height: 10),),
            Visibility(visible: !isLogin!,child: buildBirthdayTextField(context)),
            Visibility(visible: !isLogin!,child: buildSex()),
            Visibility(visible: true,child: SizedBox(height: 40)),
            buildLoginButton(context), // 登录按钮
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }




  Widget buildLoginButton(BuildContext context) {
    return Align(
      child: SizedBox(
        height: 45,
        width: 270,
        child: ElevatedButton(
          style: ButtonStyle(
            // 设置圆角
              shape: MaterialStateProperty.all(StadiumBorder(
                  side: BorderSide(style: BorderStyle.none)))),
          child: Text(isLogin!?'Login':'Register',
              style: Theme.of(context).primaryTextTheme.headline5),
          onPressed: () async{
            if(isLogin!){
              if(_userName!= '' && _password!= ''){
                SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                String? userName = sharedPreferences.getString("userName");
                String? password = sharedPreferences.getString("passWord");
                if(_userName==_userName&&_password==password){
                  Navigator.pushNamed(context, "main");
                }
                else{
                  Fluttertoast.showToast(
                      msg: '用户名或密码错误',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0
                  );
                }
              }
              else{
                Fluttertoast.showToast(
                    msg: '请输入用户名和密码',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0
                );
              }
            }
            else{
              if(_userName!= '' && _password!= ''){
                SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                sharedPreferences.setString('userName', _userName);
                sharedPreferences.setString('passWord', _password);
                sharedPreferences.setString('year', _year.toString());
                sharedPreferences.setString('month', _month.toString());
                sharedPreferences.setString('day', _day.toString());
                sharedPreferences.setString('sex', _groupValue!);
                Navigator.pushNamed(context, "main");
              }
              else{
                Fluttertoast.showToast(
                    msg: '请输入用户名和密码',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0
                );
              }
            }
          },
        ),
      ),
    );
  }


  Widget buildPasswordTextField(BuildContext context) {
    return TextFormField(
        maxLength: 20,
        inputFormatters: [
          FilteringTextInputFormatter(RegExp('[0-9.]'), allow: true),
        ],
        obscureText: _isObscure, // 是否显示文字
        onChanged: (v) => _password = v,
        validator: (v) {
          if (v!.isEmpty) {
            return '请输入密码';
          }
        },
        decoration: InputDecoration(
            labelStyle: TextStyle(color: Colors.black,fontSize: 18),
            labelText: '密码',
            suffixIcon: IconButton(
              icon: Icon(
                Icons.remove_red_eye,
                color: _eyeColor,
              ),
              onPressed: () {
                // 修改 state 内部变量, 且需要界面内容更新, 需要使用 setState()
                setState(() {
                  _isObscure = !_isObscure;
                  _eyeColor = (_isObscure
                      ? Colors.black
                      : Theme.of(context).iconTheme.color)!;
                });
              },
            )));
  }

  Widget buildSex(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('性别',style: TextStyle(fontSize: 18),),
        Container(
          child: Row(
            children: [
              MyRadioOption<String>(
                value: '1',
                groupValue: _groupValue,
                onChanged: _valueChangedHandler(),
                label: '1',
                text: '男',
              ),
              MyRadioOption<String>(
                value: '2',
                groupValue: _groupValue,
                onChanged: _valueChangedHandler(),
                label: '2',
                text: '女',
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget buildBirthdayTextField(BuildContext context) {
    return InkWell(
      child: Container(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('生日',style: TextStyle(fontSize: 18,color: Colors.black),),
            Text('$_year/$_month/$_day')
          ],
        ),
      ),
      onTap: (){
        DatePicker.showDatePicker(context,
            showTitleActions: true,
            minTime: DateTime(1995, 1, 1),
            maxTime: DateTime(2022, 1, 1), onChanged: (date) {
            }, onConfirm: (date) {
              _year = date.year;
              _month = date.month;
              _day = date.day;
              setState(() {});
              print(date.year);
              print(date.month);
              print(date.day);
            }, currentTime: DateTime.now(), locale: LocaleType.zh);
      },
    );
  }

  Widget buildUserNameTextField() {
    return TextFormField(
      maxLength: 20,
      decoration: const InputDecoration(labelText: '用户名',labelStyle: TextStyle(color: Colors.black,fontSize: 18)),
      onChanged: (v) => _userName = v!,
    );
  }

  Widget buildTitleLine() {
    return Padding(
        padding: const EdgeInsets.only(left: 12.0, top: 4.0),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Container(
            color: Colors.black,
            width: 40,
            height: 2,
          ),
        ));
  }

  Widget buildTitle() {
    return Padding(
        padding: EdgeInsets.all(8),
        child: isLogin!?Text(
          '登陆',
          style: TextStyle(fontSize: 42),
        ):Text(
          '注册',
          style: TextStyle(fontSize: 42),
        ));
  }
}