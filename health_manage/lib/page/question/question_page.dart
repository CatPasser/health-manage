import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grouped_buttons/grouped_buttons.dart';

Future<Questionnaire> getQuestionnaire() async {
  final assetPath='assets/question.json';
  final jsonData=await rootBundle.loadString(assetPath);
  final jsonDataDecoded=jsonDecode(jsonData);
  return Questionnaire.fromJson(jsonDataDecoded);
}

class Questionnaire {
  final String name;
  final String instructions;
  final List<Question> questions;
  final List<Interpretation> interpretations;

  Questionnaire({
    required this.name,
    required this.instructions,
    required this.questions,
    required this.interpretations,
  });

  factory Questionnaire.fromJson(Map<String, dynamic> json) => Questionnaire(
    name: json['name'],
    instructions: json['instructions'],
    questions: List<Question>.from(json['questions'].map((i)=>Question.fromJson(i))),
    interpretations: List<Interpretation>.from(json['interpretations'].map((i)=>Interpretation.fromJson(i))),
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'instructions': instructions,
    'questions': List<dynamic>.from(questions.map((i)=>i.toJson())),
    'interpretations': List<dynamic>.from(interpretations.map((i)=>i.toJson())),
  };
}
class Question {
  final String text;
  final List<Answer> answers;

  Question({
    required this.text,
    required this.answers,
  });

  factory Question.fromJson(Map<String, dynamic> json) => Question(
    text: json['text'],
    answers: List<Answer>.from(json['answers'].map((i)=>Answer.fromJson(i))),
  );

  Map<String, dynamic> toJson() => {
    'text': text,
    'answers': List<dynamic>.from(answers.map((i)=>i.toJson())),
  };
}

class Interpretation {
  final int score;
  final String text;

  Interpretation({
    required this.score,
    required this.text,
  });

  factory Interpretation.fromJson(Map<String, dynamic> json) => Interpretation(
    score: json['score'],
    text: json['text'],
  );

  Map<String, dynamic> toJson() => {
    'score': score,
    'text': text,
  };
}

class Answer {
  final int score;
  final String text;

  Answer({
    required this.score,
    required this.text,
  });

  factory Answer.fromJson(Map<String, dynamic> json) => Answer(
    score: json['score'],
    text: json['text'],
  );

  Map<String, dynamic> toJson() => {
    'score': score,
    'text': text,
  };
}

class Button extends StatelessWidget {
  final String buttonLabel;
  final void Function() onPressed;
  final bool isPrimary;

  Button.primary({
    required this.buttonLabel,
    required this.onPressed,
  }):isPrimary=true;

  Button.accent({
    required this.buttonLabel,
    required this.onPressed,
  }):isPrimary=false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: isPrimary? Colors.purple: Colors.red,

        onPrimary: Colors.amberAccent,
      ),
      child: Text(buttonLabel, style: TextStyle(fontWeight: FontWeight.w700,
          color: Colors.white),),
      onPressed: onPressed,);
  }
}

class questionPage extends StatefulWidget {
  @override
  State<questionPage> createState() => question();
}

class question extends State<questionPage> {

  //late 可在任何時間點assign變數
  late List<Questionnaire> questionnaires;
  late Future<bool> loadAllQuestionnairesFuture;

  //async 跟 await 為異步函數(非同步傳值時要用的函數)
  Future<bool> loadAllQuestionnaires() async {
    questionnaires=[];
    //接收assets表單資料
    final questionnair=await getQuestionnaire();
    questionnaires.add(questionnair);
    return true;
  }

  //初始化表單
  @override
  void initState() {
    super.initState();
    loadAllQuestionnairesFuture=loadAllQuestionnaires();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text('免疫力問卷'),
        centerTitle: true,
        backgroundColor: Colors.purple,
      ),
      body: FutureBuilder(
          future: loadAllQuestionnairesFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Center(child: Column(
                children: [
                  SizedBox(height: 50,),
                  for (Questionnaire q in questionnaires)
                  //表單中的每個name做成按鈕
                    Button.accent(buttonLabel: "開始",
                      onPressed: ()=>Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context)=>QuestionnaireScreen(questionnaire: q, ),),),),
                ],
              ),
              );
            }
            else if (snapshot.hasError) {
              return AlertDialog(
                title: Text('資料讀取有誤!'),
                actions: <Widget>[
                  ElevatedButton(
                    child: Text('重新嘗試'),
                    onPressed: ()=> setState(() {
                      loadAllQuestionnairesFuture=loadAllQuestionnaires();
                    }),
                  ),
                ],
              );
            }
            else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}

class QuestionnaireScreen extends StatefulWidget {
  final Questionnaire questionnaire;
  QuestionnaireScreen({required this.questionnaire});
  @override
  State<QuestionnaireScreen> createState() => _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends State<QuestionnaireScreen> {
  List<Question> get questions=> widget.questionnaire.questions;
  late int questionIndex;
  Question get currentQuestion => questions[questionIndex];
  int get numberOfQuestions => questions.length;
  late List<int> chosenAnswers;
  bool get userHasAnsweredCurrentQuestion => chosenAnswers[questionIndex]!=null;
  String get instructions => widget.questionnaire.instructions;
  late int totalScores;

  String getResultInterpretation() {
    int result=0;
    for (int i=0; i<numberOfQuestions; i++) {
      Question q=questions[i];
      int answerIndex=chosenAnswers[i];
      Answer answer=q.answers[answerIndex];
      int score=answer.score;
      result+=score;
    }
    totalScores=result;

    List<Interpretation> interpretations=widget.questionnaire.interpretations;
    for (Interpretation itp in interpretations) {
      if (result>=itp.score)
        return itp.text;
    }
    return interpretations.last.text;
  }

  @override
  void initState() {
    super.initState();
    questionIndex=0;
    chosenAnswers=[]..length=numberOfQuestions;
  }

  void onNextButtonPressed() {
    print(questionIndex);
    if (questionIndex<numberOfQuestions-1) {
      setState(() {
        questionIndex++;
      });
    }

    else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=>ResultScreen(
        questionnaireName: widget.questionnaire.name,
        interpretation: getResultInterpretation(),
        totalScore: totalScores,
      ),),);
    }
  }

  void onBackButtonPressed() {
    if (questionIndex>0) {
      setState(() {
        questionIndex--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title:Text(widget.questionnaire.name),
        centerTitle: true,
        backgroundColor: Colors.purple,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left:20, right:20, top:20),
                child: Text(instructions,
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.purple),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(15),
                child: Card(child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16,),
                    SizedBox(height:24),
                    Padding(padding: EdgeInsets.only(left:30, right:8),
                      child: Text(currentQuestion.text,
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),),
                    ),
                    SizedBox(height:24),
                    RadioButtonGroup(activeColor:Theme.of(context).primaryColor,
                      labels: currentQuestion.answers.map((answer)=>answer.text).toList(),
                      onChange: (_,answerIndex)=>setState(() {
                        chosenAnswers[questionIndex]=answerIndex;
                        print(chosenAnswers[questionIndex]);
                      }),
                      picked: !userHasAnsweredCurrentQuestion? "":currentQuestion.answers[chosenAnswers[questionIndex]].text,
                    ),
                    SizedBox(height:20),
                    Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Visibility(
                              visible: questionIndex!=0,
                              child: Button.accent(buttonLabel: 'Back', onPressed: onBackButtonPressed)),
                          Button.primary(buttonLabel: 'Next', onPressed: () {
                            print(userHasAnsweredCurrentQuestion);
                            if (userHasAnsweredCurrentQuestion) onNextButtonPressed();
                            else return null;
                          })
                        ],
                      ),
                    ),
                  ],
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ResultScreen extends StatelessWidget {
  String questionnaireName;
  String interpretation;
  int totalScore;

  ResultScreen({required this.questionnaireName, required this.interpretation, required this.totalScore});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
          title: Text(questionnaireName),
        centerTitle: true,
        backgroundColor: Colors.purple,
      ),
      body: SafeArea(
        child: Center(
          child: LayoutBuilder(
            builder: (context, contraints) {
              return Container(
                width: contraints.maxWidth*0.75,
                height: contraints.maxHeight*0.5,
                child: Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top:40, bottom: 20),
                        child: Text('您的評量結果為:', textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20,
                              fontWeight: FontWeight.normal),),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(totalScore.toString(), style: TextStyle(fontSize: 48, fontWeight: FontWeight.w700),),
                          Text('分', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),),
                        ],
                      ),
                      Text(interpretation, style:TextStyle(color: Colors.purple,
                          fontSize: 20, fontWeight: FontWeight.w700) ,),
                      SizedBox(height: 20),
                      Padding(padding: EdgeInsets.only(bottom: 16),
                          child: Button.primary(buttonLabel: '回首頁',
                              onPressed: ()=>Navigator.of(context).pop())),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}