import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:health_manage/components/mytextfield.dart';
import 'package:http/http.dart' as http;
import 'database/api.dart';
import 'file/file.dart';
import 'home_page.dart';


void main() {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  Welcome createState() => Welcome();
}

class Welcome extends State<MyApp> {
  int _timer = 1;

  @override
  void initState() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if(_timer > 0) {
          _timer = _timer - 1;
        }
      });
    });
    Timer(Duration(seconds: 1), () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black26,
        body: SafeArea(
          child: Container(
            constraints: BoxConstraints.expand(),
            decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage("welcome.JPG"),fit: BoxFit.cover)
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget> [
                SizedBox(
                  width: 420,
                  height: 550,
                ),
                Container(
                  height: 60,
                  width: 200,
                  margin: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(30),
                    color: Color.fromARGB(200, 0, 0, 0),
                  ),
                  child: Row(
                    children: [
                      Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromARGB(150, 255, 255, 255),
                          ),
                          width: 60,
                          height: 60,
                          child: Center(
                            child: Text('$_timer', style: TextStyle(color: Colors.white, fontSize: 22),),
                          )
                      ),
                      Container(
                          padding: EdgeInsets.only(left: 20),
                          child: Text("歡迎回來", style: TextStyle(color: Colors.white, fontSize: 18),)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}

class users_tojson{
  String account;
  String password;

  users_tojson(
      this.account,
      this.password,
      );
  Map<String, dynamic> toJson() =>
      {
        'account' : account,
        'password' : password,
      };
}

class Login extends StatefulWidget {
  @override
  LoginPage createState() => LoginPage();
}

class LoginPage extends State<Login> {

  final accountController = TextEditingController();
  final passwordController = TextEditingController();
  bool accounttext = false;
  bool passwordtext = false;

  login() async{
    users_tojson loginModel = users_tojson(
      accountController.text.trim(),
      passwordController.text.trim(),
    );

    final response = await http.post(
      Uri.parse(api.login),
      body: loginModel.toJson(),
    );

    if(response.statusCode == 200){
      if(response.body == "無此帳號") {
        Fluttertoast.showToast(msg: response.body);
      }
      else if(response.body == "密碼錯誤"){
        Fluttertoast.showToast(msg: response.body);
      }
      else {
        Fluttertoast.showToast(msg: "登入成功");

        file.getFile.then((value) async {
          file.saveToFile(response.body);
          String text = await file.readFromFile();
          print(text);
        });


        Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 50,),
              Text('Login',style: TextStyle(fontSize: 38),),
              SizedBox(height: 50,),
              MyTextField(
                controller: accountController,
                hintText: '帳號',
                obscureText: false,
                validate: accounttext,
                errortext: "帳號不得為空",
                TextInputType: TextInputType.text,
              ),
              SizedBox(height: 10,),
              MyTextField(
                controller: passwordController,
                hintText: '密碼',
                obscureText: true,
                validate: passwordtext,
                errortext: "密碼不得為空",
                TextInputType: TextInputType.text,
              ),
              SizedBox(height: 60,),
              MaterialButton(
                onPressed: () {
                  setState(() {
                    accountController.text.isEmpty? accounttext = true : accounttext = false;
                    passwordController.text.isEmpty? passwordtext = true : passwordtext = false;
                  });
                  if(accounttext != true && passwordtext != true)
                    login();
                    //Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
                },
                height: 48,
                padding: EdgeInsets.all(5),
                child: Text("登入", style: TextStyle(color: Colors.white,fontWeight:FontWeight.bold,fontSize: 16,),),
                textColor: Colors.white,
                color: Colors.teal,
                shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(8) ),
              ),
              SizedBox(height: 80,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        '還沒註冊?',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30,),
              MaterialButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Register()));
                },
                height: 48,
                padding: EdgeInsets.all(5),
                child: Text("註冊", style: TextStyle(color: Colors.white,fontWeight:FontWeight.bold,fontSize: 16,),),
                textColor: Colors.white,
                color: Colors.grey,
                shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(8) ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class Register extends StatefulWidget{
  @override
  RegisterPage createState() => RegisterPage();
}

class RegisterPage extends State<Register>{
  final accountController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordCheckController = TextEditingController();
  bool accounttext = false;
  bool passwordtext = false;
  bool passwordchecktext = false;

  register() async{
    users_tojson registerModel = users_tojson(
        accountController.text.trim(),
        passwordController.text.trim(),
    );

    final response = await http.post(
      Uri.parse(api.register),
      body: registerModel.toJson(),
    );

    if(response.statusCode == 200){
      if(response.body == "帳號重複") {
        Fluttertoast.showToast(msg: response.body);
      }
      else if(response.body == "註冊成功"){
        Fluttertoast.showToast(msg: response.body);
        Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
      }
      else{
        Fluttertoast.showToast(msg: "Error");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 50,),
              MyTextField(
                controller: accountController,
                hintText: "帳號",
                obscureText: false,
                validate: accounttext,
                errortext: "帳號不得為空",
                TextInputType: TextInputType.text,
              ),
              SizedBox(height: 30,),
              MyTextField(
                controller: passwordController,
                hintText: "密碼",
                obscureText: true,
                validate: passwordtext,
                errortext: "密碼不得為空",
                TextInputType: TextInputType.text,
              ),
              SizedBox(height: 30,),
              MyTextField(
                controller: passwordCheckController,
                hintText: "確認密碼",
                obscureText: true,
                validate: passwordchecktext,
                errortext: "密碼錯誤",
                TextInputType: TextInputType.text,
              ),
              SizedBox(height: 60,),
              MaterialButton(
                onPressed: () {
                  setState(() {
                    accountController.text.isEmpty? accounttext = true : accounttext = false;
                    passwordController.text.isEmpty? passwordtext = true : passwordtext = false;
                    passwordCheckController.text.isEmpty? passwordchecktext = true : passwordchecktext = false;
                    (passwordController.text != passwordCheckController.text)? passwordchecktext = true : passwordchecktext = false;
                  });
                  if(accounttext != true && passwordtext != true && passwordchecktext != true)
                    register();
                },
                child: Text("註冊", style: TextStyle(color: Colors.white,fontWeight:FontWeight.bold,fontSize: 16,),),
                height: 48,
                padding: EdgeInsets.all(5),
                textColor: Colors.white,
                color: Colors.teal,
                shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(8) ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}




