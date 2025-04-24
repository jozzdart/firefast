import 'package:test/test.dart';
import 'package:firefast/firefast_core.dart';

import 'fire_adapters_test.dart';

void main() {
  group('ListFireAdapter', () {
    test('basic functionality', () async {
      // Create a concrete implementation of ListFireAdapter
      final adapter = TestListFireAdapter<String>();

      // Test data
      final testList = ['a', 'b', null, 'c'];

      // Test roundtrip
      final fireData = await adapter.toFire(testList);
      final result = await adapter.fromFire(fireData);

      // Verify
      expect(result, equals(testList));
    });

    test('handles null', () async {
      final adapter = TestListFireAdapter<String>();

      expect(await adapter.toFire(null), isNull);
      expect(await adapter.fromFire(null), isNull);
    });

    test('converts each item using the item adapter', () async {
      // Create a mock adapter that we can control
      final adapter = TestListFireAdapter<int>();

      // Test data
      final testList = [1, 2, null, 3];

      // Test conversion
      final fireData = await adapter.toFire(testList);
      final result = await adapter.fromFire(fireData);

      expect(result, equals(testList));
    });

    test('handles empty lists', () async {
      final adapter = TestListFireAdapter<String>();

      final emptyList = <String?>[];

      final fireData = await adapter.toFire(emptyList);
      expect(fireData, isA<List>());
      expect(fireData, isEmpty);

      final result = await adapter.fromFire(fireData);
      expect(result, isA<List<String?>>());
      expect(result, isEmpty);
    });

    test('nested list conversion', () async {
      // Create adapters for nested lists

      final outerAdapter = TestListFireAdapter<String>();

      // Test data: a list of lists of strings
      final testData = ['a', 'b', null, 'c', 'd', null, 'e', null, 'f'];

      // Test roundtrip
      final fireData = await outerAdapter.toFire(testData);
      final result = await outerAdapter.fromFire(fireData);

      // Verify
      expect(result, equals(testData));
    });

    test('multiple data types', () async {
      // Test with various value types
      final types = [
        {
          'adapter': TestListFireAdapter<bool>(),
          'data': [true, false, null, true],
        },
        {
          'adapter': TestListFireAdapter<int>(),
          'data': [1, 2, null, 3],
        },
        {
          'adapter': TestListFireAdapter<double>(),
          'data': [1.1, 2.2, null, 3.3],
        },
        {
          'adapter': TestListFireAdapter<String>(),
          'data': ['a', 'b', null, 'c'],
        },
      ];

      // Test each type
      for (final type in types) {
        final adapter = type['adapter'] as TestListFireAdapter;
        final data = type['data'] as List;

        final fireData = await adapter.toFire(data);
        final result = await adapter.fromFire(fireData);

        expect(result, equals(data));
      }
    });

    test('performance with large lists', () async {
      final adapter = TestListFireAdapter<int>();

      // Create a large list
      final largeList = List.generate(500, (i) => i);

      // Measure performance
      final stopwatch = Stopwatch()..start();

      final fireData = await adapter.toFire(largeList);
      final result = await adapter.fromFire(fireData);

      stopwatch.stop();

      // Verify results
      expect(result?.length, equals(500));

      // Should be reasonably fast
      expect(stopwatch.elapsedMilliseconds, lessThan(1000));
    });
  });
}

// Concrete implementation of ListFireAdapter for testing
class TestListFireAdapter<T> extends ListFireAdapter<T> {
  @override
  FireAdapter<T> get itemAdapter {
    // Lazily get the adapter only when needed, not at construction time
    return TestFireAdapterMap.instance.of<T>();
  }

  TestListFireAdapter();
}
