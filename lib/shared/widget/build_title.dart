import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

Padding buildTitle(String category) {
  return Padding(
    padding: const EdgeInsets.all(20),
    child: GFTypography(
      fontWeight: FontWeight.bold,
      text: category,
      textColor: Colors.black.withOpacity(0.5),
      type: GFTypographyType.typo5,
      showDivider: false,
    ),
  );
}
