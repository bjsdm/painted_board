import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:test_flutter/painted_board_provider.dart';

class MyPainter extends CustomPainter {

  MyPainter(this.paintedBoardProvider)
      : super(repaint: paintedBoardProvider){
    paintedBoardProvider.customPainter = this;  // <- 新增
  }

  final PaintedBoardProvider paintedBoardProvider;

  @override
  void paint(Canvas canvas, Size size) {
    paintedBoardProvider.realCanvasSize = size;

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), Paint()..color=Colors.redAccent);  // <- 新增

    canvas.saveLayer(Rect.fromLTWH(0, 0, size.width, size.height), Paint());
    // 获取绘画数据进行绘画
    for (final stroke in paintedBoardProvider.strokes) {
      final paint = Paint()
        ..strokeWidth = stroke.width
        ..color = stroke.color
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke
        ..blendMode = stroke.isClear ? BlendMode.clear : BlendMode.src;  //  <-  新增
      canvas.drawPath(stroke.path, paint);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

