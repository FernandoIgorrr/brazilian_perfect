import 'package:brazilian_perfect/src/core/store/store.dart';
import 'package:flutter/material.dart';

abstract class StoreNotify<T> implements Store<T> {
  final _changeNotify = ChangeNotifier();
  T _state;

  StoreNotify(this._state);

  @override
  T get state => _state;

  @override
  void dispatch(T state) {
    _state = state;
    _changeNotify.notifyListeners();
  }

  @override
  StoreDispose connect(void Function(T) listener) {
    void _listener() => listener(state);

    _changeNotify.addListener(_listener);
    return () => _changeNotify.removeListener(_listener);
  }

  @override
  void dispose() {
    _changeNotify.dispose();
  }
}
