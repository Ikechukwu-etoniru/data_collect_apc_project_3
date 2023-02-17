
import 'package:data_collect_v2/utils/my_colors.dart';
import 'package:flutter/material.dart';

class MyInputBorder {
  static var borderInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(5),
    borderSide: const BorderSide(color: Colors.grey, width: 0.5),
  );

  static var focusedInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(5),
    borderSide: const BorderSide(
      color: MyColors.primaryColor,
      width: 2,
    ),
  );
  static var errorInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(5),
    borderSide: const BorderSide(
      color: Colors.red,
      width: 2,
    ),
  );
}
