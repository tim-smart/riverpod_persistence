part of '../storage.dart';

class SharedPreferencesStorage<T> implements Storage<T> {
  const SharedPreferencesStorage({
    required String key,
    required this.toJson,
    required this.fromJson,
    required this.instance,
    String keyPrefix = 'rp_persist_',
  }) : _key = '$keyPrefix$key';

  final String _key;
  final ToJson<T> toJson;
  final FromJson<T> fromJson;
  final SharedPreferences instance;

  @override
  T? get() => O
      .fromNullable(instance.getString(_key))
      .p(O.map(fromJson))
      .p(O.toNullable);

  @override
  void set(item) {
    instance.setString(_key, toJson(item));
  }
}
