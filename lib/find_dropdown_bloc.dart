import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class FindDropdownBloc<T> {
  final textController = TextEditingController();
  final selected$ = BehaviorSubject<T>();
  final _validateMessage$ = BehaviorSubject<String>();

  Stream<String> get validateMessageOut => _validateMessage$;

  FindDropdownBloc({
    T seedValue,
    String Function(T selected) validate,
  }) {
    selected$.add(seedValue);
    if (validate != null) selected$.map(validate).pipe(_validateMessage$);
  }

  void dispose() async {
    textController.dispose();
    selected$.close();

    await _validateMessage$.drain();
    _validateMessage$.close();
  }
}
