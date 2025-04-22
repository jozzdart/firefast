import 'package:firefast/firefast_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// Mock implementation of FastPathRead for testing
class MockFastPathRead<D> extends Mock implements FastPathRead<D> {
  @override
  Future<D?> read(String path) async {
    return super.noSuchMethod(
      Invocation.method(#read, [path]),
      returnValue: Future<D?>.value(null),
    ) as Future<D?>;
  }
}

class TestData {
  final String id;
  final String value;

  TestData({required this.id, required this.value});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TestData && other.id == id && other.value == value;
  }

  @override
  int get hashCode => id.hashCode ^ value.hashCode;
}

void main() {
  group('FastPathRead', () {
    late MockFastPathRead<TestData> pathReader;
    final testData = TestData(id: 'test-id', value: 'test-value');

    setUp(() {
      pathReader = MockFastPathRead<TestData>();
    });

    test('read() should return data when path exists', () async {
      // Arrange
      when(pathReader.read('users/123')).thenAnswer((_) async => testData);

      // Act
      final result = await pathReader.read('users/123');

      // Assert
      expect(result, isNotNull);
      expect(result, equals(testData));
      verify(pathReader.read('users/123')).called(1);
    });

    test('read() should return null when path does not exist', () async {
      // Arrange
      when(pathReader.read('users/999')).thenAnswer((_) async => null);

      // Act
      final result = await pathReader.read('users/999');

      // Assert
      expect(result, isNull);
      verify(pathReader.read('users/999')).called(1);
    });

    test('read() should propagate exceptions', () async {
      // Arrange
      final exception = Exception('Failed to read path');
      when(pathReader.read('invalid/path')).thenThrow(exception);

      // Act & Assert
      expect(() => pathReader.read('invalid/path'), throwsA(equals(exception)));
      verify(pathReader.read('invalid/path')).called(1);
    });

    test('read() should handle empty path', () async {
      // Arrange
      when(pathReader.read('')).thenAnswer((_) async => null);

      // Act
      final result = await pathReader.read('');

      // Assert
      expect(result, isNull);
      verify(pathReader.read('')).called(1);
    });

    test('read() should handle path with special characters', () async {
      // Arrange
      final specialPath = 'users/test#user/profile.info';
      when(pathReader.read(specialPath)).thenAnswer((_) async => testData);

      // Act
      final result = await pathReader.read(specialPath);

      // Assert
      expect(result, equals(testData));
      verify(pathReader.read(specialPath)).called(1);
    });
  });
}
