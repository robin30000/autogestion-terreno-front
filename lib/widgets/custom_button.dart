import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final Size mq;
  dynamic function;
  double? height;
  double? fontSize;
  Color color;
  Color colorText;
  String text;

  CustomButton({
    super.key,
    required this.mq,
    required this.function,
    this.height = 0.08,
    this.fontSize = 0.03,
    required this.color,
    required this.colorText,
    required this.text,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(30.0),
      onTap: widget.function,
      child: Container(
        alignment: Alignment.center,
        width: widget.mq.width * 0.6,
        height: widget.mq.height * widget.height!,
        decoration: BoxDecoration(
          color: widget.color,
          boxShadow: const [
            BoxShadow(
                color: Colors.black26,
                blurRadius: 15,
                offset: Offset(3, 2),
                spreadRadius: -3),
          ],
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Text(
          widget.text,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: widget.mq.height * widget.fontSize!,
              color: widget.colorText),
        ),
      ),
    );
  }
}
