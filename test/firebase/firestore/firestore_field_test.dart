import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firefast/firefast_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firefast/firefast_core.dart';
import 'firestore_test_utils.dart';

void main() {
  group('FirestoreField tests', () {
    setUp(() {
      FirestoreTestUtils.setUpFireTests();
    });

    tearDown(() {
      FirestoreTestUtils.clearServices();
    });

    // Basic CRUD operations
    group('Basic CRUD operations', () {
      test('write() should store a single field in a document', () async {
        // Arrange
        final docPath = FirefastStore.col('users').doc('user1');
        final nameField = FireField<String>(
          name: 'name',
          toFire: () async => 'Test User',
          fromFire: (dynamic value) => value.toString(),
        );
        final firestoreField = nameField.firestore(docPath);

        // Act
        await firestoreField.write();

        // Assert
        final result = await FirefastStore.instance.read('users/user1');
        expect(result, {'name': 'Test User'});
      });

      test('write() should merge field data with existing document', () async {
        // Arrange
        final docPath = FirefastStore.col('users').doc('user2');

        // Create initial field
        final nameField = FireField<String>(
          name: 'name',
          toFire: () async => 'Test User',
          fromFire: (dynamic value) => value.toString(),
        );

        // Add email field
        final emailField = FireField<String>(
          name: 'email',
          toFire: () async => 'test@example.com',
          fromFire: (dynamic value) => value.toString(),
        );

        // Create Firestore fields
        final nameFirestoreField = nameField.firestore(docPath);
        final emailFirestoreField = emailField.firestore(docPath);

        // Act
        await nameFirestoreField.write();
        await emailFirestoreField.write();

        // Assert
        final result = await FirefastStore.instance.read('users/user2');
        expect(result, {
          'name': 'Test User',
          'email': 'test@example.com',
        });
      });

      test('write() should update existing field in a document', () async {
        // Arrange
        final docPath = FirefastStore.col('users').doc('user3');

        // Create initial field
        final ageField = FireField<int>(
          name: 'age',
          toFire: () async => 30,
          fromFire: (dynamic value) => value as int,
        );

        // Create updated field with the same name
        final updatedAgeField = FireField<int>(
          name: 'age',
          toFire: () async => 31,
          fromFire: (dynamic value) => value as int,
        );

        // Create Firestore fields
        final ageFirestoreField = ageField.firestore(docPath);
        final updatedAgeFirestoreField = updatedAgeField.firestore(docPath);

        // Act
        await ageFirestoreField.write();
        await updatedAgeFirestoreField.write();

        // Assert
        final result = await FirefastStore.instance.read('users/user3');
        expect(result, {'age': 31});
      });

      test('read() should return null for non-existent field', () async {
        // Arrange
        final docPath = FirefastStore.col('users').doc('nonExistentUser');
        final nameField = FireField<String>(
          name: 'name',
          toFire: () async => 'Test User',
          fromFire: (dynamic value) => value.toString(),
        );
        final firestoreField = nameField.firestore(docPath);

        // Act
        final result = await firestoreField.read();

        // Assert
        expect(result, isNull);
      });

      test('read() should return field data for existing document field',
          () async {
        // Arrange
        final docPath = FirefastStore.col('users').doc('user4');
        final nameField = FireField<String>(
          name: 'name',
          toFire: () async => 'Test User',
          fromFire: (dynamic value) => value.toString(),
        );
        final firestoreField = nameField.firestore(docPath);

        // Act
        await firestoreField.write();
        final result = await firestoreField.read();

        // Assert
        expect(result, 'Test User');
      });

      test('document is deleted when using FastFirestore.instance.delete()',
          () async {
        // Arrange
        final docPath = FirefastStore.col('users').doc('userToDelete');
        final nameField = FireField<String>(
          name: 'name',
          toFire: () async => 'User To Delete',
          fromFire: (dynamic value) => value.toString(),
        );
        final firestoreField = nameField.firestore(docPath);

        // Act
        await firestoreField.write();
        final beforeDelete = await firestoreField.read();
        await FirefastStore.instance.delete(docPath.path);
        final afterDelete = await firestoreField.read();

        // Assert
        expect(beforeDelete, 'User To Delete');
        expect(afterDelete, isNull);
      });
    });

    // Nested data operations
    group('Nested data operations', () {
      test('complex nested objects can be written and read correctly',
          () async {
        // Arrange
        final docPath = FirefastStore.col('users').doc('complexUser');

        // Create a field with a nested object
        final profileField = FireField<Map<String, dynamic>>(
          name: 'profile',
          toFire: () async => {
            'name': 'Complex User',
            'contact': {'email': 'complex@example.com', 'phone': '1234567890'}
          },
          fromFire: (dynamic value) => value as Map<String, dynamic>,
        );

        final firestoreField = profileField.firestore(docPath);

        // Act
        await firestoreField.write();
        final result = await firestoreField.read();

        // Assert
        expect(result, isA<Map<String, dynamic>>());
        expect(result?['name'], 'Complex User');
        expect(result?['contact']['email'], 'complex@example.com');
        expect(result?['contact']['phone'], '1234567890');
      });

      test('nested field can be updated independently', () async {
        // Arrange
        final docPath = FirefastStore.col('users').doc('nestedUpdateUser');

        // Create initial nested object
        final initialProfileField = FireField<Map<String, dynamic>>(
          name: 'profile',
          toFire: () async => {
            'name': 'Test User',
            'contact': {'email': 'test@example.com', 'phone': '1234567890'}
          },
          fromFire: (dynamic value) => value as Map<String, dynamic>,
        );

        // Create update for just the nested email
        final updatedProfileField = FireField<Map<String, dynamic>>(
          name: 'profile',
          toFire: () async => {
            'contact': {'email': 'updated@example.com'}
          },
          fromFire: (dynamic value) => value as Map<String, dynamic>,
        );

        final initialFirestoreField = initialProfileField.firestore(docPath);
        final updatedFirestoreField = updatedProfileField.firestore(docPath);

        // Act
        await initialFirestoreField.write();
        await updatedFirestoreField.write();
        final result = await FirefastStore.instance.read(docPath.path);

        // Assert
        expect(result?['profile']['name'], 'Test User');
        expect(result?['profile']['contact']['email'], 'updated@example.com');
        expect(result?['profile']['contact']['phone'], '1234567890');
      });
    });

    // Multiple fields in same document
    group('Multiple fields in same document', () {
      test(
          'multiple FirestoreField instances referring to same document can coexist',
          () async {
        // Arrange
        final docPath = FirefastStore.col('users').doc('multiFieldUser');

        // Create multiple fields for the same document
        final nameField = FireField<String>(
          name: 'name',
          toFire: () async => 'Multi Field User',
          fromFire: (dynamic value) => value.toString(),
        );

        final ageField = FireField<int>(
          name: 'age',
          toFire: () async => 25,
          fromFire: (dynamic value) => value as int,
        );

        final activeField = FireField<bool>(
          name: 'active',
          toFire: () async => true,
          fromFire: (dynamic value) => value as bool,
        );

        final nameFirestoreField = nameField.firestore(docPath);
        final ageFirestoreField = ageField.firestore(docPath);
        final activeFirestoreField = activeField.firestore(docPath);

        // Act
        await nameFirestoreField.write();
        await ageFirestoreField.write();
        await activeFirestoreField.write();

        final nameResult = await nameFirestoreField.read();
        final ageResult = await ageFirestoreField.read();
        final activeResult = await activeFirestoreField.read();

        // Get the full document
        final fullDoc = await FirefastStore.instance.read(docPath.path);

        // Assert
        expect(nameResult, 'Multi Field User');
        expect(ageResult, 25);
        expect(activeResult, true);

        expect(fullDoc, {
          'name': 'Multi Field User',
          'age': 25,
          'active': true,
        });
      });
    });

    // Data type tests
    group('Data types', () {
      test('handles various data types correctly', () async {
        // Arrange
        final docPath = FirefastStore.col('types').doc('typeTest');
        final date = DateTime.now();

        // String type
        final stringField = FireField<String>(
          name: 'string',
          toFire: () async => 'text',
          fromFire: (dynamic value) => value.toString(),
        ).firestore(docPath);

        // Number (int) type
        final intField = FireField<int>(
          name: 'number',
          toFire: () async => 123,
          fromFire: (dynamic value) => value as int,
        ).firestore(docPath);

        // Double type
        final doubleField = FireField<double>(
          name: 'double',
          toFire: () async => 123.45,
          fromFire: (dynamic value) => value as double,
        ).firestore(docPath);

        // Boolean type
        final boolField = FireField<bool>(
          name: 'boolean',
          toFire: () async => true,
          fromFire: (dynamic value) => value as bool,
        ).firestore(docPath);

        // Nullable field
        final nullField = FireField<String?>(
          name: 'null',
          toFire: () async => null,
          fromFire: (dynamic value) => value?.toString(),
        ).firestore(docPath);

        // DateTime field
        final dateField = FireField<Timestamp>(
          name: 'timestamp',
          toFire: () async => date,
          fromFire: (dynamic value) => value as Timestamp,
        ).firestore(docPath);

        // Array/List field
        final arrayField = FireField<List<dynamic>>(
          name: 'array',
          toFire: () async => [1, 2, 3, 'string', true],
          fromFire: (dynamic value) => value as List<dynamic>,
        ).firestore(docPath);

        // Map field
        final mapField = FireField<Map<String, dynamic>>(
          name: 'map',
          toFire: () async => {'key': 'value'},
          fromFire: (dynamic value) => value as Map<String, dynamic>,
        ).firestore(docPath);

        // Act - write all fields
        await stringField.write();
        await intField.write();
        await doubleField.write();
        await boolField.write();
        await nullField.write();
        await dateField.write();
        await arrayField.write();
        await mapField.write();

        // Read all values
        final stringResult = await stringField.read();
        final intResult = await intField.read();
        final doubleResult = await doubleField.read();
        final boolResult = await boolField.read();
        final nullResult = await nullField.read();
        final dateResult = await dateField.read();
        final arrayResult = await arrayField.read();
        final mapResult = await mapField.read();

        // Assert
        expect(stringResult, 'text');
        expect(intResult, 123);
        expect(doubleResult, 123.45);
        expect(boolResult, true);
        expect(nullResult, null);
        expect(dateResult,
            isNotNull); // DateTime comparison is tricky, just verify it exists
        expect(arrayResult, [1, 2, 3, 'string', true]);
        expect(mapResult, {'key': 'value'});
      });

      test('handles empty values correctly', () async {
        // Arrange
        final docPath = FirefastStore.col('types').doc('emptyTest');

        // Empty string
        final emptyStringField = FireField<String>(
          name: 'emptyString',
          toFire: () async => '',
          fromFire: (dynamic value) => value.toString(),
        ).firestore(docPath);

        // Empty list
        final emptyArrayField = FireField<List<dynamic>>(
          name: 'emptyArray',
          toFire: () async => [],
          fromFire: (dynamic value) => value as List<dynamic>,
        ).firestore(docPath);

        // Empty map
        final emptyMapField = FireField<Map<String, dynamic>>(
          name: 'emptyMap',
          toFire: () async => {},
          fromFire: (dynamic value) =>
              (value as Map).map((k, v) => MapEntry(k as String, v)),
        ).firestore(docPath);

        // Act
        await emptyStringField.write();
        await emptyArrayField.write();
        await emptyMapField.write();

        final emptyStringResult = await emptyStringField.read();
        final emptyArrayResult = await emptyArrayField.read();
        final emptyMapResult = await emptyMapField.read();

        // Assert
        expect(emptyStringResult, '');
        expect(emptyArrayResult, isEmpty);
        expect(emptyMapResult, isEmpty);
      });
    });

    // Edge cases
    group('Edge cases', () {
      test('handles fields with special characters in name', () async {
        // Arrange
        final docPath = FirefastStore.col('special').doc('specialFields');

        // Field with dashes
        final dashedField = FireField<String>(
          name: 'field-with-dashes',
          toFire: () async => 'dashed value',
          fromFire: (dynamic value) => value.toString(),
        ).firestore(docPath);

        // Field with underscores
        final underscoreField = FireField<String>(
          name: 'field_with_underscores',
          toFire: () async => 'underscore value',
          fromFire: (dynamic value) => value.toString(),
        ).firestore(docPath);

        // Field with spaces
        final spacedField = FireField<String>(
          name: 'field with spaces',
          toFire: () async => 'spaced value',
          fromFire: (dynamic value) => value.toString(),
        ).firestore(docPath);

        // Act
        await dashedField.write();
        await underscoreField.write();
        await spacedField.write();

        final dashedResult = await dashedField.read();
        final underscoreResult = await underscoreField.read();
        final spacedResult = await spacedField.read();

        // Get full document
        final fullDoc = await FirefastStore.instance.read(docPath.path);

        // Assert
        expect(dashedResult, 'dashed value');
        expect(underscoreResult, 'underscore value');
        expect(spacedResult, 'spaced value');

        expect(fullDoc, {
          'field-with-dashes': 'dashed value',
          'field_with_underscores': 'underscore value',
          'field with spaces': 'spaced value',
        });
      });

      test('handles fields with special characters in document path', () async {
        // Arrange
        final docPath = FirefastStore.col('collection with spaces')
            .doc('document-with-dashes_and_underscores');

        final field = FireField<String>(
          name: 'field',
          toFire: () async => 'value',
          fromFire: (dynamic value) => value.toString(),
        ).firestore(docPath);

        // Act
        await field.write();
        final result = await field.read();

        // Assert
        expect(result, 'value');
      });
    });

    // Sequential operations test
    test('sequential operations on the same field', () async {
      // Arrange
      final docPath = FirefastStore.col('items').doc('sequentialField');

      // Create a status field
      final statusField = FireField<String>(
        name: 'status',
        toFire: () async => 'created',
        fromFire: (dynamic value) => value.toString(),
      ).firestore(docPath);

      // Create a counter field
      final countField = FireField<int>(
        name: 'count',
        toFire: () async => 0,
        fromFire: (dynamic value) => value as int,
      ).firestore(docPath);

      // For later updates
      FireField<String> makeStatusField(String status) {
        return FireField<String>(
          name: 'status',
          toFire: () async => status,
          fromFire: (dynamic value) => value.toString(),
        );
      }

      FireField<int> makeCountField(int count) {
        return FireField<int>(
          name: 'count',
          toFire: () async => count,
          fromFire: (dynamic value) => value as int,
        );
      }

      // Act & Assert - series of operations
      // 1. Create fields
      await statusField.write();
      await countField.write();
      var statusResult = await statusField.read();
      var countResult = await countField.read();
      expect(statusResult, 'created');
      expect(countResult, 0);

      // 2. Update status field
      final statusField2 = makeStatusField('updated').firestore(docPath);
      await statusField2.write();
      statusResult = await statusField2.read();
      countResult = await countField.read();
      expect(statusResult, 'updated');
      expect(countResult, 0);

      // 3. Update count field
      final countField2 = makeCountField(1).firestore(docPath);
      await countField2.write();
      statusResult = await statusField2.read();
      countResult = await countField2.read();
      expect(statusResult, 'updated');
      expect(countResult, 1);

      // 4. Delete the document
      await FirefastStore.instance.delete(docPath.path);
      statusResult = await statusField2.read();
      countResult = await countField2.read();
      expect(statusResult, isNull);
      expect(countResult, isNull);
    });

    // Field interaction across documents
    test('fields in different documents dont affect each other', () async {
      // Arrange
      final docPath1 = FirefastStore.col('users').doc('user1ForIsolation');
      final docPath2 = FirefastStore.col('users').doc('user2ForIsolation');

      // Same field name in two different documents
      final nameField1 = FireField<String>(
        name: 'name',
        toFire: () async => 'User 1',
        fromFire: (dynamic value) => value.toString(),
      ).firestore(docPath1);

      final nameField2 = FireField<String>(
        name: 'name',
        toFire: () async => 'User 2',
        fromFire: (dynamic value) => value.toString(),
      ).firestore(docPath2);

      // Act
      await nameField1.write();
      await nameField2.write();
      final result1 = await nameField1.read();
      final result2 = await nameField2.read();

      // Assert
      expect(result1, 'User 1');
      expect(result2, 'User 2');

      // Update one document and ensure the other is unaffected
      final updatedNameField1 = FireField<String>(
        name: 'name',
        toFire: () async => 'Updated User 1',
        fromFire: (dynamic value) => value.toString(),
      ).firestore(docPath1);

      await updatedNameField1.write();
      final updatedResult1 = await updatedNameField1.read();
      final stillResult2 = await nameField2.read();

      expect(updatedResult1, 'Updated User 1');
      expect(stillResult2, 'User 2');
    });

    // Stress test with multiple fields
    test('stress test with multiple fields', () async {
      // Arrange
      final docPath = FirefastStore.col('stress').doc('multiFields');
      final count = 20; // Number of fields to create

      final fields = <FirestoreField<int>>[];

      // Create multiple fields
      for (int i = 0; i < count; i++) {
        final field = FireField<int>(
          name: 'field$i',
          toFire: () async => i,
          fromFire: (dynamic value) => value as int,
        ).firestore(docPath);

        fields.add(field);
      }

      // Act - write all fields
      for (final field in fields) {
        await field.write();
      }

      // Read all fields
      final results = <int?>[];
      for (final field in fields) {
        results.add(await field.read());
      }

      // Get the full document
      final fullDoc = await FirefastStore.instance.read(docPath.path);

      // Assert
      for (int i = 0; i < count; i++) {
        expect(results[i], i);
        expect(fullDoc?['field$i'], i);
      }
    });

    // Test creating field using document path methods
    test('create field using FirestoreDocumentPath.toField', () async {
      // Arrange
      final docPath = FirefastStore.col('users').doc('userFromDocPath');

      // Create field from FirestoreDocumentPath's toField method
      final nameField = FireField<String>(
        name: 'name',
        toFire: () async => 'Created from DocPath',
        fromFire: (dynamic value) => value.toString(),
      );

      final firestoreField = docPath.toField(nameField);

      // Act
      await firestoreField.write();
      final result = await firestoreField.read();

      // Assert
      expect(result, 'Created from DocPath');
    });

    // Test creating field using FirestoreDocumentPath.createField
    test('create field using FirestoreDocumentPath.createField', () async {
      // Arrange
      final docPath = FirefastStore.col('users').doc('userFromCreateField');

      // Create field directly using the createField method
      final firestoreField = docPath.createField<String>(
        name: 'directName',
        toFire: () async => 'Created directly',
        fromFire: (dynamic value) => value.toString(),
      );

      // Act
      await firestoreField.write();
      final result = await firestoreField.read();

      // Assert
      expect(result, 'Created directly');
    });

    // Test using FireField.firestoreNewDoc
    test('create field using FireField.firestoreNewDoc', () async {
      // Arrange
      final nameField = FireField<String>(
        name: 'name',
        toFire: () async => 'New Doc Field',
        fromFire: (dynamic value) => value.toString(),
      );

      // Create FirestoreField using the firestoreNewDoc extension
      final firestoreField =
          nameField.firestoreNewDoc('users', 'userFromNewDoc');

      // Act
      await firestoreField.write();
      final result = await firestoreField.read();

      // Assert
      expect(result, 'New Doc Field');
    });
  });
}
