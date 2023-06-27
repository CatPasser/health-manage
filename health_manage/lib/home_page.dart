import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health_manage/components/homebutton.dart';
import 'package:health_manage/page/bmi/record_page.dart';
import 'package:health_manage/page/question/question_page.dart';
import 'package:health_manage/page/record/cardlist_page.dart';
import 'package:health_manage/page/tdee/tdee_page.dart';

class HomePage extends StatefulWidget{
  @override
  Home createState() => Home();
}

class Home extends State<HomePage>{

  void bmi(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => recordPage()));
  }
  void tdee(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => TDEEPage()));
  }
  void cardlist(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => cardlistPage()));
  }
  void question(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => questionPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Stack(
            children: [
              Positioned(
                top: 30,
                right: 30,
                child: HomeButton(onTap: bmi, text: "BMI健康指數",
                    sweepGradient: const SweepGradient(
                        startAngle: 1,
                        colors: [
                          Colors.pink,
                          Colors.red,
                          Colors.amber,
                          Colors.red,
                          Colors.pink,
                        ]
                    ),
                ),
              ),
              Positioned(
                top: 150,
                left: 30,
                child: HomeButton(onTap: tdee, text: "每日總消耗熱量",
                    sweepGradient: const SweepGradient(
                        startAngle: 1,
                        colors: [
                          Colors.green,
                          Colors.lightGreen,
                          Colors.lightGreenAccent,
                          Colors.lightGreen,
                          Colors.green,
                        ]
                    ),
                ),
              ),
              Positioned(
                top: 270,
                right: 30,
                child: HomeButton(onTap: cardlist, text: "健檢紀錄",
                    sweepGradient: const SweepGradient(
                        startAngle: 1,
                        colors: [
                          Colors.blueAccent,
                          Colors.lightBlue,
                          Colors.lightBlueAccent,
                          Colors.lightBlue,
                          Colors.blueAccent,
                        ]
                    ),
                ),
              ),
              Positioned(
                top: 390,
                left: 30,
                child: HomeButton(onTap: question, text: "免疫力問卷",
                    sweepGradient: const SweepGradient(
                        startAngle: 1,
                        colors: [
                          Colors.deepPurple,
                          Colors.purple,
                          Colors.purpleAccent,
                          Colors.purple,
                          Colors.deepPurple,
                        ]
                    ),
                ),
              ),
              Positioned(
                top: 510,
                right: 30,
                child: HomeButton(onTap: bmi, text: "健檢資料",
                    sweepGradient: const SweepGradient(
                        startAngle: 1,
                        colors: [
                          Colors.deepOrange,
                          Colors.orange,
                          Colors.amber,
                          Colors.orange,
                          Colors.deepOrange,
                        ]
                    ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
