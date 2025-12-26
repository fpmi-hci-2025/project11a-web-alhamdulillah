import 'package:flutter/material.dart';

// Lightweight provider replacement - small utility to avoid external package
class ChangeNotifierProvider extends StatefulWidget {
  final Widget child;
  final ChangeNotifier notifier;
  
  const ChangeNotifierProvider({
    super.key,
    required this.child,
    required this.notifier,
  });
  
  static T of<T extends ChangeNotifier>(BuildContext context) {
    final inherited = context.dependOnInheritedWidgetOfExactType<_Inherited>();
    return inherited!.notifier as T;
  }

  @override
  State<ChangeNotifierProvider> createState() => _ChangeNotifierProviderState();
}

class _ChangeNotifierProviderState extends State<ChangeNotifierProvider> {
  @override
  void initState() {
    super.initState();
    widget.notifier.addListener(_handleChange);
  }

  @override
  void dispose() {
    widget.notifier.removeListener(_handleChange);
    super.dispose();
  }

  void _handleChange() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return _Inherited(
      notifier: widget.notifier,
      child: widget.child,
    );
  }
}

class _Inherited extends InheritedWidget {
  final ChangeNotifier notifier;
  
  const _Inherited({
    super.key,
    required super.child,
    required this.notifier,
  });
  
  @override
  bool updateShouldNotify(covariant _Inherited oldWidget) {
    return notifier != oldWidget.notifier;
  }
}

