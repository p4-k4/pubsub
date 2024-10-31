import 'package:flutter/material.dart';

class Sub extends StatefulWidget {
  const Sub(this.builder, {super.key});
  final Widget Function(BuildContext context) builder;

  @override
  State<Sub> createState() => SubState();
}

class SubState extends State<Sub> {
  static SubState? _currentState;
  final List<ChangeNotifier> _notifiers = [];

  void addNotifier(ChangeNotifier notifier) {
    if (!_notifiers.contains(notifier)) {
      _notifiers.add(notifier);
      notifier.addListener(_update);
    }
  }

  void _update() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    for (var notifier in _notifiers) {
      notifier.removeListener(_update);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final previousSub = _currentState;
    _currentState = this;
    final result = widget.builder(context);
    _currentState = previousSub;
    return result;
  }
}

abstract class Pub extends ChangeNotifier {
  T get<T>(T value) {
    final currentSub = SubState._currentState;
    if (currentSub != null) {
      currentSub.addNotifier(this);
    }
    return value;
  }
}
