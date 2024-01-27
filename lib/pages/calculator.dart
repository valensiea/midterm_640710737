import 'package:flutter/material.dart';

class Calculator extends StatefulWidget {
  const Calculator({Key? key}) : super(key: key);

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String currentExpression = "0";
  static const addSign = "\u002B";
  static const subtractSign = "\u2212";
  static const multiplySign = "\u00D7";
  static const divideSign = "\u00F7";
  static const equalSign = "\u003D";

  double buttonSize = 80.0;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth < 400) {
      buttonSize = 60.0;
    } else if (screenWidth < 600) {
      buttonSize = 70.0;
    } else {
      buttonSize = 80.0;
    }

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(32.0),
            alignment: Alignment.bottomRight,
            child: Text(
              currentExpression,
              style: TextStyle(fontSize: 40.0),
            ),
          ),
          Expanded(
            child: _buildCalculatorButtons(),
          ),
        ],
      ),
    );
  }

  Widget _buildCalculatorButtons() {
    List<List<String>> buttonRows = [
      ["C", "AC"],
      ["7", "8", "9", divideSign],
      ["4", "5", "6", multiplySign],
      ["1", "2", "3", subtractSign],
      ["0", addSign],
      [equalSign]
    ];

    double buttonHeight =
        MediaQuery.of(context).size.height / buttonRows.length;

    return Column(
      children:
          buttonRows.map((row) => _buildRowButtons(row, buttonHeight)).toList(),
    );
  }

  Widget _buildRowButtons(List<String> values, double buttonHeight) {
    return Expanded(
      child: Row(
        children:
            values.map((value) => _buildButton(value, buttonHeight)).toList(),
      ),
    );
  }

  Widget _buildButton(String value, double buttonHeight) {
    double buttonWidth;

    if (value == "C") {
      buttonWidth = buttonSize * 2;
    } else if (value == "0") {
      buttonWidth = buttonSize * 3;
    } else {
      buttonWidth = buttonSize;
    }

    Color buttonColor;
    if (value == "C" ||
        value == "AC" ||
        value == divideSign ||
        value == multiplySign ||
        value == subtractSign ||
        value == addSign) {
      buttonColor = Colors.grey.shade200;
    } else if (value == equalSign) {
      buttonColor = Colors.blue.shade800;
    } else {
      buttonColor = Colors.blue.shade100;
    }

    Widget buttonChild;
    if (value == "AC") {
      buttonChild = Icon(Icons.backspace, color: Colors.black);
    } else {
      buttonChild = Text(
        value,
        style: TextStyle(fontSize: 32, color: Colors.black),
      );
    }

    return Expanded(
      child: InkWell(
        onTap: () {
          _handleButtonClick(value);
        },
        child: Container(
          height: buttonHeight,
          width: buttonWidth,
          margin: EdgeInsets.all(2.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: buttonColor,
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: buttonChild,
        ),
      ),
    );
  }

  void _handleButtonClick(String value) {
    setState(() {
      if (value == "=") {
        _clearAllEntries();
      } else if (value == "C") {
        _clearAllEntries();
      } else if (value == "AC") {
        _clearLastEntry();
      } else {
        if ((currentExpression.endsWith(divideSign) ||
                currentExpression.endsWith(multiplySign) ||
                currentExpression.endsWith(subtractSign) ||
                currentExpression.endsWith(addSign)) &&
            (value == divideSign ||
                value == multiplySign ||
                value == subtractSign ||
                value == addSign)) {
          currentExpression =
              currentExpression.substring(0, currentExpression.length - 1) +
                  value;
        } else {
          currentExpression =
              (currentExpression == "0") ? value : currentExpression + value;
        }
      }
    });
  }

  void _clearLastEntry() {
    setState(() {
      if (currentExpression.isNotEmpty) {
        currentExpression =
            currentExpression.substring(0, currentExpression.length - 1);
        if (currentExpression.length == 0) {
          currentExpression = "0";
        }
      }
    });
  }

  void _clearAllEntries() {
    setState(() {
      currentExpression = "0";
    });
  }
}
