import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'bmi_page.dart';
import '../../database/api.dart';
import '../../file/file.dart';

class recordPage extends StatefulWidget{

  @override
  record createState() => record();
}

class record extends State<recordPage>{
  Color? bmiColor;

  Future search_Record() async {
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
        };

    final response = await http.post(
      Uri.parse(api.bmi_record),
      body: toJson(),
    );

    if (response.statusCode == 200){
      if (response.body == "無紀錄"){
        return "無紀錄";
      }
      else {
        var json = jsonDecode(response.body);
        Map data = json;
        String bmi = data['users_bmi'];
        setState(() {
          if(double.parse(bmi) < 18.5){
            bmiColor = Colors.greenAccent;
          }
          else if(double.parse(bmi) <= 24){
            bmiColor = Colors.green;
          }
          else if(double.parse(bmi) <= 27){
            bmiColor = Colors.orangeAccent;
          }
          else if(double.parse(bmi) <= 30){
            bmiColor = Colors.deepOrange;
          }
          else if(double.parse(bmi) <= 35){
            bmiColor = Colors.redAccent;
          }
          else{
            bmiColor = Colors.red;
          }
        });
        return json;
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text("BMI健康指數"),
        centerTitle: true,
        backgroundColor: Colors.pink,
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              height: 350,
              width: double.infinity,
              color: Colors.white,
              child: Center(
                child: FutureBuilder (
                  future: search_Record(),
                  builder: (context, snapshot) {
                    if (snapshot.data == "無紀錄"){
                      return Stack(
                        children: [
                          Center(
                            child: Icon(
                              Icons.trip_origin,
                              color: Colors.grey[500],
                              size: 300,
                            ),
                          ),
                          Center(
                              child: Text(
                                "無紀錄",
                                style: TextStyle(color: Colors.grey[500], fontSize: 26,fontWeight:FontWeight.bold,),
                                textAlign: TextAlign.center,
                              )
                          )
                        ],
                      );
                    }
                    else if(snapshot.hasData){
                      Map? data = snapshot.data;
                      return Stack(
                        children: [
                          Center(
                            child: Icon(
                              Icons.trip_origin,
                              color: bmiColor,
                              size: 300,
                            ),
                          ),
                          Center(
                              child: Text(
                                data!['users_bmi'].toString() + "\n" +
                                    data!['bmi_state'].toString(),
                                style: TextStyle(color: bmiColor, fontSize: 26,fontWeight:FontWeight.bold,),
                                textAlign: TextAlign.center,
                              )
                          )
                        ],
                      );
                    }
                    else {
                      return Text("加載中...",
                        style: TextStyle(fontSize: 26, fontWeight: FontWeight
                            .bold,),);
                    }
                  },
                ),
              ),
            ),
            SizedBox(height: 120,),
            MaterialButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => BMIPage()));
              },
              child: Text("前往BMI計算", style: TextStyle(color: Colors.white,fontWeight:FontWeight.bold,fontSize: 16,),),
              height: 48,
              padding: EdgeInsets.all(5),
              textColor: Colors.white,
              color: Colors.pink,
              shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(8) ),
            ),
          ],
        )
      )
    );
  }

}