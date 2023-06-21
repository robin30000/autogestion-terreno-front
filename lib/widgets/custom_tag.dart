import 'package:autogestion_tecnico/global/globals.dart';
import 'package:autogestion_tecnico/widgets/qr.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:textfield_tags/textfield_tags.dart';

class CustomTag extends StatefulWidget {
  final Size mq;
  final TextfieldTagsController controller;
  final String hintText;
  final bool? filled;
  final Color? fillColor;
  final double width;
  final dynamic height;
  final Color colorTag;
  final VoidCallback? onTap;

  const CustomTag(
      {this.onTap,
      super.key,
      required this.mq,
      required this.controller,
      required this.hintText,
      this.filled = true,
      this.fillColor = Colors.white,
      this.width = 1.0,
      this.height = 0.05,
      required this.colorTag});

  @override
  State<CustomTag> createState() => _CustomTagState();
}

class _CustomTagState extends State<CustomTag> {
  String data = "";
  @override
  Widget build(BuildContext context) {
    return TextFieldTags(
      textfieldTagsController: widget.controller,
      textSeparators: const [' ', ','],
      letterCase: LetterCase.normal,
      inputfieldBuilder: (context, tec, fn, error, onChanged, onSubmitted) {
        return ((context, sc, tags, onTagDelete) {
          return Container(
              width: widget.mq.width * widget.width,
              height: widget.height == null
                  ? null
                  : widget.mq.height * widget.height,
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
              child: GestureDetector(
                child: TextFormField(
                  onTap: () async {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => QRScanner(),
                    ));
                    ClipboardData? clipboardData =
                        await Clipboard.getData('text/plain');

                    print(clipboardData);
                    setState(() {
                      String tec = clipboardData as String;
                    });
                  },
                  //initialValue: data,
                  autocorrect: false,
                  readOnly: true,
                  controller: tec,
                  focusNode: fn,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(
                        top: 1, bottom: 1, left: 20, right: 5),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: whiteColor),
                        borderRadius: BorderRadius.circular(30.0)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: whiteColor),
                        borderRadius: BorderRadius.circular(30.0)),
                    hintText: widget.controller.hasTags ? '' : widget.hintText,
                    filled: widget.filled,
                    fillColor: widget.fillColor,
                    errorText: error,
                    prefixIconConstraints:
                        BoxConstraints(maxWidth: widget.mq.width * 0.7),
                    prefixIcon: tags.isNotEmpty
                        ? SingleChildScrollView(
                            controller: sc,
                            scrollDirection: Axis.horizontal,
                            child: Row(
                                children: tags.map((String tag) {
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(20.0),
                                  ),
                                  color: widget.colorTag,
                                ),
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 5.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      child: Text(
                                        tag.toString().toUpperCase(),
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ),
                                    const SizedBox(width: 4.0),
                                    InkWell(
                                      child: Icon(
                                        Icons.cancel,
                                        size: 14.0,
                                        color: greyColor,
                                      ),
                                      onTap: () {
                                        onTagDelete(tag);
                                      },
                                    )
                                  ],
                                ),
                              );
                            }).toList()),
                          )
                        : null,
                  ),
                  onChanged: onChanged,

                  //onSubmitted: onSubmitted,
                ),
              ));
        });
      },
    );
  }
}
