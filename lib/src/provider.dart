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

StateProvider<A> persistStateProvider<A>({
  required A initialValue,
  required Storage<A> Function(Ref ref) buildStorage,
}) =>
    persistProvider<StateProvider<A>, A>(
      (read, write) => StateProvider((ref) {
        Future.microtask(() => ref.controller.addListener(write(ref)));
        return read(ref) ?? initialValue;
      }),
      buildStorage: buildStorage,
    );

typedef StateNotifierCreate<Notifier extends StateNotifier<A>, A> = Notifier
    Function(StateNotifierProviderRef<Notifier, A> ref, A? initialValue);

StateNotifierProvider<Notifier, A>
    persistStateNotifierProvider<Notifier extends StateNotifier<A>, A>(
  StateNotifierCreate<Notifier, A> create, {
  required Storage<A> Function(Ref ref) buildStorage,
}) =>
        persistProvider<StateNotifierProvider<Notifier, A>, A>(
          (read, write) => StateNotifierProvider((ref) {
            final n = create(ref, read(ref));
            n.addListener(write(ref));
            return n;
          }),
          buildStorage: buildStorage,
        );
