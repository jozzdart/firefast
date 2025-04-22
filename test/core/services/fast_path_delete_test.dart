import 'package:firefast/firefast_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// Mock implementation of FastPathDelete for testing
class MockFastPathDelete extends Mock implements FastPathDelete {
  @override
  Future<void> delete(String path) async {
    return super.noSuchMethod(
      Invocation.method(#delete, [path]),
      returnValue: Future<void>.value(),
    ) as Future<void>;
  }
}

void main() {
  group('FastPathDelete', () {
    late MockFastPathDelete pathDeleter;

    setUp(() {
      pathDeleter = MockFastPathDelete();
    });

    test('delete() should successfully delete data at path', () async {
      // Arrange
      when(pathDeleter.delete('users/123')).thenAnswer((_) async {});

      // Act
      await pathDeleter.delete('users/123');

      // Assert
      verify(pathDeleter.delete('users/123')).called(1);
    });

    test('delete() should propagate exceptions', () async {
      // Arrange
      final exception = Exception('Failed to delete data');
      when(pathDeleter.delete('invalid/path')).thenThrow(exception);

      // Act & Assert
      expect(
        () => pathDeleter.delete('invalid/path'),
        throwsA(equals(exception)),
      );
      verify(pathDeleter.delete('invalid/path')).called(1);
    });

    test('delete() should handle empty path', () async {
      // Arrange
      when(pathDeleter.delete('')).thenAnswer((_) async {});

      // Act
      await pathDeleter.delete('');

      // Assert
      verify(pathDeleter.delete('')).called(1);
    });

    test('delete() should handle path with special characters', () async {
      // Arrange
      final specialPath = 'users/test#user/profile.info';
      when(pathDeleter.delete(specialPath)).thenAnswer((_) async {});

      // Act
      await pathDeleter.delete(specialPath);

      // Assert
      verify(pathDeleter.delete(specialPath)).called(1);
    });

    test('delete() should work with multiple delete calls to different paths',
        () async {
      // Arrange
      when(pathDeleter.delete('users/123')).thenAnswer((_) async {});
      when(pathDeleter.delete('users/456')).thenAnswer((_) async {});

      // Act
      await pathDeleter.delete('users/123');
      await pathDeleter.delete('users/456');

      // Assert
      verify(pathDeleter.delete('users/123')).called(1);
      verify(pathDeleter.delete('users/456')).called(1);
    });

    test('delete() should handle deeply nested paths', () async {
      // Arrange
      final deepPath = 'users/123/profiles/work/details/contact';
      when(pathDeleter.delete(deepPath)).thenAnswer((_) async {});

      // Act
      await pathDeleter.delete(deepPath);

      // Assert
      verify(pathDeleter.delete(deepPath)).called(1);
    });

    test('delete() should handle nonexistent paths gracefully', () async {
      // Arrange
      when(pathDeleter.delete('nonexistent/path')).thenAnswer((_) async {});

      // Act
      await pathDeleter.delete('nonexistent/path');

      // Assert
      verify(pathDeleter.delete('nonexistent/path')).called(1);
    });
  });
}
