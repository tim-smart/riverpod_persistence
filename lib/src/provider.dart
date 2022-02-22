import 'package:riverpod/riverpod.dart';
import 'package:riverpod_persistence/src/storage.dart';

typedef PersistReader<T> = T? Function(Ref);
typedef PersistWriter<T> = void Function(T) Function(Ref);
typedef PersistCreate<P extends ProviderBase, T> = P Function(
  PersistReader<T> read,
  PersistWriter<T> write,
);

P persistProvider<P extends ProviderBase, T>(
  PersistCreate<P, T> create, {
  required Storage<T> Function(Ref ref) buildStorage,
}) {
  final storageProvider = Provider(buildStorage);

  T? read(Ref ref) => ref.read(storageProvider).get();
  void Function(T item) write(Ref ref) => ref.watch(storageProvider).set;

  return create(read, write);
}
