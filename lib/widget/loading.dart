import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  final bool inAsyncCall;
  final double opacity;
  final Color color;
  final Widget progressIndicator;
  final String? mesage;
  final bool dismissible;

  LoadingScreen({
    Key? key,
    required this.inAsyncCall,
    this.opacity = 0.7,
    this.color = Colors.white,
    this.progressIndicator = const CircularProgressIndicator(),
    this.mesage,
    this.dismissible = false,
  }) : assert(inAsyncCall != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [];
    if (inAsyncCall) {
      Widget layOutProgressIndicator;
        layOutProgressIndicator = Center(
          child: Container(
            child: Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text("$mesage", style: TextStyle(color: Colors.blue, fontSize: 20, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),)
                ],
              ),
            )
          )
        );
      final modal = [
        new Opacity(
          child: new ModalBarrier(dismissible: dismissible, color: color),
          opacity: opacity,
        ),
        layOutProgressIndicator
      ];
      widgetList += modal;
    }
    return new Stack(
      children: widgetList,
    );
  }
}