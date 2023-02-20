import 'package:flutter/material.dart';

class CardView extends StatelessWidget {
  CardView(this.widget,
      {this.left = 10.0,
      this.right = 10.0,
      this.bottom = 00,
      this.top = 10.0});

  Widget widget;
  double left;
  double top;
  double right;
  double bottom;

  @override
  Widget build(BuildContext context) {
    if (widget == null) {
      return Container();
    }
    return Card(
      elevation:01.0,
      margin:
          EdgeInsets.only(top: top, bottom: bottom, right: right, left: left),
      child: widget,
    );
  }
}