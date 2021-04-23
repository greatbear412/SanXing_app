import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StyleText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final int lines;
  StyleText(this.text, this.style, {this.lines = 1});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style,
      maxLines: lines,
      softWrap: false,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class MainText extends StatelessWidget {
  final String text;
  final int lines;
  MainText(this.text, {this.lines = 1});

  @override
  Widget build(BuildContext context) {
    return StyleText(
        text,
        TextStyle(
          color: Colors.white,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
        lines: lines);
  }
}

///文本搜索框
class TextFieldWidget extends StatelessWidget {
  final String labelText;
  final String hintText;
  final TextEditingController controller;
  TextFieldWidget({Key key, this.labelText, this.hintText, this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      child: TextField(
          controller: controller,
          decoration: InputDecoration(
              labelText: labelText,
              labelStyle: TextStyle(color: Colors.white),
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.white),
              // prefixIcon: Icon(Icons.email),
              border: InputBorder.none //隐藏下划线
              )),
      decoration: BoxDecoration(
          // 下滑线浅灰色，宽度1像素
          border:
              Border(bottom: BorderSide(color: Colors.grey[200], width: 1.0))),
    );
  }
}
