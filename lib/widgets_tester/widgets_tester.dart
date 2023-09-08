import 'package:flutter/material.dart';

class EmptyTestScreen extends StatelessWidget {
  const EmptyTestScreen({Key? key, this.text}) : super(key: key);

  final String? text;
  @override
  Widget build(BuildContext context) {
    return Center(child: Text(text??'test screen'),);
  }
}
