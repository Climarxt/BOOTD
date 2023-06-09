import 'package:flutter/material.dart';

class Stats extends StatelessWidget {
  final int count;
  final String label;

  const Stats({
    Key? key,
    required this.count,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildCountText(),
        buildLabelText(),
      ],
    );
  }

  Text buildCountText() {
    return Text(
      count.toString(),
      style: const TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Text buildLabelText() {
    return Text(
      label,
      style: const TextStyle(color: Colors.black54),
    );
  }
}
