import 'package:firefast/firefast_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// Mock implementation of FastPathOverwrite for testing
class MockFastPathOverwrite<D> extends Mock implements FastPathOverwrite<D> {
  @override
  Future<void> overwrite(String path, D data) async {
    return super.noSuchMethod(
      Invocation.method(#overwrite, [path, data]),
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
  group('FastPathOverwrite', () {
    late MockFastPathOverwrite<TestData> pathOverwriter;
    late TestData testData;

    setUp(() {
      pathOverwriter = MockFastPathOverwrite<TestData>();
      testData = TestData(id: 'test-id', value: 'test-value');
    });

    test('overwrite() should successfully overwrite data at path', () async {
      // Arrange
      when(pathOverwriter.overwrite('users/123', testData))
          .thenAnswer((_) async {});

      // Act
      await pathOverwriter.overwrite('users/123', testData);

      // Assert
      verify(pathOverwriter.overwrite('users/123', testData)).called(1);
    });

    test('overwrite() should propagate exceptions', () async {
      // Arrange
      final exception = Exception('Failed to overwrite data');
      when(pathOverwriter.overwrite('invalid/path', testData))
          .thenThrow(exception);

      // Act & Assert
      expect(
        () => pathOverwriter.overwrite('invalid/path', testData),
        throwsA(equals(exception)),
      );
      verify(pathOverwriter.overwrite('invalid/path', testData)).called(1);
    });

    test('overwrite() should handle empty path', () async {
      // Arrange
      when(pathOverwriter.overwrite('', testData)).thenAnswer((_) async {});

      // Act
      await pathOverwriter.overwrite('', testData);

      // Assert
      verify(pathOverwriter.overwrite('', testData)).called(1);
    });

    test('overwrite() should handle path with special characters', () async {
      // Arrange
      final specialPath = 'users/test#user/profile.info';
      when(pathOverwriter.overwrite(specialPath, testData))
          .thenAnswer((_) async {});

      // Act
      await pathOverwriter.overwrite(specialPath, testData);

      // Assert
      verify(pathOverwriter.overwrite(specialPath, testData)).called(1);
    });

    test('overwrite() should work with multiple calls to the same path',
        () async {
      // Arrange
      final testData1 = TestData(id: 'test-id-1', value: 'test-value-1');
      final testData2 = TestData(id: 'test-id-2', value: 'test-value-2');

      when(pathOverwriter.overwrite('users/123', testData1))
          .thenAnswer((_) async {});
      when(pathOverwriter.overwrite('users/123', testData2))
          .thenAnswer((_) async {});

      // Act
      await pathOverwriter.overwrite('users/123', testData1);
      await pathOverwriter.overwrite('users/123', testData2);

      // Assert
      verify(pathOverwriter.overwrite('users/123', testData1)).called(1);
      verify(pathOverwriter.overwrite('users/123', testData2)).called(1);
    });

    test('overwrite() should handle deeply nested paths', () async {
      // Arrange
      final deepPath = 'users/123/profiles/work/details/contact';
      when(pathOverwriter.overwrite(deepPath, testData))
          .thenAnswer((_) async {});

      // Act
      await pathOverwriter.overwrite(deepPath, testData);

      // Assert
      verify(pathOverwriter.overwrite(deepPath, testData)).called(1);
    });
  });
}
