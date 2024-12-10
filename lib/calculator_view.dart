import 'package:flutter/material.dart';

class CalculatorView extends StatefulWidget {
  const CalculatorView({super.key});

  @override
  State<CalculatorView> createState() => _CalculatorViewState();
}

class _CalculatorViewState extends State<CalculatorView> {
  final _textController = TextEditingController();
  List<String> lstSymbols = [
    "C",
    "*",
    "/",
    "DEL",
    "7",
    "8",
    "9",
    "+",
    "4",
    "5",
    "6",
    "-",
    "1",
    "2",
    "3",
    "%",
    "0",
    "=",
  ];

  final _key = GlobalKey<FormState>();
  String operator = '';
  int? first;
  int? second;

  void onButtonPressed(String value) {
    setState(() {
      if (value == "C") {
        // Clear all input
        _textController.clear();
        first = null;
        second = null;
        operator = '';
      } else if (value == "DEL") {
        // Delete last character
        if (_textController.text.isNotEmpty) {
          _textController.text = _textController.text
              .substring(0, _textController.text.length - 1);
        }
      } else if (value == "=") {
        // Evaluate the expression
        try {
          second = int.tryParse(_textController.text);
          if (second == null || operator.isEmpty || first == null) {
            _textController.text = "Error";
          } else {
            _textController.text =
                _evaluateExpression(first!, second!, operator).toString();
            first = int.tryParse(_textController.text);
            operator = '';
          }
        } catch (e) {
          _textController.text = "Error";
        }
      } else if ("+-*/%".contains(value)) {
        // Store the operator and the first operand
        if (_textController.text.isNotEmpty) {
          first = int.tryParse(_textController.text);
          operator = value;
          _textController.clear();
        }
      } else {
        // Append the pressed value
        _textController.text += value;
      }
    });
  }

  int _evaluateExpression(int first, int second, String operation) {
    switch (operation) {
      case "+":
        return first + second;
      case "-":
        return first - second;
      case "*":
        return first * second;
      case "/":
        if (second == 0) {
          throw Exception("Division by zero");
        }
        return first ~/ second; // Integer division
      case "%":
        if (second == 0) {
          throw Exception("Modulo by zero");
        }
        return first % second;
      default:
        throw Exception("Invalid operation");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator App'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _key,
          child: Column(
            children: [
              // Display Field
              TextFormField(
                textAlign: TextAlign.right,
                controller: _textController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
                readOnly: true,
              ),
              const SizedBox(height: 16),
              // Buttons Grid
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  itemCount: lstSymbols.length,
                  itemBuilder: (context, index) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: lstSymbols[index] == "="
                            ? Colors.green
                            : "0123456789".contains(lstSymbols[index])
                                ? Colors.blue[100]
                                : Colors.red[100],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () => onButtonPressed(lstSymbols[index]),
                      child: Text(
                        lstSymbols[index],
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: lstSymbols[index] == "="
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
