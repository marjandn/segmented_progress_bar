import 'package:flutter/material.dart';

import 'label_position.dart';
import 'progress_segment.dart';

class SegmentedProgressBar extends StatelessWidget {
  const SegmentedProgressBar({
    super.key,
    required this.segments,
    this.height = 20,
    this.borderRadius = 5.0,
  });

  /// List of segments in the progress bar
  final List<ProgressSegment> segments;

  /// Height of progress bar
  /// Defaults to 20
  final double height;

  /// Border radius of progress bar
  /// Defaults to 5
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomPaint(
        painter: _ProgressBarPainter(
          segments: segments,
          borderRadius: borderRadius,
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

  _ProgressBarPainter({
    required this.segments,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double totalValue = segments.fold(0.0, (sum, segment) => sum + segment.value);

    double currentProgress = 0.0;
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

      final labelOffset = Offset(
          dx, ((segment.isAbove) ? -size.height - segment.labelPadding : size.height + segment.labelPadding));
      textPainter.paint(canvas, labelOffset);

      currentProgress += segmentWidth;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
