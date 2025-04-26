import 'package:firefast/firefast_core.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

// Mock implementations
class MockReadNoParams extends Mock implements ReadNoParams {
  @override
  Future<void> read() async {
    return super.noSuchMethod(
      Invocation.method(#read, []),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value(),
    );
  }
}

class MockWriteNoParams extends Mock implements WriteNoParams {
  @override
  Future<void> write() async {
    return super.noSuchMethod(
      Invocation.method(#write, []),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value(),
    );
  }
}

class MockOverwriteNoParams extends Mock implements OverwriteNoParams {
  @override
  Future<void> overwrite() async {
    return super.noSuchMethod(
      Invocation.method(#overwrite, []),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value(),
    );
  }
}

class MockDeleteNoParams extends Mock implements DeleteNoParams {
  @override
  Future<void> delete() async {
    return super.noSuchMethod(
      Invocation.method(#delete, []),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value(),
    );
  }
}

void main() {
  group('ReadNoParams', () {
    late MockReadNoParams mockReadNoParams;

    setUp(() {
      mockReadNoParams = MockReadNoParams();
    });

    test('should call read method', () async {
      when(mockReadNoParams.read()).thenAnswer((_) => Future.value());

      await mockReadNoParams.read();

      verify(mockReadNoParams.read()).called(1);
    });

    test('should propagate exceptions when read fails', () async {
      final error = Exception('Read operation failed');

      when(mockReadNoParams.read()).thenThrow(error);

      expect(
        () => mockReadNoParams.read(),
        throwsA(same(error)),
      );
    });
  });

  group('WriteNoParams', () {
    late MockWriteNoParams mockWriteNoParams;

    setUp(() {
      mockWriteNoParams = MockWriteNoParams();
    });

    test('should call write method', () async {
      when(mockWriteNoParams.write()).thenAnswer((_) => Future.value());

      await mockWriteNoParams.write();

      verify(mockWriteNoParams.write()).called(1);
    });

    test('should propagate exceptions when write fails', () async {
      final error = Exception('Write operation failed');

      when(mockWriteNoParams.write()).thenThrow(error);

      expect(
        () => mockWriteNoParams.write(),
        throwsA(same(error)),
      );
    });
  });

  group('OverwriteNoParams', () {
    late MockOverwriteNoParams mockOverwriteNoParams;

    setUp(() {
      mockOverwriteNoParams = MockOverwriteNoParams();
    });

    test('should call overwrite method', () async {
      when(mockOverwriteNoParams.overwrite()).thenAnswer((_) => Future.value());

      await mockOverwriteNoParams.overwrite();

      verify(mockOverwriteNoParams.overwrite()).called(1);
    });

    test('should propagate exceptions when overwrite fails', () async {
      final error = Exception('Overwrite operation failed');

      when(mockOverwriteNoParams.overwrite()).thenThrow(error);

      expect(
        () => mockOverwriteNoParams.overwrite(),
        throwsA(same(error)),
      );
    });
  });

  group('DeleteNoParams', () {
    late MockDeleteNoParams mockDeleteNoParams;

    setUp(() {
      mockDeleteNoParams = MockDeleteNoParams();
    });

    test('should call delete method', () async {
      when(mockDeleteNoParams.delete()).thenAnswer((_) => Future.value());

      await mockDeleteNoParams.delete();

      verify(mockDeleteNoParams.delete()).called(1);
    });

    test('should propagate exceptions when delete fails', () async {
      final error = Exception('Delete operation failed');

      when(mockDeleteNoParams.delete()).thenThrow(error);

      expect(
        () => mockDeleteNoParams.delete(),
        throwsA(same(error)),
      );
    });
  });
}
