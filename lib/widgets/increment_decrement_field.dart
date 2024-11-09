import 'package:flutter/material.dart';
import '../core/app_export.dart';

class IncrementDecrementField extends StatefulWidget {
  const IncrementDecrementField(
      {super.key,
      required this.minValue,
      required this.maxValue,
      required this.onChanged});

  final int minValue;
  final int maxValue;
  final Function(int value) onChanged; // Define uma função que recebe um int
  @override
  State<IncrementDecrementField> createState() =>
      _IncrementDecrementFieldState();
}

class _IncrementDecrementFieldState extends State<IncrementDecrementField> {
  late final int minValue;
  late final int maxValue;
  late int value;
  @override
  void initState() {
    super.initState();
    minValue = widget.minValue;
    maxValue = widget.maxValue;
    value = widget.minValue;
    //widget.onChanged(value);
  }

  void increment() {
    setState(() {
      if (value < maxValue) {
        value++;
        widget.onChanged(value);
      }
    });
  }

  void decrement() {
    setState(() {
      if (value > minValue) {
        value--;
        widget.onChanged(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: decrement,
          icon: const Icon(Icons.remove),
        ),
        Container(
          height: 66.h,
          width: 50.h,
          alignment: Alignment.center,
          child: Text(
            '$value',
            style: const TextStyle(fontSize: 20),
          ),
        ),
        IconButton(
          onPressed: increment,
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}
