import 'package:firefast/firefast_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// Mock implementations for testing
class MockFastReadNoParams<D> extends Mock implements FastReadNoParams<D> {
  @override
  Future<D?> read() async {
    return super.noSuchMethod(
      Invocation.method(#read, []),
      returnValue: Future<D?>.value(null),
    ) as Future<D?>;
  }
}

class MockFastWriteNoParams extends Mock implements FastWriteNoParams {
  @override
  Future<void> write() async {
    return super.noSuchMethod(
      Invocation.method(#write, []),
      returnValue: Future<void>.value(),
    ) as Future<void>;
  }
}

class MockFastOverwriteNoParams extends Mock implements FastOverwriteNoParams {
  @override
  Future<void> overwrite() async {
    return super.noSuchMethod(
      Invocation.method(#overwrite, []),
      returnValue: Future<void>.value(),
    ) as Future<void>;
  }
}

class MockFastDeleteNoParams extends Mock implements FastDeleteNoParams {
  @override
  Future<void> delete() async {
    return super.noSuchMethod(
      Invocation.method(#delete, []),
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
  group('FastReadNoParams', () {
    late MockFastReadNoParams<TestData> reader;
    final testData = TestData(id: 'test-id', value: 'test-value');

    setUp(() {
      reader = MockFastReadNoParams<TestData>();
    });

    test('read() should return data when available', () async {
      // Arrange
      when(reader.read()).thenAnswer((_) async => testData);

      // Act
      final result = await reader.read();

      // Assert
      expect(result, isNotNull);
      expect(result, equals(testData));
      verify(reader.read()).called(1);
    });

    test('read() should return null when data is not available', () async {
      // Arrange
      when(reader.read()).thenAnswer((_) async => null);

      // Act
      final result = await reader.read();

      // Assert
      expect(result, isNull);
      verify(reader.read()).called(1);
    });

    test('read() should propagate exceptions', () async {
      // Arrange
      final exception = Exception('Failed to read data');
      when(reader.read()).thenThrow(exception);

      // Act & Assert
      expect(() => reader.read(), throwsA(equals(exception)));
      verify(reader.read()).called(1);
    });
  });

  group('FastWriteNoParams', () {
    late MockFastWriteNoParams writer;

    setUp(() {
      writer = MockFastWriteNoParams();
    });

    test('write() should successfully write data', () async {
      // Arrange
      when(writer.write()).thenAnswer((_) async {});

      // Act
      await writer.write();

      // Assert
      verify(writer.write()).called(1);
    });

    test('write() should propagate exceptions', () async {
      // Arrange
      final exception = Exception('Failed to write data');
      when(writer.write()).thenThrow(exception);

      // Act & Assert
      expect(() => writer.write(), throwsA(equals(exception)));
      verify(writer.write()).called(1);
    });
  });

  group('FastOverwriteNoParams', () {
    late MockFastOverwriteNoParams overwriter;

    setUp(() {
      overwriter = MockFastOverwriteNoParams();
    });

    test('overwrite() should successfully overwrite data', () async {
      // Arrange
      when(overwriter.overwrite()).thenAnswer((_) async {});

      // Act
      await overwriter.overwrite();

      // Assert
      verify(overwriter.overwrite()).called(1);
    });

    test('overwrite() should propagate exceptions', () async {
      // Arrange
      final exception = Exception('Failed to overwrite data');
      when(overwriter.overwrite()).thenThrow(exception);

      // Act & Assert
      expect(() => overwriter.overwrite(), throwsA(equals(exception)));
      verify(overwriter.overwrite()).called(1);
    });
  });

  group('FastDeleteNoParams', () {
    late MockFastDeleteNoParams deleter;

    setUp(() {
      deleter = MockFastDeleteNoParams();
    });

    test('delete() should successfully delete data', () async {
      // Arrange
      when(deleter.delete()).thenAnswer((_) async {});

      // Act
      await deleter.delete();

      // Assert
      verify(deleter.delete()).called(1);
    });

    test('delete() should propagate exceptions', () async {
      // Arrange
      final exception = Exception('Failed to delete data');
      when(deleter.delete()).thenThrow(exception);

      // Act & Assert
      expect(() => deleter.delete(), throwsA(equals(exception)));
      verify(deleter.delete()).called(1);
    });
  });
}
