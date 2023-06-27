import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../components/mytextfield.dart';
import '../../file/file.dart';
import 'package:http/http.dart' as http;
import '../../database/api.dart';

class TDEEPage extends StatefulWidget{
  @override
  TDEE createState() => TDEE();
}

class TDEE extends State<TDEEPage>{
  final heightController = TextEditingController();
  final weightController = TextEditingController();
  final ageController = TextEditingController();
  String? gender;
  int? activity;
  bool heighttext = false;
  bool weighttext = false;
  bool agetext = false;
  String tdee = "";
  bool visible = false;

  void calculate(){
    int height = int.parse(heightController.text);
    int weight = int.parse(weightController.text);
    int age = int.parse(ageController.text);
    double? bmr;

    setState(() {
      if (gender == "male") {
        bmr = 66.5 + (13.75 * weight) + (5.003 * height) - (6.755 * age);
      } else {
        bmr = 655 + (9.563 * weight) + (1.850 * height) - (4.676 * age);
      }
      switch(activity){
        case 1:
          tdee = (1.2*bmr!).toStringAsFixed(1);
          break;
        case 2:
          tdee = (1.375*bmr!).toStringAsFixed(1);
          break;
        case 3:
          tdee = (1.55*bmr!).toStringAsFixed(1);
          break;
        case 4:
          tdee = (1.725*bmr!).toStringAsFixed(1);
          break;
        case 5:
          tdee = (1.9*bmr!).toStringAsFixed(1);
          break;
      }
      visible = true;
    });
  }

  preserve() async{
    String? uID;

    await file.getFile.then((value) async {
      String result = await file.readFromFile();
      setState(() {
        uID = result;
      });
    });

    Map<String, dynamic> toJson() =>
        {
          'uID' : uID,
          'height' : heightController.text.trim(),
          'weight' : weightController.text.trim(),
          'tdee' : tdee,
        };

    await http.post(
      Uri.parse(api.preserve),
      body: toJson(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text("每日總消耗熱量"),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 20,),
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 25),
                  child: Text("性別："),
                ),
                DropdownButton(
                  items: const <DropdownMenuItem<String>> [
                    DropdownMenuItem(child: Text("男性"), value: "male",),
                    DropdownMenuItem(child: Text("女性"), value: "female",),
                  ],
                  hint: Text("請選擇"),
                  onChanged: (selectValue){
                    setState(() {
                      gender = selectValue!;
                    });
                  },
                  value: gender,
                  elevation: 10,

                )
              ],
            ),
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 25),
                  child: Text("運動量："),
                ),
                DropdownButton(
                  items: const <DropdownMenuItem<int>> [
                    DropdownMenuItem(child: Text("不運動"), value: 1,),
                    DropdownMenuItem(child: Text("每周運動1~3天"), value: 2,),
                    DropdownMenuItem(child: Text("每周運動3~5天"), value: 3,),
                    DropdownMenuItem(child: Text("每周運動6~7天"), value: 4,),
                    DropdownMenuItem(child: Text("每天定時運動"), value: 5,),
                  ],
                  hint: Text("請選擇"),
                  onChanged: (selectValue){
                    setState(() {
                      activity = selectValue!;
                    });
                  },
                  value: activity,
                  elevation: 10,
                ),
              ],
            ),
            SizedBox(height: 10,),
            MyTextField(
              controller: heightController,
              hintText: "身高",
              obscureText: false,
              errortext: "請輸入身高",
              validate: heighttext,
              TextInputType: TextInputType.number,
            ),
            SizedBox(height: 30,),
            MyTextField(
              controller: weightController,
              hintText: "體重",
              obscureText: false,
              errortext: "請輸入體重",
              validate: weighttext,
              TextInputType: TextInputType.number,
            ),
            SizedBox(height: 30,),
            Padding(
              padding: EdgeInsets.only(right: 220),
              child: MyTextField(
                controller: ageController,
                hintText: "年齡",
                obscureText: false,
                errortext: "請輸入年齡",
                validate: agetext,
                TextInputType: TextInputType.number,
              ),
            ),
            SizedBox(height: 30,),
            Center(
              child: MaterialButton(
                onPressed: () {
                  setState(() {
                    heightController.text.isEmpty? heighttext = true : heighttext = false;
                    weightController.text.isEmpty? weighttext = true : weighttext = false;
                    ageController.text.isEmpty? agetext = true : agetext = false;
                  });
                  if(heighttext != true && weighttext != true && agetext != true && gender != null && activity != null) {
                    calculate();
                    preserve();
                  }
                },
                child: Text("計算", style: TextStyle(color: Colors.white,fontWeight:FontWeight.bold,fontSize: 16,),),
                height: 48,
                padding: EdgeInsets.all(5),
                textColor: Colors.white,
                color: Colors.green,
                shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(8) ),
              ),
            ),
            SizedBox(height: 30,),
            Visibility(
              visible: visible,
              child: Column(
                children: [
                  Center(
                    child: Text(
                      "每日總消耗熱量 = "+tdee,
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              )
            ),
          ],
        ),
      ),
    );
  }
}