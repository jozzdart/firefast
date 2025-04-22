import 'package:flutter_test/flutter_test.dart';
import 'package:firefast/firefast_core.dart';

void main() {
  group('FireFieldOutput', () {
    group('constructor', () {
      test('sets properties correctly', () {
        // Arrange
        final field = FireField<String>(
          name: 'testField',
          toFire: () async => 'testValue',
          fromFire: (dynamic value) => value.toString(),
        );
        const value = 'testValue';

        // Act
        final output = FireFieldOutput<String>(
          source: field,
          value: value,
        );

        // Assert
        expect(output.source, equals(field));
        expect(output.value, equals(value));
      });

      test('works with different types - int', () {
        // Arrange
        final field = FireField<int>(
          name: 'intField',
          toFire: () async => 42,
          fromFire: (dynamic value) => value as int,
        );
        const value = 42;

        // Act
        final output = FireFieldOutput<int>(
          source: field,
          value: value,
        );

        // Assert
        expect(output.source, equals(field));
        expect(output.value, equals(value));
      });

      test('works with different types - bool', () {
        // Arrange
        final field = FireField<bool>(
          name: 'boolField',
          toFire: () async => true,
          fromFire: (dynamic value) => value as bool,
        );
        const value = true;

        // Act
        final output = FireFieldOutput<bool>(
          source: field,
          value: value,
        );

        // Assert
        expect(output.source, equals(field));
        expect(output.value, equals(value));
      });

      test('works with different types - Map', () {
        // Arrange
        final complexObject = {
          'key': 'value',
          'nested': {'data': 123}
        };
        final field = FireField<Map<String, dynamic>>(
          name: 'mapField',
          toFire: () async => complexObject,
          fromFire: (dynamic value) => value as Map<String, dynamic>,
        );

        // Act
        final output = FireFieldOutput<Map<String, dynamic>>(
          source: field,
          value: complexObject,
        );

        // Assert
        expect(output.source, equals(field));
        expect(output.value, equals(complexObject));
      });

      test('works with different types - List', () {
        // Arrange
        final listValue = [1, 2, 3, 4, 5];
        final field = FireField<List<int>>(
          name: 'listField',
          toFire: () async => listValue,
          fromFire: (dynamic value) => (value as List).cast<int>(),
        );

        // Act
        final output = FireFieldOutput<List<int>>(
          source: field,
          value: listValue,
        );

        // Assert
        expect(output.source, equals(field));
        expect(output.value, equals(listValue));
      });

      test('works with null value', () {
        // Arrange
        final field = FireField<String?>(
          name: 'nullableField',
          toFire: () async => null,
          fromFire: (dynamic value) => value as String?,
        );
        String? value;

        // Act
        final output = FireFieldOutput<String?>(
          source: field,
          value: value,
        );

        // Assert
        expect(output.source, equals(field));
        expect(output.value, isNull);
      });

      test('works with empty string value', () {
        // Arrange
        final field = FireField<String>(
          name: 'emptyStringField',
          toFire: () async => '',
          fromFire: (dynamic value) => value.toString(),
        );
        const value = '';

        // Act
        final output = FireFieldOutput<String>(
          source: field,
          value: value,
        );

        // Assert
        expect(output.source, equals(field));
        expect(output.value, isEmpty);
      });
    });

    group('fieldName getter', () {
      test('returns the name of the source field', () {
        // Arrange
        const fieldName = 'testFieldName';
        final field = FireField<String>(
          name: fieldName,
          toFire: () async => 'value',
          fromFire: (dynamic value) => value.toString(),
        );

        final output = FireFieldOutput<String>(
          source: field,
          value: 'value',
        );

        // Act
        final result = output.fieldName;

        // Assert
        expect(result, equals(fieldName));
      });

      test('returns empty string when source field name is empty', () {
        // Arrange
        const fieldName = '';
        final field = FireField<String>(
          name: fieldName,
          toFire: () async => 'value',
          fromFire: (dynamic value) => value.toString(),
        );

        final output = FireFieldOutput<String>(
          source: field,
          value: 'value',
        );

        // Act
        final result = output.fieldName;

        // Assert
        expect(result, isEmpty);
      });

      test('returns correct name with special characters', () {
        // Arrange
        const fieldName = 'field.with.special\$chars';
        final field = FireField<String>(
          name: fieldName,
          toFire: () async => 'value',
          fromFire: (dynamic value) => value.toString(),
        );

        final output = FireFieldOutput<String>(
          source: field,
          value: 'value',
        );

        // Act
        final result = output.fieldName;

        // Assert
        expect(result, equals(fieldName));
      });
    });

    test('can be constructed with a different type than the source field', () {
      // This is a type-checking test
      // The test passes if it compiles successfully

      // Arrange
      final field = FireField<num>(
        name: 'numField',
        toFire: () async => 42,
        fromFire: (dynamic value) => value as num,
      );

      // Act - Explicitly using int which is a subtype of num
      final output = FireFieldOutput<num>(
        source: field,
        value: 42,
      );

      // Assert
      expect(output.value, isA<int>());
    });
  });
}
