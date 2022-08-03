import 'package:riverpod/riverpod.dart';
import 'package:riverpod_persistence/riverpod_persistence.dart';
import 'package:test/test.dart';

import 'test_storage.dart';

class Counter extends StateNotifier<int> {
  Counter(int initialState) : super(initialState);
  void increment() => state = state + 1;
  void decrement() => state = state - 1;
}

final storage = TestStorage<int>();
final storageTwo = TestStorage<int>();

final counterProvider = persistStateNotifierProvider<Counter, int>(
  (ref, initialValue) => Counter(initialValue ?? 0),
  buildStorage: (ref) => storage,
);

final stateProvider = persistStateProvider(
  initialValue: 10,
  buildStorage: (ref) => storageTwo,
);

void main() async {
  group('basic', () {
    test('it works with StateNotifier', () async {
      final container = ProviderContainer();

      // Starts with zero
      expect(container.read(counterProvider), 0);

      // Test persistence back to storage
      container.read(counterProvider.notifier).increment();
      expect(container.read(counterProvider), 1);
      expect(storage.get(), 1);

      // Refresh the notifier provider and check initial value is updated
      container.refresh(counterProvider.notifier);
      expect(container.read(counterProvider), 1);
    });

    test('it works with StateProvider', () async {
      final container = ProviderContainer();

      // Starts with zero
      expect(container.read(stateProvider), 10);

      // Wait for write to be connected
      await Future.microtask(() => null);

      // Test persistence back to storage
      container.read(stateProvider.notifier).update((state) => state + 1);
      expect(container.read(stateProvider), 11);
      expect(storageTwo.get(), 11);

      // Refresh the notifier provider and check initial value is updated
      container.refresh(stateProvider.notifier);
      expect(container.read(stateProvider), 11);
    });
  });
}
