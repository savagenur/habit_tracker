import 'package:flutter/material.dart';

import '../../../constants.dart';

class ButtonContainerWidget extends StatelessWidget {
  final Color? color;
  final String text;
  final VoidCallback? onTapListener;
  const ButtonContainerWidget({super.key, this.color,required this.text, this.onTapListener});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapListener,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(2),

        ),
        child: Center(
          child: Text(text, style: const TextStyle(color: primaryColor,fontWeight: FontWeight.w600),),
        ),
      ));
  }
}
