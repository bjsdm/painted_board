import 'package:flutter/material.dart';

class Stroke {
  final path = Path();  // 绘画路径
  Color color;  // 画笔颜色
  double width;  // 画笔粗细
  bool isClear; // 是否为橡皮擦  //  <-  新增

  Stroke({
    this.color = Colors.black,
    this.width = 3,
    this.isClear = false,   //  <-  新增
  });
}