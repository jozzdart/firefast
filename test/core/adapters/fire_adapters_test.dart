import 'dart:convert';
import 'dart:typed_data';
import 'package:test/test.dart';
import 'package:firefast/firefast_core.dart';

void main() {
  group('BoolFireAdapter', () {
    final adapter = BoolFireAdapter();

    test('toFire should return the same value', () async {
      expect(await adapter.toFire(true), equals(true));
      expect(await adapter.toFire(false), equals(false));
      expect(await adapter.toFire(null), equals(null));
    });

    test('fromFire should return the same value', () async {
      expect(await adapter.fromFire(true), equals(true));
      expect(await adapter.fromFire(false), equals(false));
      expect(await adapter.fromFire(null), equals(null));
    });

    test('fromFire should handle non-boolean values gracefully', () async {
      expect(() => adapter.fromFire('true'), throwsA(isA<TypeError>()));
      expect(() => adapter.fromFire(1), throwsA(isA<TypeError>()));
      expect(() => adapter.fromFire(0), throwsA(isA<TypeError>()));
    });
  });

  group('BytesStringFireAdapter', () {
    final adapter = BytesStringFireAdapter();
    final testBytes = Uint8List.fromList([1, 2, 3, 4, 5]);
    final encodedBytes = base64Encode(testBytes);
    final emptyBytes = Uint8List(0);
    final encodedEmptyBytes = base64Encode(emptyBytes);
    final largeBytes = Uint8List.fromList(List.generate(1000, (i) => i % 256));
    final encodedLargeBytes = base64Encode(largeBytes);

    test('toFire should encode Uint8List to base64 string', () async {
      expect(await adapter.toFire(testBytes), equals(encodedBytes));
      expect(await adapter.toFire(null), equals(null));
    });

    test('fromFire should decode base64 string to Uint8List', () async {
      final decoded = await adapter.fromFire(encodedBytes);
      expect(decoded, isA<Uint8List>());
      expect(decoded, equals(testBytes));
      expect(await adapter.fromFire(null), equals(null));
    });

    test('toFire should handle empty bytes', () async {
      expect(await adapter.toFire(emptyBytes), equals(encodedEmptyBytes));
    });

    test('toFire should handle large byte arrays', () async {
      expect(await adapter.toFire(largeBytes), equals(encodedLargeBytes));
    });

    test('fromFire should handle invalid base64 strings', () async {
      expect(() => adapter.fromFire('not base64!'),
          throwsA(isA<FormatException>()));
    });

    test('roundtrip should preserve data integrity for various byte arrays',
        () async {
      for (final bytes in [testBytes, emptyBytes, largeBytes]) {
        final encoded = await adapter.toFire(bytes);
        final decoded = await adapter.fromFire(encoded);
        expect(decoded, equals(bytes));
      }
    });
  });

  group('DoubleFireAdapter', () {
    final adapter = DoubleFireAdapter();

    test('toFire should return the same value', () async {
      expect(await adapter.toFire(3.14), equals(3.14));
      expect(await adapter.toFire(0.0), equals(0.0));
      expect(await adapter.toFire(null), equals(null));
    });

    test('fromFire should return the same value', () async {
      expect(await adapter.fromFire(3.14), equals(3.14));
      expect(await adapter.fromFire(0.0), equals(0.0));
      expect(await adapter.fromFire(null), equals(null));
    });

    test('handles special floating point values', () async {
      expect(await adapter.toFire(double.infinity), equals(double.infinity));
      expect(await adapter.toFire(double.negativeInfinity),
          equals(double.negativeInfinity));
      expect(await adapter.toFire(double.nan), isNaN);
    });

    test('fromFire handles special floating point values', () async {
      expect(await adapter.fromFire(double.infinity), equals(double.infinity));
      expect(await adapter.fromFire(double.negativeInfinity),
          equals(double.negativeInfinity));
      expect(await adapter.fromFire(double.nan), isNaN);
    });

    test('handles very large and very small doubles', () async {
      expect(await adapter.toFire(1.7976931348623157e+308),
          equals(1.7976931348623157e+308)); // Max double
      expect(
          await adapter.toFire(5e-324), equals(5e-324)); // Min positive double
    });

    test('fromFire should handle non-double values gracefully', () async {
      expect(() => adapter.fromFire('3.14'), throwsA(isA<TypeError>()));
      expect(() => adapter.fromFire(true), throwsA(isA<TypeError>()));
    });
  });

  group('IntFireAdapter', () {
    final adapter = IntFireAdapter();

    test('toFire should return the same value', () async {
      expect(await adapter.toFire(42), equals(42));
      expect(await adapter.toFire(0), equals(0));
      expect(await adapter.toFire(null), equals(null));
    });

    test('fromFire should return the same value', () async {
      expect(await adapter.fromFire(42), equals(42));
      expect(await adapter.fromFire(0), equals(0));
      expect(await adapter.fromFire(null), equals(null));
    });

    test('handles extreme integer values', () async {
      expect(await adapter.toFire(9223372036854775807),
          equals(9223372036854775807)); // max int64
      expect(await adapter.toFire(-9223372036854775808),
          equals(-9223372036854775808)); // min int64
    });

    test('fromFire should handle non-integer values gracefully', () async {
      expect(() => adapter.fromFire('42'), throwsA(isA<TypeError>()));
      expect(() => adapter.fromFire(true), throwsA(isA<TypeError>()));
      expect(() => adapter.fromFire(42.5), throwsA(isA<TypeError>()));
    });
  });

  group('StringFireAdapter', () {
    final adapter = StringFireAdapter();

    test('toFire should return the same value', () async {
      expect(await adapter.toFire('test'), equals('test'));
      expect(await adapter.toFire(''), equals(''));
      expect(await adapter.toFire(null), equals(null));
    });

    test('fromFire should return the same value', () async {
      expect(await adapter.fromFire('test'), equals('test'));
      expect(await adapter.fromFire(''), equals(''));
      expect(await adapter.fromFire(null), equals(null));
    });

    test('handles special characters and unicode', () async {
      const specialString = '!@#\$%^&*()_+{}:"<>?|~`-=[]\\;\',./';
      const unicodeString = '你好, こんにちは, 안녕하세요, مرحبا, שלום';
      const emojiString = '😀 🚀 🌟 🎉 🔥 👍 💯';

      expect(await adapter.toFire(specialString), equals(specialString));
      expect(await adapter.toFire(unicodeString), equals(unicodeString));
      expect(await adapter.toFire(emojiString), equals(emojiString));

      expect(await adapter.fromFire(specialString), equals(specialString));
      expect(await adapter.fromFire(unicodeString), equals(unicodeString));
      expect(await adapter.fromFire(emojiString), equals(emojiString));
    });

    test('handles very long strings', () async {
      final longString = 'a' * 10000;
      expect(await adapter.toFire(longString), equals(longString));
      expect(await adapter.fromFire(longString), equals(longString));
    });

    test('fromFire should handle non-string values gracefully', () async {
      expect(() => adapter.fromFire(42), throwsA(isA<TypeError>()));
      expect(() => adapter.fromFire(true), throwsA(isA<TypeError>()));
    });
  });

  group('MapFireAdapter', () {
    final adapter = MapFireAdapter();
    final testMap = {'key': 'value', 'num': 42};
    final emptyMap = <String, dynamic>{};
    final nestedMap = {
      'string': 'value',
      'number': 42,
      'bool': true,
      'null': null,
      'nested': {'key': 'value'},
      'list': [1, 2, 3]
    };

    test('toFire should return the same map', () async {
      expect(await adapter.toFire(testMap), equals(testMap));
      expect(await adapter.toFire(null), equals(null));
    });

    test('fromFire should return the same map', () async {
      expect(await adapter.fromFire(testMap), equals(testMap));
      expect(await adapter.fromFire(null), equals(null));
    });

    test('handles empty maps', () async {
      expect(await adapter.toFire(emptyMap), equals(emptyMap));
      expect(await adapter.fromFire(emptyMap), equals(emptyMap));
    });

    test('handles nested maps and complex structures', () async {
      expect(await adapter.toFire(nestedMap), equals(nestedMap));
      expect(await adapter.fromFire(nestedMap), equals(nestedMap));
    });

    test('handles maps with special key characters', () async {
      final specialKeysMap = {
        'key-with-dash': 'value',
        'key.with.dots': 'value',
        'key_with_underscore': 'value',
        'key with spaces': 'value',
      };
      expect(await adapter.toFire(specialKeysMap), equals(specialKeysMap));
      expect(await adapter.fromFire(specialKeysMap), equals(specialKeysMap));
    });

    test('fromFire should handle non-map values gracefully', () async {
      expect(() => adapter.fromFire('not a map'), throwsA(isA<TypeError>()));
      expect(() => adapter.fromFire(42), throwsA(isA<TypeError>()));
      expect(() => adapter.fromFire(true), throwsA(isA<TypeError>()));
    });
  });

  group('ListDynamicFireAdapter', () {
    final adapter = ListDynamicFireAdapter();
    final testList = [
      1,
      'string',
      true,
      {'key': 'value'}
    ];
    final emptyList = <dynamic>[];
    final nestedList = [
      1,
      [2, 3],
      [
        4,
        [5, 6]
      ]
    ];
    final largeList = List.generate(1000, (i) => i);

    test('toFire should return the same list', () async {
      expect(await adapter.toFire(testList), equals(testList));
      expect(await adapter.toFire(null), equals(null));
    });

    test('fromFire should return the same list', () async {
      expect(await adapter.fromFire(testList), equals(testList));
      expect(await adapter.fromFire(null), equals(null));
    });

    test('handles empty lists', () async {
      expect(await adapter.toFire(emptyList), equals(emptyList));
      expect(await adapter.fromFire(emptyList), equals(emptyList));
    });

    test('handles nested lists', () async {
      expect(await adapter.toFire(nestedList), equals(nestedList));
      expect(await adapter.fromFire(nestedList), equals(nestedList));
    });

    test('handles large lists', () async {
      expect(await adapter.toFire(largeList), equals(largeList));
      expect(await adapter.fromFire(largeList), equals(largeList));
    });

    test('handles lists with null values', () async {
      final listWithNulls = [1, null, 'string', null, true];
      expect(await adapter.toFire(listWithNulls), equals(listWithNulls));
      expect(await adapter.fromFire(listWithNulls), equals(listWithNulls));
    });

    test('fromFire should handle non-list values gracefully', () async {
      expect(() => adapter.fromFire('not a list'), throwsA(isA<TypeError>()));
      expect(() => adapter.fromFire(42), throwsA(isA<TypeError>()));
      expect(() => adapter.fromFire(true), throwsA(isA<TypeError>()));
    });
  });

  group('DateTimeFireAdapter', () {
    final adapter = DateTimeFireAdapter();
    final testDate = DateTime(2023, 5, 15, 10, 30);
    final epochDate = DateTime.fromMillisecondsSinceEpoch(0);
    final futureDate = DateTime(2100, 1, 1);
    final dateWithMilliseconds = DateTime(2023, 5, 15, 10, 30, 45, 500);
    final dateWithMicroseconds = DateTime(2023, 5, 15, 10, 30, 45, 500, 600);

    test('toFire should encode DateTime to base64 string', () async {
      final encoded = await adapter.toFire(testDate);
      expect(encoded, isA<String>());
      expect(await adapter.toFire(null), equals(null));
    });

    test('fromFire should decode base64 string to DateTime', () async {
      final encoded = await adapter.toFire(testDate);
      final decoded = await adapter.fromFire(encoded);
      expect(decoded, isA<DateTime>());
      expect(decoded, equals(testDate));
      expect(await adapter.fromFire(null), equals(null));
    });

    test('roundtrip conversion preserves DateTime value', () async {
      final encoded = await adapter.toFire(testDate);
      final decoded = await adapter.fromFire(encoded);
      expect(decoded, equals(testDate));
    });

    test('handles epoch date (January 1, 1970)', () async {
      final encoded = await adapter.toFire(epochDate);
      final decoded = await adapter.fromFire(encoded);
      expect(decoded, equals(epochDate));
    });

    test('handles future dates', () async {
      final encoded = await adapter.toFire(futureDate);
      final decoded = await adapter.fromFire(encoded);
      expect(decoded, equals(futureDate));
    });

    test('preserves milliseconds precision', () async {
      final encoded = await adapter.toFire(dateWithMilliseconds);
      final decoded = await adapter.fromFire(encoded);
      expect(decoded?.millisecond, equals(dateWithMilliseconds.millisecond));
      expect(decoded?.millisecondsSinceEpoch,
          equals(dateWithMilliseconds.millisecondsSinceEpoch));
    });

    test('handles microseconds correctly', () async {
      // Note: Firebase typically doesn't store microseconds, so we're testing the behavior
      final encoded = await adapter.toFire(dateWithMicroseconds);
      final decoded = await adapter.fromFire(encoded);
      // Should preserve milliseconds but might lose microseconds
      expect(decoded?.millisecondsSinceEpoch,
          equals(dateWithMicroseconds.millisecondsSinceEpoch));
    });

    test('fromFire should handle invalid encoded values', () async {
      expect(() => adapter.fromFire('not valid base64'),
          throwsA(isA<FormatException>()));
    });
  });

  group('FireAdapterMap', () {
    late TestFireAdapterMap adapterMap;

    setUp(() {
      adapterMap = TestFireAdapterMap.instance;
      adapterMap.registerAll();
    });

    test('registerAll should register all basic adapters', () {
      expect(adapterMap.contains<bool>(), isTrue);
      expect(adapterMap.contains<int>(), isTrue);
      expect(adapterMap.contains<double>(), isTrue);
      expect(adapterMap.contains<String>(), isTrue);
      expect(adapterMap.contains<DateTime>(), isTrue);
      expect(adapterMap.contains<Uint8List>(), isTrue);
      expect(adapterMap.contains<Map<String, dynamic>>(), isTrue);
      expect(adapterMap.contains<List<dynamic>>(), isTrue);
    });

    test('registerAll should register list adapters', () {
      expect(adapterMap.contains<List<bool?>>(), isTrue);
      expect(adapterMap.contains<List<int?>>(), isTrue);
      expect(adapterMap.contains<List<double?>>(), isTrue);
      expect(adapterMap.contains<List<String?>>(), isTrue);
      expect(adapterMap.contains<List<DateTime?>>(), isTrue);
      expect(adapterMap.contains<List<Uint8List?>>(), isTrue);
    });

    test('of should return the correct adapter', () {
      expect(adapterMap.of<bool>(), isA<BoolFireAdapter>());
      expect(adapterMap.of<int>(), isA<IntFireAdapter>());
      expect(adapterMap.of<String>(), isA<StringFireAdapter>());
    });

    test('listOf should return the correct list adapter', () {
      expect(adapterMap.listOf<bool>(), isA<FireAdapter<List<bool?>>>());
      expect(adapterMap.listOf<int>(), isA<FireAdapter<List<int?>>>());
      expect(adapterMap.listOf<String>(), isA<FireAdapter<List<String?>>>());
    });

    test('of should throw StateError for unregistered type', () {
      expect(() => adapterMap.of<Symbol>(), throwsA(isA<StateError>()));
    });

    test('register should not override existing adapter by default', () {
      final customAdapter = CustomBoolFireAdapter();
      expect(adapterMap.of<bool>(), isNot(equals(customAdapter)));
    });

    test('register should override existing adapter when override is true', () {
      final customAdapter = CustomBoolFireAdapter();
      adapterMap.register<bool>(customAdapter, override: true);
      expect(adapterMap.of<bool>(), equals(customAdapter));
    });

    test('registered flag should be set after registerAll', () {
      expect(adapterMap.registered, isTrue);
    });

    test('of should automatically call registerAll if not registered', () {
      final boolAdapter = adapterMap.of<bool>();
      expect(adapterMap.registered, isTrue);
      expect(boolAdapter, isA<BoolFireAdapter>());
    });

    test('listOf should automatically call registerAll if not registered', () {
      final listAdapter = adapterMap.listOf<bool>();
      expect(adapterMap.registered, isTrue);
      expect(listAdapter, isA<FireAdapter<List<bool?>>>());
    });

    test('contains should return false for unregistered types', () {
      expect(adapterMap.contains<Symbol>(), isFalse);
      expect(adapterMap.contains<TestFireAdapterMap>(), isFalse);
    });

    test('performance with multiple adapter lookups', () {
      // Perform multiple lookups and ensure it's reasonably fast
      final stopwatch = Stopwatch()..start();
      for (var i = 0; i < 1000; i++) {
        adapterMap.of<bool>();
        adapterMap.of<int>();
        adapterMap.of<String>();
        adapterMap.of<DateTime>();
      }
      stopwatch.stop();

      // This should be very fast, typically under 50ms
      expect(stopwatch.elapsedMilliseconds, lessThan(500));
    });
  });
}

class TestFireAdapterMap extends FireAdapterMap {
  static TestFireAdapterMap instance = TestFireAdapterMap();
}

class CustomBoolFireAdapter extends BoolFireAdapter {}
