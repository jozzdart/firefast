import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firefast/firefast_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firefast/firefast_core.dart';
import 'firestore_test_utils.dart';

void main() {
  group('FirestoreDocument tests', () {
    setUp(() {
      FirestoreTestUtils.setUpFireTests();
    });

    tearDown(() {
      FirestoreTestUtils.clearServices();
    });

    // Basic CRUD operations
    group('Basic CRUD operations', () {
      test('write() should store a document with fields', () async {
        // Arrange
        final nameField = FireField<String>(
          name: 'name',
          toFire: () async => 'Test User',
          fromFire: (dynamic value) => value.toString(),
        );

        final ageField = FireField<int>(
          name: 'age',
          toFire: () async => 30,
          fromFire: (dynamic value) => value as int,
        );

        final doc = FirestoreDocument(
          path: FirefastStore.col('users').doc('user1'),
          fieldSet: [nameField, ageField].toFireSet(),
        );

        // Act
        await doc.write();

        // Assert
        final result = await FirefastStore.instance.read('users/user1');
        expect(result, {'name': 'Test User', 'age': 30});
      });

      test('overwrite() should replace document data', () async {
        // Arrange
        final docPath = FirefastStore.col('users').doc('user2');

        // Initial document
        final initialDoc = FirestoreDocument(
          path: docPath,
          fieldSet: [
            FireField<String>(
              name: 'name',
              toFire: () async => 'Initial User',
              fromFire: (dynamic value) => value.toString(),
            ),
            FireField<int>(
              name: 'age',
              toFire: () async => 25,
              fromFire: (dynamic value) => value as int,
            ),
            FireField<bool>(
              name: 'active',
              toFire: () async => true,
              fromFire: (dynamic value) => value as bool,
            ),
          ].toFireSet(),
        );

        // Replacement document with different fields
        final replacementDoc = FirestoreDocument(
          path: docPath,
          fieldSet: [
            FireField<String>(
              name: 'name',
              toFire: () async => 'Replacement User',
              fromFire: (dynamic value) => value.toString(),
            ),
            FireField<String>(
              name: 'email',
              toFire: () async => 'user@example.com',
              fromFire: (dynamic value) => value.toString(),
            ),
          ].toFireSet(),
        );

        // Act
        await initialDoc.write();
        final beforeOverwrite = await FirefastStore.instance.read(docPath.path);
        await replacementDoc.overwrite();
        final afterOverwrite = await FirefastStore.instance.read(docPath.path);

        // Assert
        expect(beforeOverwrite, {
          'name': 'Initial User',
          'age': 25,
          'active': true,
        });

        expect(afterOverwrite, {
          'name': 'Replacement User',
          'email': 'user@example.com',
        });
      });

      test('read() should return document as output', () async {
        // Arrange
        final docPath = FirefastStore.col('users').doc('user3');
        final nameField = FireField<String>(
          name: 'name',
          toFire: () async => 'Test User',
          fromFire: (dynamic value) => value.toString(),
        );

        final ageField = FireField<int>(
          name: 'age',
          toFire: () async => 30,
          fromFire: (dynamic value) => value as int,
        );

        final doc = FirestoreDocument(
          path: docPath,
          fieldSet: [nameField, ageField].toFireSet(),
        );

        // Act
        await doc.write();
        final output = await doc.read();

        // Assert
        expect(output, isNotNull);
        expect(output!.getValue<String>('name'), 'Test User');
        expect(output.getValue<int>('age'), 30);
      });

      test('read() should return null for non-existent document', () async {
        // Arrange
        final docPath = FirefastStore.col('users').doc('nonExistentUser');
        final doc = FirestoreDocument(
          path: docPath,
          fieldSet: [
            FireField<String>(
              name: 'name',
              toFire: () async => 'Test User',
              fromFire: (dynamic value) => value.toString(),
            ),
          ].toFireSet(),
        );

        // Act
        final output = await doc.read();

        // Assert
        expect(output, isNull);
      });

      test('delete() should remove the document', () async {
        // Arrange
        final docPath = FirefastStore.col('users').doc('userToDelete');
        final nameField = FireField<String>(
          name: 'name',
          toFire: () async => 'User To Delete',
          fromFire: (dynamic value) => value.toString(),
        );

        final doc = FirestoreDocument(
          path: docPath,
          fieldSet: [nameField].toFireSet(),
        );

        // Act
        await doc.write();
        final beforeDelete = await doc.read();
        await doc.delete();
        final afterDelete = await doc.read();

        // Assert
        expect(beforeDelete, isNotNull);
        expect(beforeDelete!.getValue<String>('name'), 'User To Delete');
        expect(afterDelete, isNull);
      });
    });

    // Document properties
    group('Document properties', () {
      test('id should return document ID', () {
        // Arrange
        final docPath = FirefastStore.col('users').doc('testId');
        final doc = FirestoreDocument(
          path: docPath,
          fieldSet: List<FireField>.empty().toFireSet(),
        );

        // Act & Assert
        expect(doc.id, 'testId');
      });

      test('collectionPath should return parent collection path', () {
        // Arrange
        final docPath = FirefastStore.col('users').doc('testDoc');
        final doc = FirestoreDocument(
          path: docPath,
          fieldSet: List<FireField>.empty().toFireSet(),
        );

        // Act
        final collectionPath = doc.collection.path;

        // Assert
        expect(collectionPath, 'users');
      });

      test('copyWith should create new instance with specified changes', () {
        // Arrange
        final originalPath = FirefastStore.col('users').doc('original');
        final newPath = FirefastStore.col('users').doc('new');

        final originalFields = [
          FireField<String>(
            name: 'name',
            toFire: () async => 'Original',
            fromFire: (dynamic value) => value.toString(),
          ),
        ];

        final newFields = [
          FireField<String>(
            name: 'name',
            toFire: () async => 'New',
            fromFire: (dynamic value) => value.toString(),
          ),
          FireField<int>(
            name: 'age',
            toFire: () async => 25,
            fromFire: (dynamic value) => value as int,
          ),
        ];

        final originalDoc = FirestoreDocument(
          path: originalPath,
          fieldSet: originalFields.toFireSet(),
        );

        // Act
        final copiedDoc = originalDoc.copyWith(
          path: newPath,
          fieldSet: newFields.toFireSet(),
        );

        // Assert
        expect(copiedDoc.id, 'new');
        expect(originalDoc.id, 'original');
        expect(copiedDoc.fields.length, 2);
        expect(originalDoc.fields.length, 1);
      });
    });

    // Nested data operations
    group('Nested data operations', () {
      test('complex nested objects can be written and read correctly',
          () async {
        // Arrange
        final docPath = FirefastStore.col('users').doc('complexUser');

        // Create fields with nested data
        final profileField = FireField<Map<String, dynamic>>(
          name: 'profile',
          toFire: () async => {
            'name': 'Complex User',
            'contact': {'email': 'complex@example.com', 'phone': '1234567890'}
          },
          fromFire: (dynamic value) => value as Map<String, dynamic>,
        );

        final settingsField = FireField<Map<String, dynamic>>(
          name: 'settings',
          toFire: () async => {
            'theme': 'dark',
            'notifications': {'email': true, 'push': false}
          },
          fromFire: (dynamic value) => value as Map<String, dynamic>,
        );

        final doc = FirestoreDocument(
          path: docPath,
          fieldSet: [profileField, settingsField].toFireSet(),
        );

        // Act
        await doc.write();
        final output = await doc.read();

        // Assert
        expect(output, isNotNull);
        final profile = output!.getValue<Map<String, dynamic>>('profile');
        final settings = output.getValue<Map<String, dynamic>>('settings');

        expect(profile?['name'], 'Complex User');
        expect(profile?['contact']['email'], 'complex@example.com');
        expect(settings?['theme'], 'dark');
        expect(settings?['notifications']['push'], false);
      });
    });

    // Data type tests
    group('Data types', () {
      test('handles various data types correctly', () async {
        // Arrange
        final docPath = FirefastStore.col('types').doc('typeTest');
        final date = DateTime.now();

        final doc = FirestoreDocument(
          path: docPath,
          fieldSet: [
            // String type
            FireField<String>(
              name: 'string',
              toFire: () async => 'text',
              fromFire: (dynamic value) => value.toString(),
            ),

            // Number (int) type
            FireField<int>(
              name: 'number',
              toFire: () async => 123,
              fromFire: (dynamic value) => value as int,
            ),

            // Double type
            FireField<double>(
              name: 'double',
              toFire: () async => 123.45,
              fromFire: (dynamic value) => value as double,
            ),

            // Boolean type
            FireField<bool>(
              name: 'boolean',
              toFire: () async => true,
              fromFire: (dynamic value) => value as bool,
            ),

            // Nullable field
            FireField<String?>(
              name: 'null',
              toFire: () async => null,
              fromFire: (dynamic value) => value?.toString(),
            ),

            // DateTime field
            FireField<Timestamp>(
              name: 'timestamp',
              toFire: () async => date,
              fromFire: (dynamic value) => value as Timestamp,
            ),

            // Array/List field
            FireField<List<dynamic>>(
              name: 'array',
              toFire: () async => [1, 2, 3, 'string', true],
              fromFire: (dynamic value) => value as List<dynamic>,
            ),

            // Map field
            FireField<Map<String, dynamic>>(
              name: 'map',
              toFire: () async => {'key': 'value'},
              fromFire: (dynamic value) => value as Map<String, dynamic>,
            ),
          ].toFireSet(),
        );

        // Act
        await doc.write();
        final output = await doc.read();

        // Assert
        expect(output!.getValue<String>('string'), 'text');
        expect(output.getValue<int>('number'), 123);
        expect(output.getValue<double>('double'), 123.45);
        expect(output.getValue<bool>('boolean'), true);
        expect(output.getValue<String>('null'), null);
        expect(output.getValue<Timestamp>('timestamp'), isNotNull);
        expect(
            output.getValue<List<dynamic>>('array'), [1, 2, 3, 'string', true]);
        expect(output.getValue<Map<String, dynamic>>('map'), {'key': 'value'});
      });
    });

    // Edge cases
    group('Edge cases', () {
      test('handles document with special characters in path', () async {
        // Arrange
        final docPath = FirefastStore.col('collection with spaces')
            .doc('document-with-dashes_and_underscores');

        final doc = FirestoreDocument(
          path: docPath,
          fieldSet: [
            FireField<String>(
              name: 'field',
              toFire: () async => 'value',
              fromFire: (dynamic value) => value.toString(),
            ),
          ].toFireSet(),
        );

        // Act
        await doc.write();
        final output = await doc.read();

        // Assert
        expect(output, isNotNull);
        expect(output!.getValue<String>('field'), 'value');
      });

      test('handles document with no fields', () async {
        // Arrange
        final docPath = FirefastStore.col('empty').doc('noFields');
        final doc = FirestoreDocument(
          path: docPath,
          fieldSet: List<FireField>.empty().toFireSet(),
        );

        // Act
        await doc.write();
        final output = await doc.read();
        final rawData = await FirefastStore.instance.read(docPath.path);

        // Assert
        expect(output, isNull);
        expect(rawData, {});
      });

      test('handles document with fields containing empty values', () async {
        // Arrange
        final docPath = FirefastStore.col('empty').doc('emptyValues');
        final doc = FirestoreDocument(
          path: docPath,
          fieldSet: [
            FireField<String>(
              name: 'emptyString',
              toFire: () async => '',
              fromFire: (dynamic value) => value.toString(),
            ),
            FireField<List<dynamic>>(
              name: 'emptyArray',
              toFire: () async => [],
              fromFire: (dynamic value) => value as List<dynamic>,
            ),
            FireField<Map<String, dynamic>>(
              name: 'emptyMap',
              toFire: () async => {},
              fromFire: (dynamic value) =>
                  (value as Map).map((k, v) => MapEntry(k as String, v)),
            ),
          ].toFireSet(),
        );

        // Act
        await doc.write();
        final output = await doc.read();

        // Assert
        expect(output, isNotNull);
        expect(output!.getValue<String>('emptyString'), '');
        expect(output.getValue<List<dynamic>>('emptyArray'), isEmpty);
        expect(output.getValue<Map<String, dynamic>>('emptyMap'), isEmpty);
      });
    });

    // Sequential operations
    group('Sequential operations', () {
      test('document updated with new fields', () async {
        // Arrange
        final docPath = FirefastStore.col('sequential').doc('updateFields');

        // Initial document
        final initialDoc = FirestoreDocument(
          path: docPath,
          fieldSet: [
            FireField<String>(
              name: 'status',
              toFire: () async => 'created',
              fromFire: (dynamic value) => value.toString(),
            ),
          ].toFireSet(),
        );

        // Updated document with additional field
        final updatedDoc = FirestoreDocument(
          path: docPath,
          fieldSet: [
            FireField<String>(
              name: 'status',
              toFire: () async => 'updated',
              fromFire: (dynamic value) => value.toString(),
            ),
            FireField<int>(
              name: 'count',
              toFire: () async => 1,
              fromFire: (dynamic value) => value as int,
            ),
          ].toFireSet(),
        );

        // Act
        await initialDoc.write();
        final initialOutput = await initialDoc.read();

        await updatedDoc.write();
        final updatedOutput = await updatedDoc.read();

        // Assert
        expect(initialOutput!.getValue<String>('status'), 'created');
        expect(updatedOutput!.getValue<String>('status'), 'updated');
        expect(updatedOutput.getValue<int>('count'), 1);
      });

      test('document lifecycle (create, update, delete)', () async {
        // Arrange
        final docPath = FirefastStore.col('lifecycle').doc('fullCycle');

        // Create initial document
        final createDoc = FirestoreDocument(
          path: docPath,
          fieldSet: [
            FireField<String>(
              name: 'status',
              toFire: () async => 'created',
              fromFire: (dynamic value) => value.toString(),
            ),
          ].toFireSet(),
        );

        // Update document
        final updateDoc = FirestoreDocument(
          path: docPath,
          fieldSet: [
            FireField<String>(
              name: 'status',
              toFire: () async => 'updated',
              fromFire: (dynamic value) => value.toString(),
            ),
          ].toFireSet(),
        );

        // Act & Assert - Create
        await createDoc.write();
        var output = await createDoc.read();
        expect(output, isNotNull);
        expect(output!.getValue<String>('status'), 'created');

        // Act & Assert - Update
        await updateDoc.write();
        output = await updateDoc.read();
        expect(output, isNotNull);
        expect(output!.getValue<String>('status'), 'updated');

        // Act & Assert - Delete
        await updateDoc.delete();
        output = await updateDoc.read();
        expect(output, isNull);
      });
    });

    // Collection operations
    group('Collection operations', () {
      test('multiple documents in same collection', () async {
        // Arrange
        final col = FirefastStore.col('users');
        final doc1 = FirestoreDocument(
          path: col.doc('user1'),
          fieldSet: [
            FireField<String>(
              name: 'name',
              toFire: () async => 'User 1',
              fromFire: (dynamic value) => value.toString(),
            ),
          ].toFireSet(),
        );

        final doc2 = FirestoreDocument(
          path: col.doc('user2'),
          fieldSet: [
            FireField<String>(
              name: 'name',
              toFire: () async => 'User 2',
              fromFire: (dynamic value) => value.toString(),
            ),
          ].toFireSet(),
        );

        // Act
        await doc1.write();
        await doc2.write();

        final output1 = await doc1.read();
        final output2 = await doc2.read();

        // Assert
        expect(output1!.getValue<String>('name'), 'User 1');
        expect(output2!.getValue<String>('name'), 'User 2');
      });
    });

    // Stress test
    group('Stress tests', () {
      test('document with many fields', () async {
        // Arrange
        final docPath = FirefastStore.col('stress').doc('manyFields');
        final fieldCount = 20;

        final fields = <FireField>[];
        for (int i = 0; i < fieldCount; i++) {
          fields.add(
            FireField<int>(
              name: 'field$i',
              toFire: () async => i,
              fromFire: (dynamic value) => value as int,
            ),
          );
        }

        final doc = FirestoreDocument(
          path: docPath,
          fieldSet: fields.toFireSet(),
        );

        // Act
        await doc.write();
        final output = await doc.read();

        // Assert
        for (int i = 0; i < fieldCount; i++) {
          expect(output!.getValue<int>('field$i'), i);
        }
      });
    });
  });
}
