import 'package:autogestion_tecnico/global/globals.dart';
import 'package:flutter/material.dart';
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
  List<String> tags = [];
  TextEditingController _textEditingController = TextEditingController();

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFieldTags(
      textfieldTagsController: widget.controller,
      textSeparators: const [' ', ','],
      letterCase: LetterCase.normal,
      inputfieldBuilder: (context, tec, fn, error, onChanged, onSubmitted) {
        _textEditingController = tec;

        return ((context, sc, currentTags, onTagDelete) {
          tags = currentTags;

          List<Widget> inputFields = [];

          inputFields.add(
            Container(
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  final mq = MediaQuery.of(context).size;
                  return SizedBox(
                    //width: widget.mq.width * widget.width,
                    width: widget.mq.width * widget.width * 0.8,
                    height: widget.height == null
                        ? null
                        : mq.height * widget.height,
                    child: GestureDetector(
                      child: TextFormField(
                        autocorrect: false,
                        controller: _textEditingController,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(
                              top: 1, bottom: 1, left: 10, right: 0),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(
                                  45.0), // Radio de borde para la esquina superior izquierda
                              topRight: Radius.circular(
                                  30.0), // Radio de borde para la esquina superior derecha
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: whiteColor),
                            borderRadius: BorderRadius.circular(0.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: whiteColor),
                            borderRadius: BorderRadius.circular(0.0),
                          ),
                          hintText: _textEditingController.text.isEmpty
                              ? widget.hintText
                              : null,
                          alignLabelWithHint: true,
                          filled: widget.filled,
                          fillColor: widget.fillColor,
                          errorText: error,
                        ),
                        onChanged: onChanged,
                      ),
                    ),
                  );
                },
              ),
            ),
          );

          for (int i = 0; i < tags.length; i++) {
            inputFields.add(
              Container(
                width: widget.mq.width * widget.width * 0.8,
                margin: const EdgeInsets.symmetric(vertical: 0.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(0.0),
                      ),
                      color: widget.colorTag,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 5.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          child: Text(
                            tags[i].toUpperCase(),
                            style: const TextStyle(color: Colors.white),
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
                            onTagDelete(tags[i]);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }

          return SingleChildScrollView(
            controller: sc,
            scrollDirection: Axis.vertical,
            child: Align(
              alignment: Alignment.topLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: inputFields,
              ),
            ),
          );
        });
      },
    );
  }
}
