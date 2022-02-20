import 'package:riverpod_persistence/src/storage.dart';

class TestStorage<T> implements Storage<T> {
  TestStorage(this._value);

  T? _value;

  @override
  T? get() => _value;

  @override
  void set(T item) => _value = item;
}
