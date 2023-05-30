import 'package:flutter/material.dart';

import '../../../constants.dart';

Widget pleaseWaitWidget() {
  return Column(
    children: [
      sizeVer(10),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Please wait...",
            style: TextStyle(
              color: primaryColor,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          sizeHor(5),
          CircularProgressIndicator(),
        ],
      )
    ],
  );
}
