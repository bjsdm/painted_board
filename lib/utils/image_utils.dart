import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class ImageUtils{
  /// 获取绘制的图片
  static Future<ui.Image?> getRenderedImg(CustomPainter? customPainter, Size size) {
    if (customPainter != null) {
      ui.PictureRecorder recorder = ui.PictureRecorder();
      Canvas canvas = Canvas(recorder);
      customPainter.paint(canvas, size);
      return recorder
          .endRecording()
          .toImage(size.width.floor(), size.height.floor());
    }
    return Future.value(null);
  }
}