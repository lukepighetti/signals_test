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

class FutureSignal<T> extends Signal<Async<T?>> {
  FutureSignal({required this.fetcher}) : super(Uninitialized()) {
    refresh();
  }

  final Future<T> Function() fetcher;

  void refresh() async {
    print('refreshing');

    // !!!!!!!!!!! naively extending Signal doesn't magically setup any kind of reactivity to fetcher()
    final future = fetcher();

    switch (value) {
      case Uninitialized() || Fail():
        value = Loading(null);
        print(value);

      case Success(:final value) || Loading(:final value):
        this.value = Loading(value);
        print(value);
    }

    try {
      value = Success(await future);
      print(value);
    } catch (e) {
      value = Fail(e);
      print(value);
    }
  }
}

sealed class Async<T> {
  Async({required this.complete, required this.shouldLoad});

  final bool complete;
  final bool shouldLoad;
}

class Uninitialized<T> extends Async<T> {
  Uninitialized() : super(complete: false, shouldLoad: false);
}

class Loading<T> extends Async<T> {
  Loading(this.value) : super(complete: false, shouldLoad: false);
  final T value;
}

class Success<T> extends Async<T> {
  Success(this.value) : super(complete: true, shouldLoad: false);
  final T value;
}

class Fail<T> extends Async<T> {
  Fail(this.exception) : super(complete: true, shouldLoad: true);
  final Object exception;
}
