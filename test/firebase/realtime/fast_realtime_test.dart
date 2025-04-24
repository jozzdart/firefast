import 'package:firefast/firefast_realtime.dart';
import 'package:flutter_test/flutter_test.dart';
import 'realtime_test_utils.dart';

void main() {
  group('FastRealtime.instance tests', () {
    setUp(() {
      RealtimeTestUtils.setUpFireTests();
    });

    tearDown(() {
      RealtimeTestUtils.clearServices();
    });

    // Basic CRUD operations
    group('Basic CRUD operations', () {
      test('write() should merge data at a path', () async {
        // Arrange
        final path = 'users/testUser';
        final initialData = {'name': 'Test User', 'age': 30};
        final updateData = {'email': 'test@example.com', 'age': 31};

        // Act
        await FirefastReal.instance.write(path, initialData);
        await FirefastReal.instance.write(path, updateData);

        // Assert
        final result = await FirefastReal.instance.read(path);
        expect(result, {
          'name': 'Test User',
          'email': 'test@example.com',
          'age': 31,
        });
      });

      test('overwrite() should replace data at a path', () async {
        // Arrange
        final path = 'users/testUser';
        final initialData = {
          'name': 'Test User',
          'age': 30,
          'email': 'test@example.com'
        };
        final newData = {'name': 'Updated User'};

        // Act
        await FirefastReal.instance.write(path, initialData);
        await FirefastReal.instance.overwrite(path, newData);

        // Assert
        final result = await FirefastReal.instance.read(path);
        expect(result, {'name': 'Updated User'});
      });

      test('read() should return null for non-existent path', () async {
        // Arrange
        final path = 'users/nonExistentUser';

        // Act
        final result = await FirefastReal.instance.read(path);

        // Assert
        expect(result, isNull);
      });

      test('read() should return data for existing path', () async {
        // Arrange
        final path = 'users/testUser';
        final data = {'name': 'Test User', 'age': 30};

        // Act
        await FirefastReal.instance.write(path, data);
        final result = await FirefastReal.instance.read(path);

        // Assert
        expect(result, data);
      });

      test('delete() should remove data at path', () async {
        // Arrange
        final path = 'users/testUser';
        final data = {'name': 'Test User'};

        // Act
        await FirefastReal.instance.write(path, data);
        final beforeDelete = await FirefastReal.instance.read(path);
        await FirefastReal.instance.delete(path);
        final afterDelete = await FirefastReal.instance.read(path);

        // Assert
        expect(beforeDelete, isNotNull);
        expect(afterDelete, isNull);
      });
    });

    // Nested data operations
    group('Nested data operations', () {
      test('should handle complex operations with nested data', () async {
        // Arrange
        final userPath = 'users/testUser';
        final userData = {
          'profile': {
            'name': 'Test User',
            'contact': {'email': 'test@example.com', 'phone': '1234567890'}
          },
          'preferences': {'darkMode': true, 'notifications': false}
        };

        // Act
        await FirefastReal.instance.write(userPath, userData);
        final result = await FirefastReal.instance.read(userPath);

        // Assert
        expect(result, userData);

        // Update nested field
        await FirefastReal.instance.write(userPath, {
          'profile': {
            'contact': {'email': 'updated@example.com'}
          }
        });

        final updatedResult = await FirefastReal.instance.read(userPath);
        expect(updatedResult?['profile']['contact']['email'],
            'updated@example.com');
        expect(updatedResult?['profile']['contact']['phone'], isNull);
        expect(updatedResult?['profile']['name'], isNull);
      });

      test('write should merge deep nested fields correctly', () async {
        // Arrange
        final path = 'users/deepNested';
        final initialData = {
          'level1': {
            'level2': {
              'level3': {
                'level4': {'value': 'original', 'extra': 'data'}
              }
            }
          }
        };
        final updateData = {
          'level1': {
            'level2': {
              'level3': {
                'level4': {'value': 'updated'}
              }
            }
          }
        };

        // Act
        await FirefastReal.instance.write(path, initialData);
        await FirefastReal.instance.write(path, updateData);

        // Assert
        final result = await FirefastReal.instance.read(path);
        expect(result?['level1']['level2']['level3']['level4']['value'],
            'updated');
        expect(result?['level1']['level2']['level3']['level4']['extra'], null);
      });
    });

    // Edge cases
    group('Edge cases', () {
      test('should handle empty data', () async {
        // Arrange
        final path = 'empty/node';
        final emptyData = <String, dynamic>{};

        // Act
        await FirefastReal.instance.write(path, emptyData);
        final result = await FirefastReal.instance.read(path);

        // Assert
        expect(result, isNotNull);
        expect(result, isEmpty);
      });

      test('should handle data with special characters in field names',
          () async {
        // Arrange
        final path = 'special/node';
        final specialData = {
          'field-with-dashes': 'value',
          'field_with_underscores': 'value',
          'field with spaces': 'value',
        };

        // Act
        await FirefastReal.instance.write(path, specialData);
        final result = await FirefastReal.instance.read(path);

        // Assert
        expect(result, specialData);
      });

      test('should handle various data types', () async {
        // Arrange
        final path = 'types/node';
        // Note: Firebase Realtime Database has more limited type support
        // compared to Firestore, but should support these types
        final data = {
          'string': 'text',
          'number': 123,
          'double': 123.45,
          'boolean': true,
          'null': null,
          'array': [1, 2, 3, 'string', true],
          'map': {'key': 'value'},
        };

        // Act
        await FirefastReal.instance.write(path, data);
        final result = await FirefastReal.instance.read(path);

        // Assert
        expect(result?['string'], 'text');
        expect(result?['number'], 123);
        expect(result?['double'], 123.45);
        expect(result?['boolean'], true);
        expect(result?['null'], null);
        expect(result?['array'], [1, 2, 3, 'string', true]);
        expect(result?['map'], {'key': 'value'});
      });

      test('should handle data at root level', () async {
        // Arrange
        final path = '';
        final data = {'rootKey': 'rootValue'};

        // Act
        await FirefastReal.instance.write(path, data);
        final result = await FirefastReal.instance.read(path);

        // Assert
        expect(result?['rootKey'], 'rootValue');
      });
    });

    // Sequential operations test
    test('sequential operations on the same node', () async {
      // Arrange
      final path = 'items/sequential';

      // Act & Assert - series of operations
      // 1. Create node
      await FirefastReal.instance
          .write(path, {'status': 'created', 'count': 0});
      var result = await FirefastReal.instance.read(path);
      expect(result?['status'], 'created');

      // 2. Update node
      await FirefastReal.instance
          .write(path, {'status': 'updated', 'count': 1});
      result = await FirefastReal.instance.read(path);
      expect(result?['status'], 'updated');
      expect(result?['count'], 1);

      // 3. Partial update
      await FirefastReal.instance.write(path, {'count': 2});
      result = await FirefastReal.instance.read(path);
      expect(result?['status'], 'updated');
      expect(result?['count'], 2);

      // 4. Overwrite
      await FirefastReal.instance.overwrite(path, {'final': true});
      result = await FirefastReal.instance.read(path);
      expect(result, {'final': true});

      // 5. Delete
      await FirefastReal.instance.delete(path);
      result = await FirefastReal.instance.read(path);
      expect(result, isNull);
    });

    // Multiple nodes test
    test('operations on multiple nodes', () async {
      // Arrange
      final count = 20; // Number of nodes to create

      // Act
      for (int i = 0; i < count; i++) {
        await FirefastReal.instance.write('multi/node$i', {
          'index': i,
          'value': 'test-$i',
          'even': i % 2 == 0,
        });
      }

      // Assert
      for (int i = 0; i < count; i++) {
        final node = await FirefastReal.instance.read('multi/node$i');
        expect(node?['index'], i);
        expect(node?['value'], 'test-$i');
        expect(node?['even'], i % 2 == 0);
      }

      // Test reading a non-existent node
      final nonExistentNode =
          await FirefastReal.instance.read('multi/nodeNonExistent');
      expect(nonExistentNode, isNull);
    });

    // Type conversions
    test('type conversion from Firebase types', () async {
      // This test specifically checks that the FastRealtime.read() method
      // properly converts Firebase's Map<Object?, Object?> to Map<String, dynamic>

      // Arrange
      final path = 'conversion/test';
      final data = {
        'string': 'value',
        'number': 123,
        'nested': {'key': 'value'}
      };

      // Act
      await FirefastReal.instance.write(path, data);
      final result = await FirefastReal.instance.read(path);

      // Assert
      expect(result, isA<Map<String, dynamic>>());
      expect(result?['nested'], isA<Map<String, dynamic>>());
      expect(result, data);
    });

    // Error handling
    test('should handle null values correctly', () async {
      // Arrange
      final path = 'null/test';

      // Act - Set null directly
      await FirefastReal.instance.write(path, {'nullValue': null});
      final result = await FirefastReal.instance.read(path);

      // Assert
      expect(result?['nullValue'], null);

      // Set entire node to null
      await FirefastReal.instance.delete(path);
      final nullResult = await FirefastReal.instance.read(path);
      expect(nullResult, null);
    });
  });
}
