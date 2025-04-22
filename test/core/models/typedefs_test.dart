import 'package:firefast/firefast_core.dart';
import 'package:test/test.dart';

// Define a custom class for testing
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
  group('Typedefs', () {
    group('ToFireDelegate', () {
      test('can be implemented as a function returning String', () {
        delegate() async => 'test value';

        expect(delegate, isA<ToFireDelegate>());
        expect(delegate(), completion(equals('test value')));
      });

      test('can be implemented as a function returning int', () {
        delegate() async => 42;

        expect(delegate, isA<ToFireDelegate>());
        expect(delegate(), completion(equals(42)));
      });

      test('can be implemented as a function returning bool', () {
        delegate() async => true;

        expect(delegate, isA<ToFireDelegate>());
        expect(delegate(), completion(equals(true)));
      });

      test('can be implemented as a function returning Map', () {
        final map = {'key': 'value', 'number': 42};
        delegate() async => map;

        expect(delegate, isA<ToFireDelegate>());
        expect(delegate(), completion(equals(map)));
      });

      test('can be implemented as a function returning List', () {
        final list = ['item1', 'item2', 'item3'];
        delegate() async => list;

        expect(delegate, isA<ToFireDelegate>());
        expect(delegate(), completion(equals(list)));
      });

      test('can be implemented as a function returning null', () {
        delegate() async => null;

        expect(delegate, isA<ToFireDelegate>());
        expect(delegate(), completion(isNull));
      });

      test(
          'can be implemented as a function returning complex nested structures',
          () {
        final complex = {
          'user': 'John',
          'details': {
            'age': 30,
            'active': true,
            'tags': ['tag1', 'tag2'],
          },
        };

        delegate() async => complex;

        expect(delegate, isA<ToFireDelegate>());
        expect(delegate(), completion(equals(complex)));
      });
    });

    group('FromFireDelegate', () {
      test('can be implemented as a function converting to String', () {
        delegate(dynamic value) => value.toString();

        expect(delegate, isA<FromFireDelegate<String>>());
        expect(delegate('test'), equals('test'));
        expect(delegate(42), equals('42'));
        expect(delegate(true), equals('true'));
      });

      test('can be implemented as a function converting to int', () {
        delegate(dynamic value) => int.parse(value.toString());

        expect(delegate, isA<FromFireDelegate<int>>());
        expect(delegate('42'), equals(42));
        expect(delegate(42), equals(42));
      });

      test('can be implemented as a function converting to bool', () {
        delegate(dynamic value) =>
            value is bool ? value : value.toString().toLowerCase() == 'true';

        expect(delegate, isA<FromFireDelegate<bool>>());
        expect(delegate(true), isTrue);
        expect(delegate('true'), isTrue);
        expect(delegate('false'), isFalse);
      });

      test('can be implemented as a function converting to Map', () {
        delegate(dynamic value) => value as Map<String, dynamic>;

        final map = {'key': 'value'};

        expect(delegate, isA<FromFireDelegate<Map<String, dynamic>>>());
        expect(delegate(map), equals(map));
      });

      test('can be implemented as a function converting to List', () {
        delegate(dynamic value) =>
            (value as List).map((e) => e.toString()).toList();

        final list = ['a', 'b', 'c'];

        expect(delegate, isA<FromFireDelegate<List<String>>>());
        expect(delegate(list), equals(list));
      });

      test('can be implemented as a function converting to custom type', () {
        delegate(dynamic value) {
          final map = value as Map<String, dynamic>;
          return User(map['name'] as String, map['age'] as int);
        }

        final userData = {'name': 'John', 'age': 30};
        final expectedUser = User('John', 30);

        expect(delegate, isA<FromFireDelegate<User>>());
        expect(delegate(userData), equals(expectedUser));
      });

      test('can be implemented for nullable types', () {
        delegate(dynamic value) => value?.toString();

        expect(delegate, isA<FromFireDelegate<String?>>());
        expect(delegate('test'), equals('test'));
        expect(delegate(null), isNull);
      });

      test('can handle complex transformations', () {
        delegate(dynamic value) =>
            DateTime.fromMillisecondsSinceEpoch(value as int);

        final timestamp = 1625097600000; // 2021-07-01T00:00:00.000Z
        final expectedDate = DateTime.fromMillisecondsSinceEpoch(timestamp);

        expect(delegate, isA<FromFireDelegate<DateTime>>());
        expect(delegate(timestamp), equals(expectedDate));
      });
    });
  });
}
