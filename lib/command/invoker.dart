

import 'icommand.dart';

class Invoker {
  // 存储命令内容
  late final List<ICommand> _undoCommands = [];
  late final List<ICommand> _redoCommands = [];
  /// 执行
  execute(ICommand command) {
    _undoCommands.add(command);
    command.execute();
  }
  /// 撤销
  undo() {
    if (_undoCommands.isNotEmpty) {
      final last = _undoCommands.last;
      _redoCommands.add(last);
      _undoCommands.remove(last);
      last.undo();
    }
  }
  /// 重制
  redo() {
    if (_redoCommands.isNotEmpty) {
      final last = _redoCommands.last;
      _undoCommands.add(last);
      _redoCommands.remove(last);
      last.execute();
    }
  }
}
