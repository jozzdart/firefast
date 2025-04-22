import 'package:firefast/firefast_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// Mock datasource for testing
class MockDataSource extends Mock {}

// Concrete implementation of FastDataPathSource for testing
class TestDataPathSource extends FastDataPathSource<TestData, MockDataSource> {
  const TestDataPathSource(super.datasource);

  @override
  Future<void> delete(String path) async {
    // Implementation for test
    await Future.delayed(const Duration(milliseconds: 1));
    return;
  }

  @override
  Future<void> overwrite(String path, TestData data) async {
    // Implementation for test
    await Future.delayed(const Duration(milliseconds: 1));
    return;
  }

  @override
  Future<TestData?> read(String path) async {
    // Implementation for test
    await Future.delayed(const Duration(milliseconds: 1));
    return TestData(id: 'test-id', value: 'test-value');
  }

  @override
  Future<void> write(String path, TestData data) async {
    // Implementation for test
    await Future.delayed(const Duration(milliseconds: 1));
    return;
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
  group('FastDataPathSource', () {
    late MockDataSource mockDataSource;
    late TestDataPathSource dataPathSource;

    setUp(() {
      mockDataSource = MockDataSource();
      dataPathSource = TestDataPathSource(mockDataSource);
    });

    test('Constructor should set datasource property', () {
      // Assert
      expect(dataPathSource.datasource, equals(mockDataSource));
    });

    test('Class should implement all required interfaces', () {
      // Assert
      expect(dataPathSource, isA<FastPathRead<TestData>>());
      expect(dataPathSource, isA<FastPathWrite<TestData>>());
      expect(dataPathSource, isA<FastPathOverwrite<TestData>>());
      expect(dataPathSource, isA<FastPathDelete>());
    });

    test('read() method should be callable', () async {
      // Act
      final result = await dataPathSource.read('test/path');

      // Assert
      expect(result, isNotNull);
      expect(result, isA<TestData>());
      expect(result?.id, equals('test-id'));
      expect(result?.value, equals('test-value'));
    });

    test('write() method should be callable', () async {
      // Arrange
      final testData = TestData(id: 'write-id', value: 'write-value');

      // Act & Assert
      // Should not throw exception
      await expectLater(
        dataPathSource.write('test/path', testData),
        completes,
      );
    });

    test('overwrite() method should be callable', () async {
      // Arrange
      final testData = TestData(id: 'overwrite-id', value: 'overwrite-value');

      // Act & Assert
      // Should not throw exception
      await expectLater(
        dataPathSource.overwrite('test/path', testData),
        completes,
      );
    });

    test('delete() method should be callable', () async {
      // Act & Assert
      // Should not throw exception
      await expectLater(
        dataPathSource.delete('test/path'),
        completes,
      );
    });

    test('All operations should work with the same instance', () async {
      // Arrange
      final testData = TestData(id: 'multi-op-id', value: 'multi-op-value');

      // Act & Assert
      // Read
      final readResult = await dataPathSource.read('test/path');
      expect(readResult, isNotNull);

      // Write
      await expectLater(
        dataPathSource.write('test/path', testData),
        completes,
      );

      // Overwrite
      await expectLater(
        dataPathSource.overwrite('test/path', testData),
        completes,
      );

      // Delete
      await expectLater(
        dataPathSource.delete('test/path'),
        completes,
      );
    });
  });
}
