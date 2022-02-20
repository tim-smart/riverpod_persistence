import 'package:riverpod/riverpod.dart';
import 'package:riverpod_persistence/riverpod_persistence.dart';
import 'package:test/test.dart';

import 'test_storage.dart';

class Counter extends StateNotifier<int> {
  Counter(int initialState) : super(initialState);
  void increment() => state = state + 1;
  void decrement() => state = state - 1;
}

final storage = TestStorage(10);

final counterProvider =
    persistProvider<StateNotifierProvider<Counter, int>, int>(
  (read, write) => StateNotifierProvider((ref) {
    final counter = Counter(read(ref) ?? 0);
    counter.addListener(write(ref));
    return counter;
  }),
  buildStorage: (ref) => storage,
);

void main() async {
  group('basic', () {
    test('it works with StateNotifier', () async {
      final container = ProviderContainer();

      // Initial value should have been loaded
      expect(container.read(counterProvider), 10);

      // Test persistence back to storage
      container.read(counterProvider.notifier).increment();
      expect(container.read(counterProvider), 11);
      expect(storage.get(), 11);

      // Refresh the notifier provider and check initial value is updated
      container.refresh(counterProvider);
      expect(container.read(counterProvider), 11);
    });
  });
}
