
import '../painted_board_provider.dart';
import '../stroke.dart';
import 'icommand.dart';

class PaintedCommand extends ICommand {
  late Stroke _stroke;
  late PaintedBoardProvider _paintedBoardProvider;

  PaintedCommand(PaintedBoardProvider paintedBoardProvider, Stroke stroke) {
    _paintedBoardProvider = paintedBoardProvider;
    _stroke= stroke;
  }

  @override
  execute() {
    if (!_paintedBoardProvider.strokes.contains(_stroke)) {
      _paintedBoardProvider.strokes.add(_stroke);
    }
    _paintedBoardProvider.refreshPaintedBoard();
  }

  @override
  undo() {
    if (_paintedBoardProvider.strokes.contains(_stroke)) {
      _paintedBoardProvider.strokes.remove(_stroke);
    }
    _paintedBoardProvider.refreshPaintedBoard();
  }
}
