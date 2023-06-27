import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../file/file.dart';
import 'package:http/http.dart' as http;
import '../../database/api.dart';

class cardlistPage extends StatefulWidget{
  @override
  cardlist createState() => cardlist();
}

class cardlist extends State<cardlistPage>{

  Future getData() async{
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
      Uri.parse(api.getData),
      body: toJson(),
    );

    if (response.statusCode == 200){
      if (response.body == "no data"){
        return "無紀錄";
      }
      else {
        var jsonData = jsonDecode(response.body);
        return jsonData;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text("健檢紀錄"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                  child: FutureBuilder (
                    future: getData(),
                    builder: (context, snapshot) {
                      if (snapshot.data == "無紀錄"){
                        return Text(
                          "無紀錄"
                        );
                      }
                      else if(snapshot.hasData){
                        List jsonData = snapshot.data;
                        return ListView.builder(
                            itemCount: jsonData.length,
                            itemBuilder: (context, index){
                              return Container(
                                padding: EdgeInsets.fromLTRB(30, 20, 30, 0),
                                height: 210,
                                width: double.maxFinite,
                                child: Card(
                                  elevation: 5,
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(15,10,15,10),
                                    child: Stack(
                                        children: <Widget>[
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: Stack(
                                              children: <Widget>[
                                                Padding(
                                                  padding: EdgeInsets.all(5),
                                                  child: Column(
                                                    children: <Widget>[
                                                      Row(
                                                        children: <Widget>[
                                                          date(jsonData![index]),
                                                        ],
                                                      ),
                                                      SizedBox(height: 35,),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: <Widget>[
                                                          height(jsonData![index]),
                                                          weight(jsonData![index]),
                                                          tdee(jsonData![index]),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ]),
                                  ),
                                ),
                              );
                            }
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
            ],
          ),
        )
      ),
    );
  }

  Widget date(data) {
    return Align(
      alignment: Alignment.centerLeft,
      child: RichText(
        text: TextSpan(
            text: "${data['created_at']}",
            style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.black,fontSize: 26,
            ),
        ),
      ),
    );
  }

  Widget height(data){
    return Padding(
      padding: EdgeInsets.only(left: 15),
      child: Align(
        alignment: Alignment.centerLeft,
        child: RichText(
          text: TextSpan(
              text: "身高",
              style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.blue,fontSize: 18,
              ),
              children: <TextSpan>[
                TextSpan(
                    text: "\n${data['height']}",
                    style: TextStyle(
                        color: Colors.blueAccent,
                        fontStyle: FontStyle.italic,
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                    )
                )
              ]
          ),
        ),
      ),
    );
  }

  Widget weight(data){
    return Align(
      alignment: Alignment.centerLeft,
      child: RichText(
        text: TextSpan(
            text: "體重",
            style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.red,fontSize: 18,
            ),
            children: <TextSpan>[
              TextSpan(
                  text: "\n${data['weight']}",
                  style: TextStyle(
                      color: Colors.redAccent,
                      fontStyle: FontStyle.italic,
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                  )
              )
            ]
        ),
      ),
    );
  }

  Widget tdee(data){
    return Padding(
      padding: EdgeInsets.only(right: 15),
      child: Align(
        alignment: Alignment.centerLeft,
        child: RichText(
          text: TextSpan(
              text: "TDEE",
              style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.green,fontSize: 18,
              ),
              children: <TextSpan>[
                TextSpan(
                    text: "\n${data['tdee']}",
                    style: TextStyle(
                        color: Colors.lightGreen,
                        fontStyle: FontStyle.italic,
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                    )
                )
              ]
          ),
        ),
      )
    );
  }
}