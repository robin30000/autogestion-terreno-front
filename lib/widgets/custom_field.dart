import 'package:autogestion_tecnico/global/globals.dart';
import 'package:flutter/material.dart';

class CustomField extends StatefulWidget {
  TextEditingController controller;
  TextInputType? keyboardType;
  int? minLines;
  int? maxLines;
  String hintText;
  dynamic icon;
  bool obscureText;
  bool isObscureText;
  bool? filled;
  Color? fillColor;
  double width;
  dynamic height;
  dynamic maxlength;
  double paddingTop;
  double paddingBottom;
  double paddingLeft;
  double paddingRight;

  CustomField(
      {Key? key,
      required this.controller,
      this.keyboardType = TextInputType.text,
      this.minLines = 1,
      this.maxLines = 1,
      required this.hintText,
      required this.icon,
      this.obscureText = false,
      this.isObscureText = false,
      this.filled = true,
      this.fillColor = Colors.white,
      this.width = 1.0,
      this.height = 0.05,
      this.maxlength,
      this.paddingTop = 10,
      this.paddingBottom = 1,
      this.paddingLeft = 5,
      this.paddingRight = 20})
      : super(key: key);

  @override
  State<CustomField> createState() => _CustomFieldState();
}

class _CustomFieldState extends State<CustomField> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    return Container(
      width: mq.width * widget.width,
      height: widget.height == null ? null : mq.height * widget.height,
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0, 2),
              spreadRadius: -6),
        ],
        borderRadius: BorderRadius.circular(
          30.0,
        ),
      ),
      child: TextFormField(
        autocorrect: false,
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        minLines: widget.minLines,
        maxLines: widget.maxLines,
        obscureText: widget.obscureText,
        maxLength: widget.maxlength ?? null,
        buildCounter: (BuildContext context,
                {int? currentLength,
                int? maxLength,
                required bool isFocused}) =>
            null,
        decoration: InputDecoration(
          counterStyle: const TextStyle(fontSize: 0),
          contentPadding: EdgeInsets.only(
              top: widget.paddingTop,
              bottom: widget.paddingBottom,
              left: widget.paddingLeft,
              right: widget.paddingRight),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
          hintText: widget.hintText,
          prefixIcon: widget.icon == null
              ? null
              : Padding(
                  padding: const EdgeInsetsDirectional.all(1),
                  child: Icon(widget.icon),
                ),
          suffixIcon: (!widget.isObscureText)
              ? null
              : Padding(
                  padding: const EdgeInsetsDirectional.all(1),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _isVisible = !_isVisible;
                        widget.obscureText = !widget.obscureText;
                      });
                    },
                    child: (_isVisible)
                        ? const Icon(Icons.visibility_rounded)
                        : const Icon(Icons.visibility_off_rounded),
                  ),
                ),
          filled: widget.filled,
          fillColor: widget.fillColor,
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: whiteColor),
              borderRadius: BorderRadius.circular(20.0)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: whiteColor),
              borderRadius: BorderRadius.circular(20.0)),
        ),
      ),
    );
  }
}
