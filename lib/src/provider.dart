import 'package:riverpod/riverpod.dart';
import 'package:riverpod_persistence/src/storage.dart';

typedef PersistWriter<T> = void Function(T) Function(Ref);
typedef PersistCreate<P extends AlwaysAliveProviderListenable<T>, T> = P
    Function(
  ProviderBase<T?> initialProvider,
  PersistWriter<T> write,
);

P persistProvider<P extends AlwaysAliveProviderListenable<T>, T>(
  PersistCreate<P, T> create, {
  required Storage<T> Function(Ref ref) buildStorage,
}) {
  final storageProvider = Provider(buildStorage);
  final initialProvider = Provider((ref) => ref.watch(storageProvider).get());

  void Function(T item) write(Ref ref) => ref.read(storageProvider).set;

  return create(initialProvider, write);
}
