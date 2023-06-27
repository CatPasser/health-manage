import 'package:flutter/material.dart';

class MyButton extends StatelessWidget{

  final void Function()? onPressed;
  final String text;
  final Color? color;

  const MyButton({
    super.key,
    required this.onPressed,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context){
    return MaterialButton(
      onPressed: () {
        onPressed;
      },
      height: 48,
      padding: EdgeInsets.all(5),
      child: Text(text, style: TextStyle(color: Colors.white,fontWeight:FontWeight.bold,fontSize: 16,),),
      textColor: Colors.white,
      color: color,
      shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(8) ),
    );
  }
}