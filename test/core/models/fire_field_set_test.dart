import 'package:firefast/firefast_core.dart';
import 'package:test/test.dart';

class TestPath extends PathSegment {
  const TestPath() : super('test');
}

void main() {
  group('FireFieldSet', () {
    late FireField<String> nameField;
    late FireField<int> ageField;
    late FireField<bool> activeField;
    late FireFieldSet<TestPath> fieldSet;
    late TestPath testPath;

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

      fieldSet = FireFieldSet<TestPath>(
        fields: [nameField, ageField, activeField],
      );

      testPath = const TestPath();
    });

    test('constructor initializes properties correctly', () {
      expect(fieldSet.fields, hasLength(3));
      expect(fieldSet.fields[0], equals(nameField));
      expect(fieldSet.fields[1], equals(ageField));
      expect(fieldSet.fields[2], equals(activeField));
    });

    test('toMap converts all fields to a map correctly', () async {
      final map = await fieldSet.toMap();

      expect(map, isA<Map<String, dynamic>>());
      expect(map.length, equals(3));
      expect(map['name'], equals('John Doe'));
      expect(map['age'], equals(30));
      expect(map['active'], equals(true));
    });

    test('toMap handles empty field sets', () async {
      final emptyFieldSet = FireFieldSet<TestPath>(fields: []);
      final map = await emptyFieldSet.toMap();

      expect(map, isEmpty);
    });

    test('fromMap extracts values correctly', () async {
      final sourceMap = {
        'name': 'Jane Smith',
        'age': 25,
        'active': false,
      };

      final output = await fieldSet.fromMap(sourceMap, testPath);

      expect(output, isA<FireFieldsOutput<TestPath>>());
      expect(output.source, equals(testPath));
      expect(output.fields, hasLength(3));

      final nameOutput = output.get(nameField);
      final ageOutput = output.get(ageField);
      final activeOutput = output.get(activeField);

      expect(nameOutput, equals('Jane Smith'));
      expect(ageOutput, equals(25));
      expect(activeOutput, equals(false));
    });

    test('fromMap skips missing fields', () async {
      final partialMap = {
        'name': 'Jane Smith',
        // age is missing
        'active': false,
      };

      final output = await fieldSet.fromMap(partialMap, testPath);

      expect(output.fields, hasLength(2));
      expect(output.get(nameField), equals('Jane Smith'));
      expect(output.get(ageField), isNull);
      expect(output.get(activeField), equals(false));
    });

    test('fromMap handles empty input map', () async {
      final emptyMap = <String, dynamic>{};
      final output = await fieldSet.fromMap(emptyMap, testPath);

      expect(output.fields, isEmpty);
      expect(output.get(nameField), isNull);
      expect(output.get(ageField), isNull);
      expect(output.get(activeField), isNull);
    });

    test('fromMap handles null values in input map', () async {
      final mapWithNulls = {
        'name': null,
        'age': 25,
        'active': null,
      };

      // This test assumes that the FireField implementation handles null values
      // If not, it would need to be adjusted based on expected behavior
      final output = await fieldSet.fromMap(mapWithNulls, testPath);

      expect(output.fields, hasLength(1)); // Only age should be included
      expect(output.get(nameField), isNull);
      expect(output.get(ageField), equals(25));
      expect(output.get(activeField), isNull);
    });

    test('copyWith creates a new instance with updated fields', () {
      final newField = FireField<double>(
        name: 'score',
        toFire: () async => 4.5,
        fromFire: (dynamic value) => value as double,
      );

      final updatedFieldSet = fieldSet.copyWith(
        fields: [newField],
      );

      expect(updatedFieldSet, isNot(same(fieldSet)));
      expect(updatedFieldSet.fields, hasLength(1));
      expect(updatedFieldSet.fields[0], equals(newField));
    });

    test('copyWith without parameters returns a copy with same fields', () {
      final updatedFieldSet = fieldSet.copyWith();

      expect(updatedFieldSet, isNot(same(fieldSet)));
      expect(updatedFieldSet.fields, equals(fieldSet.fields));
    });

    test('complex field set with nested data structures', () async {
      final metadataField = FireField<Map<String, dynamic>>(
        name: 'metadata',
        toFire: () async => {
          'created': DateTime.now().millisecondsSinceEpoch,
          'version': '1.0.0'
        },
        fromFire: (dynamic value) => value as Map<String, dynamic>,
      );

      final tagsField = FireField<List<String>>(
        name: 'tags',
        toFire: () async => ['important', 'user'],
        fromFire: (dynamic value) => (value as List).cast<String>(),
      );

      final complexFieldSet = FireFieldSet<TestPath>(
        fields: [nameField, metadataField, tagsField],
      );

      final complexMap = {
        'name': 'Complex User',
        'metadata': {
          'created': 1625097600000,
          'version': '1.0.0',
          'extra': true
        },
        'tags': ['important', 'user', 'premium'],
      };

      final output = await complexFieldSet.fromMap(complexMap, testPath);

      expect(output.get(nameField), equals('Complex User'));
      expect(output.get(metadataField), isA<Map<String, dynamic>>());
      expect(output.get(metadataField)?['version'], equals('1.0.0'));
      expect(output.get(tagsField), isA<List<String>>());
      expect(output.get(tagsField), hasLength(3));
      expect(output.get(tagsField)?[2], equals('premium'));
    });

    test('fields with complex type conversions', () async {
      final dateField = FireField<DateTime>(
        name: 'timestamp',
        toFire: () async => DateTime.now().millisecondsSinceEpoch,
        fromFire: (dynamic value) =>
            DateTime.fromMillisecondsSinceEpoch(value as int),
      );

      final jsonField = FireField<Map<String, dynamic>>(
        name: 'jsonData',
        toFire: () async => {'key': 'value'},
        fromFire: (dynamic value) => value as Map<String, dynamic>,
      );

      final complexFieldSet = FireFieldSet<TestPath>(
        fields: [dateField, jsonField],
      );

      final timestamp = 1625097600000; // 2021-07-01T00:00:00.000Z
      final complexMap = {
        'timestamp': timestamp,
        'jsonData': {
          'key': 'value',
          'nested': {'foo': 'bar'}
        },
      };

      final output = await complexFieldSet.fromMap(complexMap, testPath);

      final dateValue = output.get(dateField);
      expect(dateValue, isA<DateTime>());
      expect(dateValue?.millisecondsSinceEpoch, equals(timestamp));

      final jsonValue = output.get(jsonField);
      expect(jsonValue, isA<Map<String, dynamic>>());
      expect(jsonValue?['key'], equals('value'));
      expect(jsonValue?['nested']['foo'], equals('bar'));
    });

    test('bidirectional conversion preserves data integrity', () async {
      // Create a map from the fields
      final originalMap = await fieldSet.toMap();

      // Then convert it back to fields output
      final output = await fieldSet.fromMap(originalMap, testPath);

      // Convert the output back to a map
      final recreatedMap = output.toMap();

      // Compare the two maps
      expect(recreatedMap['name'], equals(originalMap['name']));
      expect(recreatedMap['age'], equals(originalMap['age']));
      expect(recreatedMap['active'], equals(originalMap['active']));
    });
  });
}
