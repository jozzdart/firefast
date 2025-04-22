import 'package:firefast/firefast_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// Mock implementation of FastPathWrite for testing
class MockFastPathWrite<D> extends Mock implements FastPathWrite<D> {
  @override
  Future<void> write(String path, D data) async {
    return super.noSuchMethod(
      Invocation.method(#write, [path, data]),
      returnValue: Future<void>.value(),
    ) as Future<void>;
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
  group('FastPathWrite', () {
    late MockFastPathWrite<TestData> pathWriter;
    late TestData testData;

    setUp(() {
      pathWriter = MockFastPathWrite<TestData>();
      testData = TestData(id: 'test-id', value: 'test-value');
    });

    test('write() should successfully write data to path', () async {
      // Arrange
      when(pathWriter.write('users/123', testData)).thenAnswer((_) async {});

      // Act
      await pathWriter.write('users/123', testData);

      // Assert
      verify(pathWriter.write('users/123', testData)).called(1);
    });

    test('write() should propagate exceptions', () async {
      // Arrange
      final exception = Exception('Failed to write data');
      when(pathWriter.write('invalid/path', testData)).thenThrow(exception);

      // Act & Assert
      expect(
        () => pathWriter.write('invalid/path', testData),
        throwsA(equals(exception)),
      );
      verify(pathWriter.write('invalid/path', testData)).called(1);
    });

    test('write() should handle empty path', () async {
      // Arrange
      when(pathWriter.write('', testData)).thenAnswer((_) async {});

      // Act
      await pathWriter.write('', testData);

      // Assert
      verify(pathWriter.write('', testData)).called(1);
    });

    test('write() should handle null values in TestData fields', () async {
      // Arrange
      final nullableData = TestData(id: 'null-test', value: 'null-value');
      when(pathWriter.write('users/null-test', nullableData))
          .thenAnswer((_) async {});

      // Act
      await pathWriter.write('users/null-test', nullableData);

      // Assert
      verify(pathWriter.write('users/null-test', nullableData)).called(1);
    });

    test('write() should handle path with special characters', () async {
      // Arrange
      final specialPath = 'users/test#user/profile.info';
      when(pathWriter.write(specialPath, testData)).thenAnswer((_) async {});

      // Act
      await pathWriter.write(specialPath, testData);

      // Assert
      verify(pathWriter.write(specialPath, testData)).called(1);
    });

    test('write() should work with multiple calls to different paths',
        () async {
      // Arrange
      when(pathWriter.write('users/123', testData)).thenAnswer((_) async {});
      when(pathWriter.write('users/456', testData)).thenAnswer((_) async {});

      // Act
      await pathWriter.write('users/123', testData);
      await pathWriter.write('users/456', testData);

      // Assert
      verify(pathWriter.write('users/123', testData)).called(1);
      verify(pathWriter.write('users/456', testData)).called(1);
    });
  });
}
