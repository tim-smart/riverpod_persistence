import 'package:fpdt/fpdt.dart';
import 'package:fpdt/option.dart' as O;
import 'package:shared_preferences/shared_preferences.dart';

part 'storage/shared_preferences_storage.dart';

typedef ToJson<T> = dynamic Function(T item);
typedef FromJson<T> = T Function(dynamic json);

abstract class Storage<T> {
  T? get();
  void set(T item);
}
