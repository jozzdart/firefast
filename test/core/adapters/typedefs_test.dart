import 'dart:convert';
import 'dart:typed_data';
import 'package:test/test.dart';
import 'package:firefast/firefast_core.dart';

// Define a simple class for testing
class TestModel {
  final String name;
  final int age;

  TestModel(this.name, this.age);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TestModel &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          age == other.age;

  @override
  int get hashCode => name.hashCode ^ age.hashCode;
}

// More complex model with nested properties
class ComplexModel {
  final String id;
  final TestModel user;
  final List<String> tags;
  final Map<String, dynamic> metadata;
  final DateTime createdAt;

  ComplexModel({
    required this.id,
    required this.user,
    required this.tags,
    required this.metadata,
    required this.createdAt,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ComplexModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          user == other.user &&
          _listEquals(tags, other.tags) &&
          _mapEquals(metadata, other.metadata) &&
          createdAt == other.createdAt;

  @override
  int get hashCode =>
      id.hashCode ^
      user.hashCode ^
      tags.hashCode ^
      metadata.hashCode ^
      createdAt.hashCode;

  // Helper methods for equality
  bool _listEquals<T>(List<T> a, List<T> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  bool _mapEquals<K, V>(Map<K, V> a, Map<K, V> b) {
    if (a.length != b.length) return false;
    for (final key in a.keys) {
      if (!b.containsKey(key) || a[key] != b[key]) return false;
    }
    return true;
  }
}

void main() {
  group('ToFire and FromFire typedefs', () {
    test('ToFire typedef can be used as a function type', () {
      // Create a function matching the ToFire typedef
      toFireFunc(String value) async {
        return value.toUpperCase();
      }

      // Verify it's a function that matches the expected signature
      expect(toFireFunc, isA<ToFire<String>>());
    });

    test('FromFire typedef can be used as a function type', () {
      // Create a function matching the FromFire typedef
      fromFireFunc(dynamic value) async {
        return int.parse(value as String);
      }

      // Verify it's a function that matches the expected signature
      expect(fromFireFunc, isA<FromFire<int>>());
    });

    test('ToFire function can be executed', () async {
      toFireFunc(String value) async {
        return value.toUpperCase();
      }

      final result = await toFireFunc('test');
      expect(result, equals('TEST'));
    });

    test('FromFire function can be executed', () async {
      fromFireFunc(dynamic value) async {
        return int.parse(value as String);
      }

      final result = await fromFireFunc('42');
      expect(result, equals(42));
    });

    test('ToFire and FromFire can be used together for roundtrip conversion',
        () async {
      // Define conversion functions
      toFireFunc(DateTime value) async {
        return value.millisecondsSinceEpoch;
      }

      fromFireFunc(dynamic value) async {
        return DateTime.fromMillisecondsSinceEpoch(value as int);
      }

      // Test data
      final testDate = DateTime(2023, 1, 1);

      // Perform roundtrip conversion
      final fireValue = await toFireFunc(testDate);
      final result = await fromFireFunc(fireValue);

      // Verify result matches original
      expect(result, equals(testDate));
    });

    test('ToFire and FromFire can be used with complex types', () async {
      // Define conversion functions
      toFireFunc(TestModel value) async {
        return {
          'name': value.name,
          'age': value.age,
        };
      }

      fromFireFunc(dynamic value) async {
        final map = value as Map<String, dynamic>;
        return TestModel(map['name'] as String, map['age'] as int);
      }

      // Test data
      final testModel = TestModel('John', 30);

      // Perform roundtrip conversion
      final fireValue = await toFireFunc(testModel);
      final result = await fromFireFunc(fireValue);

      // Verify result matches original
      expect(result, equals(testModel));
    });

    test('ToFire and FromFire with null values', () async {
      // Define conversion functions for nullable types
      toFireFunc(String? value) async {
        return value;
      }

      fromFireFunc(dynamic value) async {
        return value as String?;
      }

      // Test with null
      expect(await toFireFunc(null), isNull);
      expect(await fromFireFunc(null), isNull);

      // Test with value
      expect(await toFireFunc('test'), equals('test'));
      expect(await fromFireFunc('test'), equals('test'));
    });

    test('ToFire and FromFire with async operations', () async {
      // Define conversion functions with additional async operations
      toFireFunc(String value) async {
        await Future.delayed(
            Duration(milliseconds: 10)); // Simulate async operation
        return value.toUpperCase();
      }

      fromFireFunc(dynamic value) async {
        await Future.delayed(
            Duration(milliseconds: 10)); // Simulate async operation
        return (value as String).toLowerCase();
      }

      // Verify async operation works
      final result = await toFireFunc('Test');
      expect(result, equals('TEST'));

      final decoded = await fromFireFunc(result);
      expect(decoded, equals('test'));
    });

    test('ToFire and FromFire with error handling', () async {
      // Define conversion functions with error handling
      toFireFunc(int value) async {
        if (value < 0) {
          throw ArgumentError('Value must be non-negative');
        }
        return value.toString();
      }

      fromFireFunc(dynamic value) async {
        if (value is! String) {
          throw TypeError();
        }
        final parsed = int.tryParse(value);
        if (parsed == null) {
          throw FormatException('Invalid number format');
        }
        return parsed;
      }

      // Valid cases
      expect(await toFireFunc(42), equals('42'));
      expect(await fromFireFunc('42'), equals(42));

      // Error cases
      expect(() => toFireFunc(-1), throwsA(isA<ArgumentError>()));
      expect(() => fromFireFunc(true), throwsA(isA<TypeError>()));
      expect(
          () => fromFireFunc('not a number'), throwsA(isA<FormatException>()));
    });

    test('ToFire and FromFire with complex nested structures', () async {
      // Define conversion functions for the complex model
      toFireFunc(ComplexModel value) async {
        return {
          'id': value.id,
          'user': {
            'name': value.user.name,
            'age': value.user.age,
          },
          'tags': value.tags,
          'metadata': value.metadata,
          'createdAt': value.createdAt.millisecondsSinceEpoch,
        };
      }

      fromFireFunc(dynamic value) async {
        final map = value as Map<String, dynamic>;
        final userMap = map['user'] as Map<String, dynamic>;

        return ComplexModel(
          id: map['id'] as String,
          user: TestModel(
            userMap['name'] as String,
            userMap['age'] as int,
          ),
          tags: List<String>.from(map['tags'] as List),
          metadata: map['metadata'] as Map<String, dynamic>,
          createdAt:
              DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
        );
      }

      // Test data
      final testModel = ComplexModel(
        id: 'abc123',
        user: TestModel('Jane', 28),
        tags: ['test', 'example', 'firestore'],
        metadata: {
          'isActive': true,
          'count': 42,
          'score': 4.5,
        },
        createdAt: DateTime(2023, 5, 15),
      );

      // Perform roundtrip conversion
      final fireValue = await toFireFunc(testModel);
      final result = await fromFireFunc(fireValue);

      // Verify individual properties
      expect(result.id, equals(testModel.id));
      expect(result.user.name, equals(testModel.user.name));
      expect(result.user.age, equals(testModel.user.age));
      expect(result.tags, equals(testModel.tags));
      expect(result.metadata, equals(testModel.metadata));
      expect(result.createdAt, equals(testModel.createdAt));

      // Verify the entire object
      expect(result, equals(testModel));
    });

    test('ToFire and FromFire with binary data', () async {
      // Define conversion functions for Uint8List
      toFireFunc(Uint8List value) async {
        return base64Encode(value);
      }

      fromFireFunc(dynamic value) async {
        return base64Decode(value as String);
      }

      // Test data
      final testData = Uint8List.fromList([1, 2, 3, 4, 5]);

      // Perform roundtrip conversion
      final fireValue = await toFireFunc(testData);
      final result = await fromFireFunc(fireValue);

      // Verify result matches original
      expect(result, equals(testData));
    });

    test('ToFire and FromFire with large data sets', () async {
      // Define conversion functions for large arrays
      toFireFunc(List<int> value) async {
        return value;
      }

      fromFireFunc(dynamic value) async {
        return List<int>.from(value as List);
      }

      // Create a large list
      final largeList = List.generate(1000, (i) => i);

      // Measure performance
      final stopwatch = Stopwatch()..start();

      // Perform roundtrip conversion
      final fireValue = await toFireFunc(largeList);
      final result = await fromFireFunc(fireValue);

      stopwatch.stop();

      // Verify result matches original
      expect(result, equals(largeList));

      // Should be reasonably fast (usually under 50ms)
      expect(stopwatch.elapsedMilliseconds, lessThan(500));
    });

    test('ToFire and FromFire applied to collections', () async {
      // Define conversion functions
      toFireFunc(int value) async => value * 2;
      fromFireFunc(dynamic value) async => (value as int) ~/ 2;

      // Apply to a list of values
      final testList = [1, 2, 3, 4, 5];

      // Manual conversion of each element
      final fireList = await Future.wait(testList.map((e) => toFireFunc(e)));
      final resultList =
          await Future.wait(fireList.map((e) => fromFireFunc(e)));

      // Verify conversions
      expect(fireList, equals([2, 4, 6, 8, 10]));
      expect(resultList, equals(testList));
    });
  });
}
