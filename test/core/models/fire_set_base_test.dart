import 'package:test/test.dart';
import 'package:firefast/firefast_core.dart';

class TestFireSetBase extends FireSetBase<String> {
  @override
  Future<Map<String, dynamic>?> toMap() async {
    return {'key': 'value'};
  }

  @override
  Future<String?> fromMap(Map<String, dynamic>? map) async {
    if (map == null) return null;
    return map['key'] as String?;
  }
}

class CustomFireSetBase extends FireSetBase<Map<String, dynamic>> {
  @override
  Future<Map<String, dynamic>?> toMap() async {
    return {
      'string': 'value',
      'int': 42,
      'bool': true,
      'list': [1, 2, 3],
      'nested': {'key': 'value'}
    };
  }

  @override
  Future<Map<String, dynamic>?> fromMap(Map<String, dynamic>? map) async {
    return map;
  }
}

void main() {
  group('FireSetBase', () {
    test('should implement toMap method', () async {
      final fireSet = TestFireSetBase();
      final map = await fireSet.toMap();

      expect(map, isA<Map<String, dynamic>>());
      expect(map?['key'], equals('value'));
    });

    test('should implement fromMap method', () async {
      final fireSet = TestFireSetBase();
      final map = {'key': 'value'};
      final result = await fireSet.fromMap(map);

      expect(result, equals('value'));
    });

    test('fromMap should return null when given a null map', () async {
      final fireSet = TestFireSetBase();
      final result = await fireSet.fromMap(null);

      expect(result, isNull);
    });

    test('can handle complex data structures', () async {
      final customFireSet = CustomFireSetBase();
      final map = await customFireSet.toMap();

      expect(map, isA<Map<String, dynamic>>());
      expect(map?['string'], equals('value'));
      expect(map?['int'], equals(42));
      expect(map?['bool'], equals(true));
      expect(map?['list'], equals([1, 2, 3]));
      expect(map?['nested'], equals({'key': 'value'}));

      final recreatedMap = await customFireSet.fromMap(map);
      expect(recreatedMap, equals(map));
    });

    test('can handle empty maps', () async {
      final fireSet = CustomFireSetBase();
      final emptyMap = <String, dynamic>{};
      final result = await fireSet.fromMap(emptyMap);

      expect(result, equals(emptyMap));
      expect(result, isEmpty);
    });

    test('implementation can use generic type parameters', () async {
      // Test with String type
      final stringFireSet = TestFireSetBase();
      final stringResult = await stringFireSet.fromMap({'key': 'value'});
      expect(stringResult, isA<String>());

      // Test with Map type
      final mapFireSet = CustomFireSetBase();
      final mapResult = await mapFireSet.fromMap({'test': 'data'});
      expect(mapResult, isA<Map<String, dynamic>>());
    });
  });
}
