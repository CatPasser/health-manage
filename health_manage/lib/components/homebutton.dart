import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeButton extends StatelessWidget{

  final Function()? onTap;
  final String text;
  final SweepGradient sweepGradient;

  const HomeButton({
    super.key,
    required this.onTap,
    required this.text,
    required this.sweepGradient,
  });

  @override
  Widget build(BuildContext context){
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 175,
        width: 175,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.deepPurple[400]!,
              offset: Offset(3, 6), // 偏移量
              blurRadius: 2,
            )
          ],
          gradient: sweepGradient,
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(color: Colors.white,fontWeight:FontWeight.bold,fontSize: 20,),
          ),
        ),
      ),
    );
  }
}