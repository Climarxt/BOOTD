import 'package:flutter/material.dart';

import '../../../config/config.dart';

ButtonTheme buildButton(int num, String Texte) {
  return ButtonTheme(
    minWidth: double.infinity,
    child: OutlinedButton(
      onPressed: () {
        debugPrint('Received click');
      },
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Column(
          children: [
            Text(
              num.toString(),
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: black),
            ),
            Text(
              Texte,
              style: const TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w400, color: black),
            ),
          ],
        ),
      ),
    ),
  );
}
