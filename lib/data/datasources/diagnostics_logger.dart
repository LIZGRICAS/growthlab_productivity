import 'dart:async';

class DiagnosticsEntry {
  final DateTime time;
  final String message;
  final String level;

  DiagnosticsEntry(this.message, {this.level = 'info'}) : time = DateTime.now();
}

class DiagnosticsLogger {
  static final _controller = StreamController<DiagnosticsEntry>.broadcast();
  static final List<DiagnosticsEntry> _buffer = [];

  static Stream<DiagnosticsEntry> get stream => _controller.stream;

  static List<DiagnosticsEntry> get snapshot => List.unmodifiable(_buffer);

  static void log(String message, {String level = 'info'}) {
    final e = DiagnosticsEntry(message, level: level);
    _buffer.insert(0, e);
    _controller.add(e);
  }

  static void clear() {
    _buffer.clear();
    // Emit a clear marker
    _controller.add(DiagnosticsEntry('--- cleared ---', level: 'meta'));
  }

  static void dispose() {
    _controller.close();
  }
}
