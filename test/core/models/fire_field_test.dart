import 'package:firefast/firefast_core.dart';
import 'package:test/test.dart';

void main() {
  group('FireField', () {
    test('constructor initializes properties correctly', () {
      const fieldName = 'testField';
      toFireFn() async => 'test value';
      fromFireFn(dynamic value) => value as String;

      final field = FireField<String>(
        name: fieldName,
        toFire: toFireFn,
        fromFire: fromFireFn,
      );

      expect(field.name, equals(fieldName));
      expect(field.toFire, equals(toFireFn));
      expect(field.fromFire, equals(fromFireFn));
    });

    test('toFire delegate returns expected value', () async {
      final expectedValue = 42;
      final field = FireField<int>(
        name: 'counter',
        toFire: () async => expectedValue,
        fromFire: (dynamic value) => value as int,
      );

      final result = await field.toFire();
      expect(result, equals(expectedValue));
    });

    test('fromFire delegate converts value correctly', () {
      final field = FireField<String>(
        name: 'name',
        toFire: () async => 'John',
        fromFire: (dynamic value) => value.toString().toUpperCase(),
      );

      final result = field.fromFire('john');
      expect(result, equals('JOHN'));
    });

    test('fromFire handles expected input types', () {
      // String field
      final stringField = FireField<String>(
        name: 'text',
        toFire: () async => 'value',
        fromFire: (dynamic value) => value as String,
      );
      expect(stringField.fromFire('test string'), equals('test string'));

      // Integer field
      final intField = FireField<int>(
        name: 'count',
        toFire: () async => 1,
        fromFire: (dynamic value) => value as int,
      );
      expect(intField.fromFire(123), equals(123));

      // Boolean field
      final boolField = FireField<bool>(
        name: 'isActive',
        toFire: () async => true,
        fromFire: (dynamic value) => value as bool,
      );
      expect(boolField.fromFire(true), isTrue);

      // Map field
      final mapField = FireField<Map<String, dynamic>>(
        name: 'metadata',
        toFire: () async => {'key': 'value'},
        fromFire: (dynamic value) => value as Map<String, dynamic>,
      );

      final testMap = {'test': 123, 'other': true};
      expect(mapField.fromFire(testMap), equals(testMap));

      // List field
      final listField = FireField<List<String>>(
        name: 'tags',
        toFire: () async => ['a', 'b'],
        fromFire: (dynamic value) => (value as List).cast<String>(),
      );

      final testList = ['tag1', 'tag2', 'tag3'];
      expect(listField.fromFire(testList), equals(testList));
    });

    test('fromFire throws when receiving incompatible types', () {
      final intField = FireField<int>(
        name: 'count',
        toFire: () async => 1,
        fromFire: (dynamic value) => value as int,
      );

      expect(() => intField.fromFire('not an int'), throwsA(isA<TypeError>()));
    });

    test('handles null values correctly', () {
      final nullableField = FireField<String?>(
        name: 'nullable',
        toFire: () async => null,
        fromFire: (dynamic value) => value as String?,
      );

      expect(nullableField.fromFire(null), isNull);
    });

    test('complex conversion in fromFire works correctly', () {
      final dateField = FireField<DateTime>(
        name: 'timestamp',
        toFire: () async => DateTime.now().millisecondsSinceEpoch,
        fromFire: (dynamic value) =>
            DateTime.fromMillisecondsSinceEpoch(value as int),
      );

      final timestamp = 1625097600000; // 2021-07-01T00:00:00.000Z
      final expectedDate = DateTime.fromMillisecondsSinceEpoch(timestamp);

      expect(dateField.fromFire(timestamp), equals(expectedDate));
    });
  });
}
