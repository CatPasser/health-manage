import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health_manage/components/mytextfield.dart';
import 'dart:math' as math;
import 'package:http/http.dart' as http;
import '../../database/api.dart';
import '../../file/file.dart';

class BMIPage extends StatefulWidget{
  @override
  BMI createState() => BMI();
}

class BMI extends State<BMIPage>{
  final heightController = TextEditingController();
  final weightController = TextEditingController();
  bool heighttext = false;
  bool weighttext = false;
  String bmi = "";
  String state = "";
  String advice = "";
  Color? bmiColor;

  void calculate(){
    int height = int.parse(heightController.text);
    int weight = int.parse(weightController.text);
    double meter = height / 100;
    setState(() {
      bmi = (weight / math.pow(meter, 2)).toStringAsFixed(1);
      if(double.parse(bmi) < 18.5){
        state = "體重過輕";
        bmiColor = Colors.greenAccent;
        advice = "建議多運動，均衡飲食";
      }
      else if(double.parse(bmi) <= 24){
        state = "正常";
        bmiColor = Colors.green;
        advice = "恭喜!繼續保持";
      }
      else if(double.parse(bmi) <= 27){
        state = "體重過重";
        bmiColor = Colors.orangeAccent;
        advice = "請小心，盡快力行健康體重管理";
      }
      else if(double.parse(bmi) <= 30){
        state = "輕度肥胖";
        bmiColor = Colors.deepOrange;
        advice = "務必立刻力行健康體重管理";
      }
      else if(double.parse(bmi) <= 35){
        state = "中度肥胖";
        bmiColor = Colors.redAccent;
        advice = "務必立刻力行健康體重管理";
      }
      else{
        state = "重度肥胖";
        bmiColor = Colors.red;
        advice = "務必立刻力行健康體重管理";
      }
    });
    updateBMI();
  }

  updateBMI() async{
    String? uID;

    file.getFile.then((value) async {
      String result = await file.readFromFile();
      setState(() {
        uID = result;
      });

      Map<String, dynamic> tojson() =>
          {
            'uID' : uID,
            'bmi' : bmi,
            'state' : state,
          };

      await http.post(
        Uri.parse(api.updateBMI),
        body: tojson(),
      );

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text("BMI計算"),
        centerTitle: true,
        backgroundColor: Colors.pink,
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 50,),
            Container(
              height: 180,
              width: 400,
              child: Row(
                children: [
                  Container(
                    height: 180,
                    width: 290,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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
                      ],
                    ),
                  ),
                  Center(
                    child: MaterialButton(
                      onPressed: () {
                        setState(() {
                          heightController.text.isEmpty? heighttext = true : heighttext = false;
                          weightController.text.isEmpty? weighttext = true : weighttext = false;
                        });
                        if(heighttext != true && weighttext != true)
                          calculate();
                      },
                      child: Text("計算", style: TextStyle(color: Colors.white,fontWeight:FontWeight.bold,fontSize: 16,),),
                      height: 48,
                      padding: EdgeInsets.all(5),
                      textColor: Colors.white,
                      color: Colors.pink,
                      shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(8) ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 30,),
            Container(
              height: 350,
              width: 350,
              margin: EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(width: 2, color: Colors.pink),
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  SizedBox(height: 10,),
                  const Center(
                    child: Text(
                      "您的BMI值為：",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  SizedBox(height: 105,),
                  Center(
                    child: Text(
                      bmi,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: bmiColor,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      state,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: bmiColor,
                      ),
                    ),
                  ),
                  SizedBox(height: 60,),
                  Center(
                    child: Text(
                      advice,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: bmiColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}