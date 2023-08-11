import 'package:flutter/material.dart';

import 'label_position.dart';

class ProgressSegment {
  final double value;
  final Color color;
  final String label;
  final bool isAbove;
  final LabelPosition labelPosition;
  final double labelPadding;
  final TextStyle labelTextStyle;

  ProgressSegment({
    required this.value,
    required this.color,
    required this.label,
    this.isAbove = false,
    this.labelPosition = LabelPosition.center,
    this.labelPadding = 5,
    this.labelTextStyle = const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  });

}