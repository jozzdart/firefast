import 'package:firefast/firefast_core.dart';
import 'package:test/test.dart';

class TestPath extends PathSegment {
  const TestPath() : super('test');
}

void main() {
  group('FireFieldsOutput', () {
    late FireField<String> nameField;
    late FireField<int> ageField;
    late FireField<bool> activeField;
    late TestPath testPath;
    late FireFieldOutput<String> nameOutput;
    late FireFieldOutput<int> ageOutput;
    late FireFieldOutput<bool> activeOutput;
    late FireFieldsOutput<TestPath> fieldsOutput;

    setUp(() {
      nameField = FireField<String>(
        name: 'name',
        toFire: () async => 'John Doe',
        fromFire: (dynamic value) => value as String,
      );

      ageField = FireField<int>(
        name: 'age',
        toFire: () async => 30,
        fromFire: (dynamic value) => value as int,
      );

      activeField = FireField<bool>(
        name: 'active',
        toFire: () async => true,
        fromFire: (dynamic value) => value as bool,
      );

      testPath = const TestPath();

      nameOutput = FireFieldOutput(source: nameField, value: 'Jane Smith');
      ageOutput = FireFieldOutput(source: ageField, value: 25);
      activeOutput = FireFieldOutput(source: activeField, value: false);

      fieldsOutput = FireFieldsOutput<TestPath>(
        source: testPath,
        fields: [nameOutput, ageOutput, activeOutput],
      );
    });

    test('constructor initializes properties correctly', () {
      expect(fieldsOutput.source, equals(testPath));
      expect(fieldsOutput.fields, hasLength(3));
      expect(fieldsOutput.fields, contains(nameOutput));
      expect(fieldsOutput.fields, contains(ageOutput));
      expect(fieldsOutput.fields, contains(activeOutput));
    });

    test('get returns correct value for a field', () {
      final name = fieldsOutput.get(nameField);
      final age = fieldsOutput.get(ageField);
      final active = fieldsOutput.get(activeField);

      expect(name, equals('Jane Smith'));
      expect(age, equals(25));
      expect(active, equals(false));
    });

    test('get returns null for a non-existent field', () {
      final nonExistentField = FireField<String>(
        name: 'nonExistent',
        toFire: () async => '',
        fromFire: (dynamic value) => value as String,
      );

      final value = fieldsOutput.get(nonExistentField);

      expect(value, isNull);
    });

    test('get returns null for a field with incorrect type', () {
      // This test verifies that the type casting safety works correctly
      // Creating a field with the same name but different type
      final wrongTypeField = FireField<double>(
        name: 'age', // Same name as ageField, but different type
        toFire: () async => 0.0,
        fromFire: (dynamic value) => value as double,
      );

      // This should return null because the value can't be cast to double
      final value = fieldsOutput.get(wrongTypeField);

      expect(value, isNull);
    });

    test('getValue returns correct value for a field name', () {
      final name = fieldsOutput.getValue<String>('name');
      final age = fieldsOutput.getValue<int>('age');
      final active = fieldsOutput.getValue<bool>('active');

      expect(name, equals('Jane Smith'));
      expect(age, equals(25));
      expect(active, equals(false));
    });

    test('getValue returns null for a non-existent field name', () {
      final value = fieldsOutput.getValue<String>('nonExistent');

      expect(value, isNull);
    });

    test('getValue returns null for a field with incorrect type', () {
      // Trying to get 'age' as a String, should return null
      final value = fieldsOutput.getValue<String>('age');

      expect(value, isNull);
    });

    test('toMap converts all fields to a map correctly', () {
      final map = fieldsOutput.toMap();

      expect(map, isA<Map<String, dynamic>>());
      expect(map.length, equals(3));
      expect(map['name'], equals('Jane Smith'));
      expect(map['age'], equals(25));
      expect(map['active'], equals(false));
    });

    test('works with empty fields list', () {
      final emptyOutput = FireFieldsOutput<TestPath>(
        source: testPath,
        fields: [],
      );

      expect(emptyOutput.fields, isEmpty);
      expect(emptyOutput.get(nameField), isNull);
      expect(emptyOutput.getValue<String>('name'), isNull);
      expect(emptyOutput.toMap(), isEmpty);
    });

    test('works with fields having duplicate names', () {
      // In a real application this would be a mistake, but the class should handle it gracefully
      final duplicateNameField = FireField<String>(
        name: 'name', // Same name as nameField
        toFire: () async => 'Duplicate',
        fromFire: (dynamic value) => value as String,
      );

      final duplicateOutput = FireFieldOutput(
        source: duplicateNameField,
        value: 'Duplicate Value',
      );

      // Add the duplicate field output
      final outputWithDuplicate = FireFieldsOutput<TestPath>(
        source: testPath,
        fields: [nameOutput, duplicateOutput, ageOutput],
      );

      // According to the implementation, get() and getValue() should return the first match
      expect(outputWithDuplicate.get(nameField), equals('Jane Smith'));
      expect(
          outputWithDuplicate.getValue<String>('name'), equals('Jane Smith'));

      // The toMap will have an issue with duplicates as it creates a map with field names as keys
      final map = outputWithDuplicate.toMap();
      expect(map.length, equals(2)); // Only 2 keys because 'name' is duplicated

      // Let's make sure the logic for accessing by field reference works correctly
      expect(outputWithDuplicate.get(duplicateNameField),
          equals('Duplicate Value'));
    });

    test('handles complex nested data structures', () {
      final metadataField = FireField<Map<String, dynamic>>(
        name: 'metadata',
        toFire: () async => {'key': 'value'},
        fromFire: (dynamic value) => value as Map<String, dynamic>,
      );

      final metadataValue = {
        'created': 1625097600000,
        'tags': ['important', 'user'],
        'counts': {'views': 100, 'likes': 42},
      };

      final metadataOutput = FireFieldOutput(
        source: metadataField,
        value: metadataValue,
      );

      final complexOutput = FireFieldsOutput<TestPath>(
        source: testPath,
        fields: [nameOutput, metadataOutput],
      );

      final retrievedMetadata = complexOutput.get(metadataField);

      expect(retrievedMetadata, isA<Map<String, dynamic>>());
      expect(retrievedMetadata, equals(metadataValue));
      expect(retrievedMetadata?['created'], equals(1625097600000));
      expect(retrievedMetadata?['tags'][1], equals('user'));
      expect(retrievedMetadata?['counts']['likes'], equals(42));
    });

    test('handles null values correctly', () {
      final nullableField = FireField<String?>(
        name: 'nullable',
        toFire: () async => null,
        fromFire: (dynamic value) => value as String?,
      );

      final nullOutput = FireFieldOutput(
        source: nullableField,
        value: null,
      );

      final outputWithNull = FireFieldsOutput<TestPath>(
        source: testPath,
        fields: [nameOutput, nullOutput],
      );

      expect(outputWithNull.get(nullableField), isNull);
      expect(outputWithNull.getValue<String?>('nullable'), isNull);

      final map = outputWithNull.toMap();
      expect(map.containsKey('nullable'), isTrue);
      expect(map['nullable'], isNull);
    });
  });
}
