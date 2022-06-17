import 'dart:ui' as ui;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:test_flutter/command/invoker.dart';
import 'package:test_flutter/command/painted_command.dart';
import 'package:test_flutter/my_painter.dart';
import 'dart:ui' as UI;

import 'package:test_flutter/painted_board_provider.dart';

enum GestureType {
  translate, // 平移
  scale, // 缩放
}

class HandPaintedBoard extends StatefulWidget {
  const HandPaintedBoard(
    this._paintedBoardProvider,
    this._invoker, {
    // <- 更改
    Key? key,
  }) : super(key: key);
  final PaintedBoardProvider _paintedBoardProvider;
  final Invoker _invoker; // <- 更改

  @override
  _HandPaintedBoardState createState() => _HandPaintedBoardState();
}

class _HandPaintedBoardState extends State<HandPaintedBoard> {
  PaintedBoardProvider get _paintedBoardProvider =>
      widget._paintedBoardProvider;
  // 标识手势
  GestureType _gestureType = GestureType.translate;  // <- 新增
  // 记录缩放开始的缩放
  double _startScale = 1; // <- 新增

  // 记录缩放开始的坐标
  double _startX = 0;    // <- 新增
  double _startY = 0;    // <- 新增
  // 记录缩放开始的偏移量
  double _startTranslationX = 0;    // <- 新增
  double _startTranslationY = 0;    // <- 新增

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleStart: (details) {
        if (details.pointerCount > 1) {  // 双指
          _gestureType = GestureType.scale;
          _startScale = _paintedBoardProvider.scale;
          _startX = details.localFocalPoint.dx;    // <- 新增
          _startY = details.localFocalPoint.dy;    // <- 新增
          _startTranslationX = _paintedBoardProvider.translationX;    // <- 新增
          _startTranslationY = _paintedBoardProvider.translationY;    // <- 新增
        } else { // 单指
          _gestureType = GestureType.translate;
          _paintedBoardProvider.onStart(details.localFocalPoint);
        }
      },
      onScaleUpdate: (details) {
        switch (_gestureType) {
          case GestureType.translate:
            _paintedBoardProvider.onUpdate(details.localFocalPoint);
            break;
          case GestureType.scale:
            if ((details.scale - 1).abs() > 0.1) {
              setState(() {
                _paintedBoardProvider.scale = _startScale + details.scale - 1;
              });
            } else {
              setState(() {
                _paintedBoardProvider.translationX = _startTranslationX +
                    details.localFocalPoint.dx - _startX;
                _paintedBoardProvider.translationY = _startTranslationY +
                    details.localFocalPoint.dy - _startY;
              });
            }
            break;
        }
      },
      onScaleEnd: (details) {
        switch (_gestureType) {
          case GestureType.translate:
            // print("onScaleEnd：移动结束");
            // 移除由于误操作导致的小点出现
            final lastBounds = _paintedBoardProvider.strokes.last.path.getBounds();
            if (lastBounds.width < 0.5 && lastBounds.height < 0.5) {
              _paintedBoardProvider.strokes.removeLast();
              _paintedBoardProvider.refreshPaintedBoard();
            } else {
              widget._invoker.execute(PaintedCommand(
                  _paintedBoardProvider, _paintedBoardProvider.strokes.last));
            }

            break;
          case GestureType.scale:
            print("onScaleEnd：缩放结束");
            break;
        }
      },
      child: Transform(
        alignment: Alignment.center,
        transform: Matrix4(
          _paintedBoardProvider.scale,
          0,
          0,
          0,
          0,
          _paintedBoardProvider.scale,
          0,
          0,
          0,
          0,
          1,
          0,
          _paintedBoardProvider.translationX,
          _paintedBoardProvider.translationY,
          0,
          1,
        ),
        child: CustomPaint(
          painter: MyPainter(_paintedBoardProvider),
          size: Size.infinite,
        ),
      ),
    );
  }


  @override
  void dispose() {
    _paintedBoardProvider.customPainter = null;
    super.dispose();
  }

}
