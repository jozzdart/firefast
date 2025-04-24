import 'package:flutter/foundation.dart';
import 'package:test/test.dart';
import 'package:firefast/firefast_core.dart';

import '../adapters/fire_adapters_test.dart';

// Import TestFireField from fire_field_test.dart
import 'fire_field_test.dart';

void main() {
  group('FireSet', () {
    late TestFireAdapterMap adapterMap;

    setUp(() {
      // Ensure adapter map is initialized once
      adapterMap = TestFireAdapterMap.instance;
      adapterMap.registerAll();
    });

    test('should initialize with field list', () {
      final stringField = TestFireField<String>(
        'stringField',
        receiveData: () async => 'test-data',
        onFetched: (_) async {},
      );

      final intField = TestFireField<int>(
        'intField',
        receiveData: () async => 42,
        onFetched: (_) async {},
      );

      final fireSet = FireSet(fields: [stringField, intField]);

      expect(fireSet.fields.length, equals(2));
      expect(fireSet.fields[0], equals(stringField));
      expect(fireSet.fields[1], equals(intField));
    });

    test('toMap should convert fields to Firebase-compatible map', () async {
      final stringField = TestFireField<String>(
        'stringField',
        receiveData: () async => 'test-data',
        onFetched: (_) async {},
      );

      final intField = TestFireField<int>(
        'intField',
        receiveData: () async => 42,
        onFetched: (_) async {},
      );

      final boolField = TestFireField<bool>(
        'boolField',
        receiveData: () async => true,
        onFetched: (_) async {},
      );

      final fireSet = FireSet(fields: [stringField, intField, boolField]);

      final map = await fireSet.toMap();

      expect(map, isA<Map<String, dynamic>>());
      debugPrint(map.toString());
      expect(map['stringField'], equals('test-data'));
      expect(map['intField'], equals(42));
      expect(map['boolField'], equals(true));
    });

    test('fromMap should populate field values from Firebase data', () async {
      String? stringValue;
      int? intValue;

      final stringField = TestFireField<String>(
        'stringField',
        receiveData: () async => 'initial',
        onFetched: (value) async {
          stringValue = value;
        },
      );

      final intField = TestFireField<int>(
        'intField',
        receiveData: () async => 0,
        onFetched: (value) async {
          intValue = value;
        },
      );

      final fireSet = FireSet(fields: [stringField, intField]);

      final inputMap = {
        'stringField': 'test value',
        'intField': 99,
      };

      final output = await fireSet.fromMap(inputMap);

      expect(output, isA<FireSetOutput>());
      expect(output?.fields['stringField'], equals('test value'));
      expect(output?.fields['intField'], equals(99));
      expect(stringValue, equals('test value'));
      expect(intValue, equals(99));
    });

    test('fromMap should handle missing fields gracefully', () async {
      String? stringValue = 'initial';
      int? intValue = 0;

      final stringField = TestFireField<String>(
        'stringField',
        receiveData: () async => stringValue,
        onFetched: (value) async {
          stringValue = value;
        },
      );

      final intField = TestFireField<int>(
        'intField',
        receiveData: () async => intValue,
        onFetched: (value) async {
          intValue = value;
        },
      );

      final fireSet = FireSet(fields: [stringField, intField]);

      // Map with only one field
      final inputMap = {
        'stringField': 'updated',
      };

      final output = await fireSet.fromMap(inputMap);

      expect(output, isA<FireSetOutput>());
      expect(output?.fields['stringField'], equals('updated'));
      expect(output?.fields.containsKey('intField'), isFalse);
      expect(stringValue, equals('updated'));
      expect(intValue, equals(0)); // Should remain unchanged
    });

    test('should handle null map in fromMap', () async {
      String? stringValue = 'initial';

      final stringField = TestFireField<String>(
        'stringField',
        receiveData: () async => stringValue,
        onFetched: (value) async {
          stringValue = value;
        },
      );

      final fireSet = FireSet(fields: [stringField]);

      final output = await fireSet.fromMap(null);

      expect(output, isNull);
      expect(stringValue, equals('initial')); // Should remain unchanged
    });

    test('should handle empty map in fromMap', () async {
      String? stringValue = 'initial';

      final stringField = TestFireField<String>('stringField',
          receiveData: () async => stringValue,
          onFetched: (value) async {
            stringValue = value;
          });

      final fireSet = FireSet(fields: [stringField]);

      final output = await fireSet.fromMap({});

      expect(output?.fields.isEmpty, isTrue);
      expect(stringValue, equals('initial')); // Should remain unchanged
    });

    test('toMap should respect isValid field property', () async {
      final validField = TestFireField<String>(
        'validField',
        receiveData: () async => 'valid',
        onFetched: (_) async {},
        isValid: (value) async => true,
      );

      final invalidField = TestFireField<String>(
        'invalidField',
        receiveData: () async => 'invalid',
        onFetched: (_) async {},
        isValid: (value) async => false, // Always invalid
      );

      final fireSet = FireSet(fields: [validField, invalidField]);

      final map = await fireSet.toMap();

      expect(map.containsKey('validField'), isTrue);
      expect(map.containsKey('invalidField'), isFalse);
    });

    test('toMap should respect shouldCancelAll field property', () async {
      final normalField = TestFireField<String>(
        'normalField',
        receiveData: () async => 'normal',
        onFetched: (_) async {},
      );

      final cancelField = TestFireField<String>(
        'cancelField',
        receiveData: () async => 'cancel',
        onFetched: (_) async {},
        shouldCancelAll: (value) async => true, // Always cancels
      );

      final fireSet = FireSet(fields: [normalField, cancelField]);

      final map = await fireSet.toMap();

      expect(map.isEmpty, isTrue);
    });

    test('copyWith should create a new FireSet with updated fields', () {
      final field1 = TestFireField<String>(
        'field1',
        receiveData: () async => 'value1',
        onFetched: (_) async {},
      );

      final field2 = TestFireField<String>(
        'field2',
        receiveData: () async => 'value2',
        onFetched: (_) async {},
      );

      final fireSet = FireSet(fields: [field1]);
      final updatedFireSet = fireSet.copyWith(fields: [field1, field2]);

      expect(updatedFireSet.fields.length, equals(2));
      expect(updatedFireSet.fields[0], equals(field1));
      expect(updatedFireSet.fields[1], equals(field2));

      // Original should be unchanged
      expect(fireSet.fields.length, equals(1));
    });

    test('addField should add a field to the FireSet', () {
      final field1 = TestFireField<String>(
        'field1',
        receiveData: () async => 'value1',
        onFetched: (_) async {},
      );

      final field2 = TestFireField<String>(
        'field2',
        receiveData: () async => 'value2',
        onFetched: (_) async {},
      );

      final fireSet = FireSet(fields: [field1]);
      final updatedFireSet = fireSet.addField(field2);

      expect(updatedFireSet.fields.length, equals(2));
      expect(updatedFireSet.fields[0], equals(field1));
      expect(updatedFireSet.fields[1], equals(field2));

      // Original should be unchanged
      expect(fireSet.fields.length, equals(1));
    });

    test('addFields should add multiple fields to the FireSet', () {
      final field1 = TestFireField<String>(
        'field1',
        receiveData: () async => 'value1',
        onFetched: (_) async {},
      );

      final field2 = TestFireField<String>(
        'field2',
        receiveData: () async => 'value2',
        onFetched: (_) async {},
      );

      final field3 = TestFireField<String>(
        'field3',
        receiveData: () async => 'value3',
        onFetched: (_) async {},
      );

      final fireSet = FireSet(fields: [field1]);
      final updatedFireSet = fireSet.addFields([field2, field3]);

      expect(updatedFireSet.fields.length, equals(3));
      expect(updatedFireSet.fields[0], equals(field1));
      expect(updatedFireSet.fields[1], equals(field2));
      expect(updatedFireSet.fields[2], equals(field3));

      // Original should be unchanged
      expect(fireSet.fields.length, equals(1));
    });

    test('handles complex nested data structures', () async {
      // Create a field for a list of strings
      final listField = TestFireField<List<String?>>(
        'listField',
        receiveData: () async => ['a', 'b', null, 'c'],
        onFetched: (value) async {
          expect(value, ['a', 'b', null, 'c']);
        },
      );

      // Create a field for a map
      final mapField = TestFireField<Map<String, dynamic>>(
        'mapField',
        receiveData: () async => {
          'key1': 'value1',
          'key2': 42,
          'nested': {'inner': 'value'}
        },
        onFetched: (value) async {
          final ex = {
            'key1': 'value1',
            'key2': 42,
            'nested': {'inner': 'value'}
          };
          expect(value, ex);
        },
      );

      final fireSet = FireSet(fields: [listField, mapField]);

      // Convert to map
      final map = await fireSet.toMap();

      expect(map['listField'], equals(['a', 'b', null, 'c']));
      expect(
          map['mapField'],
          equals({
            'key1': 'value1',
            'key2': 42,
            'nested': {'inner': 'value'}
          }));

      // Create a new FireSet and populate from the map
      List<String?>? newListValue;
      Map<String, dynamic>? newMapValue;

      final newListField = TestFireField<List<String?>>(
        'listField',
        receiveData: () async => null,
        onFetched: (value) async {
          newListValue = value;
        },
      );

      final newMapField = TestFireField<Map<String, dynamic>>(
        'mapField',
        receiveData: () async => null,
        onFetched: (value) async {
          newMapValue = value;
        },
      );

      final newFireSet = FireSet(fields: [newListField, newMapField]);

      await newFireSet.fromMap(map);

      expect(newListValue, equals(['a', 'b', null, 'c']));
      expect(
          newMapValue,
          equals({
            'key1': 'value1',
            'key2': 42,
            'nested': {'inner': 'value'}
          }));
    });

    test('handles null values in fields', () async {
      String? nullableValue;

      final nullableField = TestFireField<String>(
        'nullableField',
        receiveData: () async => null,
        onFetched: (value) async {
          nullableValue = value;
        },
      );

      final fireSet = FireSet(fields: [nullableField]);

      final map = await fireSet.toMap();
      expect(map['nullableField'], isNull);

      final inputMap = {
        'nullableField': null,
      };

      await fireSet.fromMap(inputMap);
      expect(nullableValue, isNull);
    });
  });
}
