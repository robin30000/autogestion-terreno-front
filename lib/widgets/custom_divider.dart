import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {

  final Size mq;
  List<Color> colors = [];
  double grosor;
  double marginvertical;
  
  CustomDivider({
    super.key,
    required this.mq,
    required this.colors,
    this.grosor = 0.002,
    this.marginvertical = 0.02
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: mq.width,
      height: mq.height * grosor,
      margin: EdgeInsets.symmetric(vertical: mq.height * marginvertical),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors
        )
      ) ,
    );
  }
}