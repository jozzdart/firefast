import 'package:firefast/firefast_core.dart';
import 'package:test/test.dart';

// Define a simple custom class
class User {
  final String name;
  final int age;

  User(this.name, this.age);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User && name == other.name && age == other.age;

  @override
  int get hashCode => name.hashCode ^ age.hashCode;
}

void main() {
  group('FireFieldOutput', () {
    late FireField<String> stringField;
    late FireField<int> intField;
    late FireField<bool> boolField;

    setUp(() {
      stringField = FireField<String>(
        name: 'name',
        toFire: () async => 'John Doe',
        fromFire: (dynamic value) => value as String,
      );

      intField = FireField<int>(
        name: 'age',
        toFire: () async => 30,
        fromFire: (dynamic value) => value as int,
      );

      boolField = FireField<bool>(
        name: 'active',
        toFire: () async => true,
        fromFire: (dynamic value) => value as bool,
      );
    });

    test('constructor initializes properties correctly', () {
      const value = 'Test Value';
      final output = FireFieldOutput(source: stringField, value: value);

      expect(output.source, equals(stringField));
      expect(output.value, equals(value));
    });

    test('fieldName getter returns source field name', () {
      final output = FireFieldOutput(source: stringField, value: 'Jane Doe');

      expect(output.fieldName, equals('name'));
    });

    test('works with different value types', () {
      final stringOutput =
          FireFieldOutput(source: stringField, value: 'Test String');
      final intOutput = FireFieldOutput(source: intField, value: 42);
      final boolOutput = FireFieldOutput(source: boolField, value: false);

      expect(stringOutput.value, isA<String>());
      expect(stringOutput.value, equals('Test String'));

      expect(intOutput.value, isA<int>());
      expect(intOutput.value, equals(42));

      expect(boolOutput.value, isA<bool>());
      expect(boolOutput.value, equals(false));
    });

    test('can handle null values for nullable fields', () {
      final nullableField = FireField<String?>(
        name: 'nullable',
        toFire: () async => null,
        fromFire: (dynamic value) => value as String?,
      );

      final output = FireFieldOutput(source: nullableField, value: null);

      expect(output.source, equals(nullableField));
      expect(output.value, isNull);
      expect(output.fieldName, equals('nullable'));
    });

    test('works with complex object types', () {
      final dateTime = DateTime(2021, 7, 1);
      final dateField = FireField<DateTime>(
        name: 'timestamp',
        toFire: () async => dateTime.millisecondsSinceEpoch,
        fromFire: (dynamic value) =>
            DateTime.fromMillisecondsSinceEpoch(value as int),
      );

      final output = FireFieldOutput(source: dateField, value: dateTime);

      expect(output.value, isA<DateTime>());
      expect(output.value, equals(dateTime));
    });

    test('works with collection types', () {
      final mapField = FireField<Map<String, dynamic>>(
        name: 'metadata',
        toFire: () async => {'key': 'value'},
        fromFire: (dynamic value) => value as Map<String, dynamic>,
      );

      final mapData = {'name': 'John', 'age': 30};
      final mapOutput = FireFieldOutput(source: mapField, value: mapData);

      expect(mapOutput.value, isA<Map<String, dynamic>>());
      expect(mapOutput.value, equals(mapData));

      final listField = FireField<List<String>>(
        name: 'tags',
        toFire: () async => ['tag1', 'tag2'],
        fromFire: (dynamic value) => (value as List).cast<String>(),
      );

      final listData = ['apple', 'banana', 'orange'];
      final listOutput = FireFieldOutput(source: listField, value: listData);

      expect(listOutput.value, isA<List<String>>());
      expect(listOutput.value, equals(listData));
    });

    test('handles generic type properly', () {
      final field = FireField<List<Map<String, int>>>(
        name: 'complexData',
        toFire: () async => [
          {'a': 1}
        ],
        fromFire: (dynamic value) => (value as List).cast<Map<String, int>>(),
      );

      final complexData = [
        {'score': 100, 'level': 5},
        {'score': 200, 'level': 7},
      ];

      final output = FireFieldOutput(source: field, value: complexData);

      expect(output.value, isA<List<Map<String, int>>>());
      expect(output.value, equals(complexData));
      expect(output.value[0]['score'], equals(100));
      expect(output.value[1]['level'], equals(7));
    });

    test('works with custom object types', () {
      final userField = FireField<User>(
        name: 'user',
        toFire: () async => {'name': 'John', 'age': 30},
        fromFire: (dynamic value) {
          final map = value as Map<String, dynamic>;
          return User(map['name'] as String, map['age'] as int);
        },
      );

      final user = User('Jane', 25);
      final output = FireFieldOutput(source: userField, value: user);

      expect(output.value, isA<User>());
      expect(output.value, equals(user));
      expect(output.value.name, equals('Jane'));
      expect(output.value.age, equals(25));
    });
  });
}
