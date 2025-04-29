import 'package:firefast/firefast_core.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

// Mock implementations
class MockWriteOnPath extends Mock
    implements WriteOnPath<Map<String, dynamic>> {
  @override
  Future<String?> write(String path, Map<String, dynamic> data) async {
    return super.noSuchMethod(
      Invocation.method(#write, [path, data]),
      returnValue: Future<String?>.value(),
      returnValueForMissingStub: Future<String?>.value(),
    );
  }
}

class MockReadOnPath extends Mock implements ReadOnPath<Map<String, dynamic>> {
  @override
  Future<Map<String, dynamic>?> read(String path) async {
    return super.noSuchMethod(
      Invocation.method(#read, [path]),
      returnValue: Future<Map<String, dynamic>?>.value(null),
      returnValueForMissingStub: Future<Map<String, dynamic>?>.value(null),
    );
  }
}

class MockOverwriteOnPath extends Mock
    implements OverwriteOnPath<Map<String, dynamic>> {
  @override
  Future<String?> overwrite(String path, Map<String, dynamic> data) async {
    return super.noSuchMethod(
      Invocation.method(#overwrite, [path, data]),
      returnValue: Future<String?>.value(),
      returnValueForMissingStub: Future<String?>.value(),
    );
  }
}

class MockDeleteOnPath extends Mock implements DeleteOnPath {
  @override
  Future<String?> delete(String path) async {
    return super.noSuchMethod(
      Invocation.method(#delete, [path]),
      returnValue: Future<String?>.value(),
      returnValueForMissingStub: Future<String?>.value(),
    );
  }
}

void main() {
  group('WriteOnPath', () {
    late MockWriteOnPath mockWriteOnPath;

    setUp(() {
      mockWriteOnPath = MockWriteOnPath();
    });

    test('should call write method with correct path and data', () async {
      final path = 'users/123';
      final data = {'name': 'John', 'age': 30};

      when(mockWriteOnPath.write(path, data)).thenAnswer((_) => Future.value());

      await mockWriteOnPath.write(path, data);

      verify(mockWriteOnPath.write(path, data)).called(1);
    });

    test('should propagate exceptions when write fails', () async {
      final path = 'users/123';
      final data = {'name': 'John', 'age': 30};
      final error = Exception('Write operation failed');

      when(mockWriteOnPath.write(path, data)).thenThrow(error);

      expect(
        () => mockWriteOnPath.write(path, data),
        throwsA(same(error)),
      );
    });
  });

  group('ReadOnPath', () {
    late MockReadOnPath mockReadOnPath;

    setUp(() {
      mockReadOnPath = MockReadOnPath();
    });

    test('should call read method with correct path', () async {
      final path = 'users/123';
      final expectedData = {'name': 'John', 'age': 30};

      when(mockReadOnPath.read(path))
          .thenAnswer((_) => Future.value(expectedData));

      final result = await mockReadOnPath.read(path);

      verify(mockReadOnPath.read(path)).called(1);
      expect(result, equals(expectedData));
    });

    test('should return null when no data exists at path', () async {
      final path = 'users/nonexistent';

      when(mockReadOnPath.read(path)).thenAnswer((_) => Future.value(null));

      final result = await mockReadOnPath.read(path);

      verify(mockReadOnPath.read(path)).called(1);
      expect(result, isNull);
    });

    test('should propagate exceptions when read fails', () async {
      final path = 'users/123';
      final error = Exception('Read operation failed');

      when(mockReadOnPath.read(path)).thenThrow(error);

      expect(
        () => mockReadOnPath.read(path),
        throwsA(same(error)),
      );
    });
  });

  group('OverwriteOnPath', () {
    late MockOverwriteOnPath mockOverwriteOnPath;

    setUp(() {
      mockOverwriteOnPath = MockOverwriteOnPath();
    });

    test('should call overwrite method with correct path and data', () async {
      final path = 'users/123';
      final data = {'name': 'John', 'age': 30};

      when(mockOverwriteOnPath.overwrite(path, data))
          .thenAnswer((_) => Future.value());

      await mockOverwriteOnPath.overwrite(path, data);

      verify(mockOverwriteOnPath.overwrite(path, data)).called(1);
    });

    test('should propagate exceptions when overwrite fails', () async {
      final path = 'users/123';
      final data = {'name': 'John', 'age': 30};
      final error = Exception('Overwrite operation failed');

      when(mockOverwriteOnPath.overwrite(path, data)).thenThrow(error);

      expect(
        () => mockOverwriteOnPath.overwrite(path, data),
        throwsA(same(error)),
      );
    });
  });

  group('DeleteOnPath', () {
    late MockDeleteOnPath mockDeleteOnPath;

    setUp(() {
      mockDeleteOnPath = MockDeleteOnPath();
    });

    test('should call delete method with correct path', () async {
      final path = 'users/123';

      when(mockDeleteOnPath.delete(path)).thenAnswer((_) => Future.value());

      await mockDeleteOnPath.delete(path);

      verify(mockDeleteOnPath.delete(path)).called(1);
    });

    test('should propagate exceptions when delete fails', () async {
      final path = 'users/123';
      final error = Exception('Delete operation failed');

      when(mockDeleteOnPath.delete(path)).thenThrow(error);

      expect(
        () => mockDeleteOnPath.delete(path),
        throwsA(same(error)),
      );
    });
  });
}
