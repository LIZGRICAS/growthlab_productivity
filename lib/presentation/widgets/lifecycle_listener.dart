import 'package:flutter/widgets.dart';

/// Widget that notifies [onStateChanged] when the app lifecycle changes.
class LifecycleListener extends StatefulWidget {
  final void Function(AppLifecycleState) onStateChanged;
  final Widget child;

  const LifecycleListener({required this.onStateChanged, required this.child, super.key});

  @override
  State<LifecycleListener> createState() => _LifecycleListenerState();
}

class _LifecycleListenerState extends State<LifecycleListener> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    widget.onStateChanged(state);
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
