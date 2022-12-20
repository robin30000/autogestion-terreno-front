import 'package:flutter/material.dart';

import 'package:autogestion_tecnico/global/globals.dart';

class CustomDropdown extends StatefulWidget {
  
  final Size mq;
  dynamic function;
  dynamic functionOnTap;
  String hintText;
  IconData icon;
  bool? filled;
  Color? fillColor;
  double width;
  double height;
  List<Map<String, dynamic>> options;
  Color? iconDesplegableColor = blueColor;
  String value;
  
  CustomDropdown({
    Key? key,
    required this.mq,
    required this.function,
    required this.hintText,
    required this.icon,
    this.iconDesplegableColor,
    required this.options,
    this.filled = true,
    this.fillColor = Colors.white,
    this.width = 1.0,
    this.height = 0.05,
    required this.value,
    this.functionOnTap
  }) : super(key: key);


  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.mq.width * widget.width,
      height: widget.mq.height * widget.height,
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(0, 2),
            spreadRadius: -6
          ),
        ],
        borderRadius: BorderRadius.circular(30.0,),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField(
          value: widget.value,
          iconEnabledColor: widget.iconDesplegableColor,
          iconDisabledColor: widget.iconDesplegableColor,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(top: 10, bottom: 1, left: 5, right: 6),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
            prefixIcon: Padding(
              padding: const EdgeInsetsDirectional.all(1),
              child: Icon(widget.icon),
            ),
            filled: widget.filled,
            fillColor: widget.fillColor,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: whiteColor),
              borderRadius: BorderRadius.circular(30.0)
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: whiteColor),
              borderRadius: BorderRadius.circular(30.0)
            ),
          ),
          hint: Text(widget.hintText),
          items: widget.options.where((e) => e['state']).map<DropdownMenuItem>((opt) {
            return DropdownMenuItem<String>(
              value: opt['value'],
              child: Text(opt['name']),
            );
          }).toList(), 
          onChanged: widget.function,
          onTap: widget.functionOnTap,
        ),
      ),
    );
  }
}