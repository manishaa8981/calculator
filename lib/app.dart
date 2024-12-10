import 'package:calculator_app_cw/calculator_view.dart';
import 'package:flutter/material.dart';

class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CalculatorView(),
    );
  }
}
