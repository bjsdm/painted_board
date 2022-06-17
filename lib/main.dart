import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:test_flutter/command/invoker.dart';
import 'package:test_flutter/hand_painted_board.dart';
import 'package:test_flutter/my_painter.dart';
import 'package:test_flutter/painted_board_provider.dart';
import 'package:test_flutter/utils/image_utils.dart';
import 'dart:ui' as ui;

void main() {
  runApp(const MyHomePage());
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final PaintedBoardProvider _paintedBoardProvider = PaintedBoardProvider();
  final Invoker _invoker = Invoker(); // <- 重点在这里

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          color: Colors.white,
          child: SafeArea(
            child: Flex(
              direction: Axis.vertical,
              children: [
                SizedBox(
                  height: 100,
                  child: Flex(
                    direction: Axis.horizontal,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            print("点击了笔刷");
                            _paintedBoardProvider.isClear = false;
                          },
                          child: const Center(
                            child: Text("笔刷"),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            print("点击了重置");
                            _paintedBoardProvider.clearBoard();
                          },
                          child: const Center(
                            child: Text("重置"),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            print("点击了橡皮擦");
                            _paintedBoardProvider.isClear = true;
                          },
                          child: const Center(
                            child: Text("橡皮擦"),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            print("点击了 undo");
                            _invoker.undo(); //  <-  新增
                          },
                          child: const Center(
                            child: Text("undo"),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            print("点击了redo");
                            _invoker.redo(); //  <-  新增
                          },
                          child: const Center(
                            child: Text("redo"),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            ImageUtils.getRenderedImg(
                                    _paintedBoardProvider.customPainter,
                                    _paintedBoardProvider.realCanvasSize)
                                .then((image) async {
                              if (image == null) {
                                return;
                              } else {
                                var pngBytes = await image.toByteData(
                                    format: ui.ImageByteFormat.png);
                                ImageGallerySaver.saveImage(
                                    pngBytes!.buffer.asUint8List());
                              }
                            });
                          },
                          child: const Center(
                            child: Text("save"),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                    child: HandPaintedBoard(_paintedBoardProvider, _invoker)),
                // <- 重点在这里
              ],
            ),
          ),
        ),
      ),
    );
  }
}
