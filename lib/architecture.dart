import 'package:flutter/material.dart';
import 'package:solidart/solidart.dart';

class Slot extends StatefulWidget {
  const Slot({super.key, required this.builder});

  final WidgetBuilder builder;

  @override
  State<Slot> createState() => _SlotState();
}

class _SlotState extends State<Slot> {
  Widget? _child;

  late final disposer = Effect((dispose) {
    // this is throwing an error on hot reload in some cases
    debugPrint('Effect, isMounted:$mounted');

    setState(() {
      _child = widget.builder(context);
    });
  });

  @override
  void dispose() {
    disposer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _child ?? widget.builder(context);
  }
}
