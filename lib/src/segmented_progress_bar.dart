import 'dart:math';

import 'package:flutter/material.dart';

import 'label_position.dart';
import 'progress_segment.dart';

class SegmentedProgressBar extends StatelessWidget {
  const SegmentedProgressBar({
    super.key,
    required this.segments,
    this.height = 20,
    this.borderRadius = 5.0,
    this.triangleIndicator = false
  });

  /// List of segments in the progress bar
  final List<ProgressSegment> segments;

  /// Height of progress bar
  /// Defaults to 20
  final double height;

  /// Border radius of progress bar
  /// Defaults to 5
  final double borderRadius;

  final bool triangleIndicator;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomPaint(
        painter: _ProgressBarPainter(
          segments: segments,
          borderRadius: borderRadius,
          barHeight: height,
          triangleIndicator: triangleIndicator
        ),
        child: Container(
          height: height,
        ),
      ),
    );
  }
}

class _ProgressBarPainter extends CustomPainter {
  final List<ProgressSegment> segments;
  final double borderRadius;
  final double barHeight;
  final bool triangleIndicator;

  _ProgressBarPainter({
    required this.segments,
    required this.borderRadius,
    required this.barHeight,
    required this.triangleIndicator
  });

  @override
  void paint(Canvas canvas, Size size) {
    double totalValue = segments.fold(0.0, (sum, segment) => sum + segment.value);

    double currentProgress = 0.0;
    double previousSegmentEnd = 0.0; // Track the end of the previous segment

    double barWidth = size.width;

    for (var i = 0; i < segments.length; i++) {
      final segment = segments[i];
      final segmentWidth = (segment.value / totalValue) * barWidth;
      final paint = Paint()..color = segment.color;

      if (segments.length == 1) {
        final roundedRect = RRect.fromRectAndCorners(
          Rect.fromLTWH(currentProgress, 0, segmentWidth, size.height),
          topLeft: Radius.circular(borderRadius),
          topRight: Radius.circular(borderRadius),
          bottomLeft: Radius.circular(borderRadius),
          bottomRight: Radius.circular(borderRadius),
        );
        canvas.drawRRect(roundedRect, paint);
      } else if (i == 0) {
        final roundedRect = RRect.fromRectAndCorners(
          Rect.fromLTWH(currentProgress, 0, segmentWidth, size.height),
          topLeft: Radius.circular(borderRadius),
          topRight: Radius.zero,
          bottomLeft: Radius.circular(borderRadius),
          bottomRight: Radius.zero,
        );
        canvas.drawRRect(roundedRect, paint);
      } else if (i == (segments.length - 1)) {
        final rect = RRect.fromRectAndCorners(
          Rect.fromLTWH(currentProgress, 0, segmentWidth, size.height),
          topLeft: Radius.zero,
          topRight: Radius.circular(borderRadius),
          bottomLeft: Radius.zero,
          bottomRight: Radius.circular(borderRadius),
        );
        canvas.drawRRect(rect, paint);
      } else {
        canvas.drawRect(Rect.fromLTWH(currentProgress, 0, segmentWidth, size.height), paint);
      }

      final textPainter = TextPainter(
        text: TextSpan(text: segment.label, style: segment.labelTextStyle),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      );
      textPainter.layout();

      final centerX = currentProgress + segmentWidth / 2;

      final dx = switch (segment.labelPosition) {
        LabelPosition.center => centerX - textPainter.width / 2,
        LabelPosition.start => currentProgress,
        LabelPosition.end => currentProgress + segmentWidth - textPainter.width,
      };

      bool isAbove = segment.isAbove;
      double labelPadding = segment.labelPadding;

      /// If the label and the previous position interfere with the starting position of the current label
      /// The label will placed top/bottom according to previous lable position
      if (i > 0) {
        final previousTextPainter = TextPainter(
          text: TextSpan(text: segments[i - 1].label, style: segments[i - 1].labelTextStyle),
          textDirection: TextDirection.ltr,
        );
        previousTextPainter.layout();

        final previousTextEnd = previousSegmentEnd;
        final currentTextStart = dx;

        if (currentTextStart - previousTextEnd > 5) {
          isAbove = segments[i].isAbove;
        } else {
          isAbove = !segments[i - 1].isAbove;
        }
      }


      final triangleBaseWidth = sqrt( pow(barHeight, 2) + pow(barHeight,2));
      final triangleHeight = sqrt(pow(barHeight,2) - pow(triangleBaseWidth /2,2));

      if(triangleIndicator){

        final trianglePath = Path();
        trianglePath.moveTo(centerX, isAbove ? -triangleHeight-1 : barHeight + triangleHeight);
        trianglePath.lineTo(centerX - triangleBaseWidth / 2,
            isAbove ? -1 : barHeight);
        trianglePath.lineTo(centerX + triangleBaseWidth / 2,
            isAbove ? -1 : barHeight );
        trianglePath.close();

        final trianglePaint = Paint()..color = segment.color;
        canvas.drawPath(trianglePath, trianglePaint);

      }

      final labelOffset = Offset(
        dx,
        isAbove
            ? -size.height - (triangleIndicator ? triangleHeight : 0) - labelPadding
            : size.height + (triangleIndicator ? triangleHeight : 0) + labelPadding,
      );

      textPainter.paint(canvas, labelOffset);

      previousSegmentEnd = currentProgress + segmentWidth + 20; // Update the previous segment's end

      currentProgress += segmentWidth;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
