import 'package:firefast/firefast_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'firestore_test_utils.dart';

void main() {
  group('FastFirestore.instance tests', () {
    setUp(() {
      FirestoreTestUtils.setUpFireTests();
    });

    tearDown(() {
      FirestoreTestUtils.clearServices();
    });

    // Basic CRUD operations
    group('Basic CRUD operations', () {
      test('write() should merge data at a document path', () async {
        // Arrange
        final path = 'users/testUser';
        final initialData = {'name': 'Test User', 'age': 30};
        final updateData = {'email': 'test@example.com', 'age': 31};

        // Act
        await FirefastStore.instance.write(path, initialData);
        await FirefastStore.instance.write(path, updateData);

        // Assert
        final result = await FirefastStore.instance.read(path);
        expect(result, {
          'name': 'Test User',
          'email': 'test@example.com',
          'age': 31,
        });
      });

      test('overwrite() should replace data at a document path', () async {
        // Arrange
        final path = 'users/testUser';
        final initialData = {
          'name': 'Test User',
          'age': 30,
          'email': 'test@example.com'
        };
        final newData = {'name': 'Updated User'};

        // Act
        await FirefastStore.instance.write(path, initialData);
        await FirefastStore.instance.overwrite(path, newData);

        // Assert
        final result = await FirefastStore.instance.read(path);
        expect(result, {'name': 'Updated User'});
      });

      test('read() should return null for non-existent document', () async {
        // Arrange
        final path = 'users/nonExistentUser';

        // Act
        final result = await FirefastStore.instance.read(path);

        // Assert
        expect(result, isNull);
      });

      test('read() should return data for existing document', () async {
        // Arrange
        final path = 'users/testUser';
        final data = {'name': 'Test User', 'age': 30};

        // Act
        await FirefastStore.instance.write(path, data);
        final result = await FirefastStore.instance.read(path);

        // Assert
        expect(result, data);
      });

      test('delete() should remove document', () async {
        // Arrange
        final path = 'users/testUser';
        final data = {'name': 'Test User'};

        // Act
        await FirefastStore.instance.write(path, data);
        final beforeDelete = await FirefastStore.instance.read(path);
        await FirefastStore.instance.delete(path);
        final afterDelete = await FirefastStore.instance.read(path);

        // Assert
        expect(beforeDelete, isNotNull);
        expect(afterDelete, isNull);
      });

      test('col() should return FirestoreCollectionPath', () {
        // Act
        final collectionPath = FirefastStore.col('users');

        // Assert
        expect(collectionPath, isA<FirestoreCollectionPath>());
        expect(collectionPath.path, equals('users'));
      });
    });

    // Nested data operations
    group('Nested data operations', () {
      test('complex operations with nested data', () async {
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
        await FirefastStore.instance.write(userPath, userData);
        final result = await FirefastStore.instance.read(userPath);

        // Assert
        expect(result, userData);

        // Update nested field
        await FirefastStore.instance.write(userPath, {
          'profile': {
            'contact': {'email': 'updated@example.com'}
          }
        });

        final updatedResult = await FirefastStore.instance.read(userPath);
        expect(updatedResult?['profile']['contact']['email'],
            'updated@example.com');
        expect(updatedResult?['profile']['contact']['phone'], '1234567890');
        expect(updatedResult?['profile']['name'], 'Test User');
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
        await FirefastStore.instance.write(path, initialData);
        await FirefastStore.instance.write(path, updateData);

        // Assert
        final result = await FirefastStore.instance.read(path);
        expect(result?['level1']['level2']['level3']['level4']['value'],
            'updated');
        expect(
            result?['level1']['level2']['level3']['level4']['extra'], 'data');
      });
    });

    // Collections operations
    group('Collections operations', () {
      test('should store and retrieve multiple documents in a collection',
          () async {
        // Arrange
        final users = [
          {'id': 'user1', 'name': 'User One', 'age': 25},
          {'id': 'user2', 'name': 'User Two', 'age': 30},
          {'id': 'user3', 'name': 'User Three', 'age': 35},
        ];

        // Act
        for (final user in users) {
          await FirefastStore.instance.write('users/${user['id']}', user);
        }

        // Assert
        for (final user in users) {
          final result =
              await FirefastStore.instance.read('users/${user['id']}');
          expect(result, user);
        }
      });

      test('should be able to query documents using firestore directly',
          () async {
        // Arrange
        final products = [
          {'id': 'prod1', 'name': 'Product 1', 'price': 10.0, 'category': 'A'},
          {'id': 'prod2', 'name': 'Product 2', 'price': 20.0, 'category': 'B'},
          {'id': 'prod3', 'name': 'Product 3', 'price': 15.0, 'category': 'A'},
          {'id': 'prod4', 'name': 'Product 4', 'price': 25.0, 'category': 'B'},
        ];

        // Act
        for (final product in products) {
          await FirefastStore.instance
              .write('products/${product['id']}', product);
        }

        // Get category A products using the underlying firestore
        final querySnapshot = await FirefastStore.instance.datasource
            .collection('products')
            .where('category', isEqualTo: 'A')
            .get();

        // Assert
        expect(querySnapshot.docs.length, 2);

        final categoryAProducts =
            querySnapshot.docs.map((doc) => doc.data()).toList();
        expect(
            categoryAProducts.any((product) => product['name'] == 'Product 1'),
            isTrue);
        expect(
            categoryAProducts.any((product) => product['name'] == 'Product 3'),
            isTrue);
      });
    });

    // Edge cases
    group('Edge cases', () {
      test('should handle empty documents', () async {
        // Arrange
        final path = 'empty/doc';
        final emptyData = <String, dynamic>{};

        // Act
        await FirefastStore.instance.write(path, emptyData);
        final result = await FirefastStore.instance.read(path);

        // Assert
        expect(result, isNotNull);
        expect(result, isEmpty);
      });

      test('should handle documents with special characters in field names',
          () async {
        // Arrange
        final path = 'special/doc';
        final specialData = {
          'field-with-dashes': 'value',
          'field_with_underscores': 'value',
          'field with spaces': 'value',
        };

        // Act
        await FirefastStore.instance.write(path, specialData);
        final result = await FirefastStore.instance.read(path);

        // Assert
        expect(result, specialData);
      });

      test('should handle documents with special characters in path', () async {
        // Arrange
        final path =
            'collection with spaces/document-with-dashes_and_underscores';
        final data = {'field': 'value'};

        // Act
        await FirefastStore.instance.write(path, data);
        final result = await FirefastStore.instance.read(path);

        // Assert
        expect(result, data);
      });

      test('should handle various data types', () async {
        // Arrange
        final path = 'types/doc';
        final date = DateTime.now();
        final data = {
          'string': 'text',
          'number': 123,
          'double': 123.45,
          'boolean': true,
          'null': null,
          'timestamp': date,
          'array': [1, 2, 3, 'string', true],
          'map': {'key': 'value'},
        };

        // Act
        await FirefastStore.instance.write(path, data);
        final result = await FirefastStore.instance.read(path);

        // Assert
        expect(result?['string'], 'text');
        expect(result?['number'], 123);
        expect(result?['double'], 123.45);
        expect(result?['boolean'], true);
        expect(result?['null'], null);
        // Timestamp comparison is tricky, just verify it exists
        expect(result?['timestamp'], isNotNull);
        expect(result?['array'], [1, 2, 3, 'string', true]);
        expect(result?['map'], {'key': 'value'});
      });
    });

    // Sequential operations test
    test('sequential operations on the same document', () async {
      // Arrange
      final path = 'items/sequential';

      // Act & Assert - series of operations
      // 1. Create document
      await FirefastStore.instance
          .write(path, {'status': 'created', 'count': 0});
      var result = await FirefastStore.instance.read(path);
      expect(result?['status'], 'created');

      // 2. Update document
      await FirefastStore.instance
          .write(path, {'status': 'updated', 'count': 1});
      result = await FirefastStore.instance.read(path);
      expect(result?['status'], 'updated');
      expect(result?['count'], 1);

      // 3. Partial update
      await FirefastStore.instance.write(path, {'count': 2});
      result = await FirefastStore.instance.read(path);
      expect(result?['status'], 'updated');
      expect(result?['count'], 2);

      // 4. Overwrite
      await FirefastStore.instance.overwrite(path, {'final': true});
      result = await FirefastStore.instance.read(path);
      expect(result, {'final': true});

      // 5. Delete
      await FirefastStore.instance.delete(path);
      result = await FirefastStore.instance.read(path);
      expect(result, isNull);
    });

    // Stress test with multiple documents
    test('stress test with multiple documents', () async {
      // Arrange
      final count = 20; // Number of documents to create

      // Act
      for (int i = 0; i < count; i++) {
        await FirefastStore.instance.write('stress/doc$i', {
          'index': i,
          'value': 'test-$i',
          'even': i % 2 == 0,
        });
      }

      // Assert
      for (int i = 0; i < count; i++) {
        final doc = await FirefastStore.instance.read('stress/doc$i');
        expect(doc?['index'], i);
        expect(doc?['value'], 'test-$i');
        expect(doc?['even'], i % 2 == 0);
      }
    });
  });
}
