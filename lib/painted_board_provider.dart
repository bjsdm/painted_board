import 'dart:math';

import 'package:flutter/material.dart';

import 'stroke.dart';

class PaintedBoardProvider extends ChangeNotifier {
  // 存储绘画数据
  final List<Stroke> _strokes = [];

  List<Stroke> get strokes => _strokes;

  // 颜色
  var color = Colors.greenAccent;

  // 笔画宽度
  double paintWidth = 3;

  // 是否为橡皮擦
  bool isClear = false;

  // 缩放比例
  double scale = 1;  // <- 新增

  // 偏移量
  double translationX = 0;
  double translationY = 0;

  // 画布原有尺寸
  Size realCanvasSize = Size.zero;

  // 存储当前的绘制
  CustomPainter? customPainter;

  /// 移动开始时
  void onStart(Offset localPosition) {
    double startX = localPosition.dx;
    double startY = localPosition.dy;
    final newStroke = Stroke(
      color: isClear ? Colors.transparent : color,
      width: paintWidth,
      isClear: isClear,
    );
    newStroke.path.moveTo(  // <- 调整
        (startX + (scale - 1) * realCanvasSize.width / 2 - translationX) /
            scale,
        (startY + (scale - 1) * realCanvasSize.height / 2 - translationY) /
            scale);
    _strokes.add(newStroke);
  }

  /// 移动
  void onUpdate(Offset localPosition) {
    _strokes.last.path.lineTo( // <- 调整
        (localPosition.dx +
                (scale - 1) * realCanvasSize.width / 2 -
                translationX) /
            scale,
        (localPosition.dy +
                (scale - 1) * realCanvasSize.height / 2 -
                translationY) /
            scale);
    notifyListeners();
  }

  void clearBoard() {
    _strokes.clear();
    notifyListeners();
  }

  refreshPaintedBoard() {
    notifyListeners();
  }
}
