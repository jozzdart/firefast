import 'package:firefast/firefast_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firefast/firefast_core.dart';
import 'firestore_test_utils.dart';

void main() {
  group('Firestore Path Operations Tests', () {
    setUp(() {
      FirestoreTestUtils.setUpFireTests();
    });

    tearDown(() {
      FirestoreTestUtils.clearServices();
    });

    group('Basic path operations', () {
      test('col() should create a FirestoreCollectionPath with correct path',
          () {
        // Act
        final collectionPath = FirefastStore.col('users');

        // Assert
        expect(collectionPath, isA<FirestoreCollectionPath>());
        expect(collectionPath.path, equals('users'));
        expect(collectionPath.segment, equals('users'));
        expect(collectionPath.parent, isNull);
      });

      test('doc() should create a FirestoreDocumentPath with correct path', () {
        // Act
        final docPath = FirefastStore.col('users').doc('user123');

        // Assert
        expect(docPath, isA<FirestoreDocumentPath>());
        expect(docPath.path, equals('users/user123'));
        expect(docPath.segment, equals('user123'));
        expect(docPath.parent, isA<FirestoreCollectionPath>());
        expect(docPath.parent?.path, equals('users'));
      });
    });

    group('Nested path operations', () {
      test('col().doc().col() should create nested paths correctly', () {
        // Act
        final collectionPath =
            FirefastStore.col('users').doc('user123').col('posts');

        // Assert
        expect(collectionPath, isA<FirestoreCollectionPath>());
        expect(collectionPath.path, equals('users/user123/posts'));
        expect(collectionPath.segment, equals('posts'));
        expect(collectionPath.parent, isA<FirestoreDocumentPath>());
        expect(collectionPath.parent?.path, equals('users/user123'));
      });

      test(
          'col().doc().col().doc() should create deeply nested paths correctly',
          () {
        // Act
        final docPath = FirefastStore.col('users')
            .doc('user123')
            .col('posts')
            .doc('post456');

        // Assert
        expect(docPath, isA<FirestoreDocumentPath>());
        expect(docPath.path, equals('users/user123/posts/post456'));
        expect(docPath.segment, equals('post456'));
        expect(docPath.parent, isA<FirestoreCollectionPath>());
        expect(docPath.parent?.path, equals('users/user123/posts'));
        expect(docPath.parent?.parent, isA<FirestoreDocumentPath>());
        expect(docPath.parent?.parent?.path, equals('users/user123'));
        expect(docPath.parent?.parent?.parent, isA<FirestoreCollectionPath>());
        expect(docPath.parent?.parent?.parent?.path, equals('users'));
      });

      test('multiple levels of nesting should maintain correct hierarchy', () {
        // Act
        final deepPath = FirefastStore.col('users')
            .doc('user123')
            .col('posts')
            .doc('post456')
            .col('comments')
            .doc('comment789')
            .col('likes')
            .doc('like101112');

        // Assert
        expect(deepPath, isA<FirestoreDocumentPath>());
        expect(
            deepPath.path,
            equals(
                'users/user123/posts/post456/comments/comment789/likes/like101112'));

        // Check each level of the hierarchy
        var currentSegment = deepPath as PathSegment;
        var expectedSegments = [
          'like101112',
          'likes',
          'comment789',
          'comments',
          'post456',
          'posts',
          'user123',
          'users'
        ];
        var expectedTypes = [
          FirestoreDocumentPath,
          FirestoreCollectionPath,
          FirestoreDocumentPath,
          FirestoreCollectionPath,
          FirestoreDocumentPath,
          FirestoreCollectionPath,
          FirestoreDocumentPath,
          FirestoreCollectionPath
        ];

        for (int i = 0; i < expectedSegments.length; i++) {
          expect(currentSegment.segment, equals(expectedSegments[i]));
          expect(currentSegment.runtimeType, expectedTypes[i]);

          if (i < expectedSegments.length - 1) {
            currentSegment = currentSegment.parent!;
          }
        }

        // The last parent should be null
        expect(currentSegment.parent, isNull);
      });
    });

    group('Document path sub() method', () {
      test('sub() should create a nested document path', () {
        // Act
        final docPath = FirefastStore.col('users').doc('user123');
        final subDocPath = docPath.sub('posts', 'post456');

        // Assert
        expect(subDocPath, isA<FirestoreDocumentPath>());
        expect(subDocPath.path, equals('users/user123/posts/post456'));
        expect(subDocPath.segment, equals('post456'));
        expect(subDocPath.parent, isA<FirestoreCollectionPath>());
        expect(subDocPath.parent?.segment, equals('posts'));
      });

      test('sub() should be equivalent to col().doc()', () {
        // Act
        final docPath = FirefastStore.col('users').doc('user123');
        final subPath = docPath.sub('posts', 'post456');
        final colDocPath = docPath.col('posts').doc('post456');

        // Assert
        expect(subPath.path, equals(colDocPath.path));
        expect(subPath.segment, equals(colDocPath.segment));
        expect(subPath.parent?.segment, equals(colDocPath.parent?.segment));
      });

      test('sub() can be chained for deep nesting', () {
        // Act
        final docPath = FirefastStore.col('users').doc('user123');
        final deepSubPath =
            docPath.sub('posts', 'post456').sub('comments', 'comment789');

        // Assert
        expect(deepSubPath, isA<FirestoreDocumentPath>());
        expect(deepSubPath.path,
            equals('users/user123/posts/post456/comments/comment789'));

        // Check intermediate parent paths
        expect(deepSubPath.parent?.path,
            equals('users/user123/posts/post456/comments'));
        expect(deepSubPath.parent?.parent?.path,
            equals('users/user123/posts/post456'));
        expect(deepSubPath.parent?.parent?.parent?.path,
            equals('users/user123/posts'));
        expect(deepSubPath.parent?.parent?.parent?.parent?.path,
            equals('users/user123'));
      });
    });

    group('Path operations with actual document operations', () {
      test('should correctly write and read with nested paths', () async {
        // Arrange
        final userDocPath = FirefastStore.col('users').doc('user123');
        final postDocPath = userDocPath.col('posts').doc('post456');

        final userData = {'name': 'Test User', 'email': 'test@example.com'};
        final postData = {'title': 'Test Post', 'content': 'Post content'};

        // Act - Write data to nested paths
        await FirefastStore.instance.write(userDocPath.path, userData);
        await FirefastStore.instance.write(postDocPath.path, postData);

        // Read data from nested paths
        final retrievedUserData =
            await FirefastStore.instance.read(userDocPath.path);
        final retrievedPostData =
            await FirefastStore.instance.read(postDocPath.path);

        // Assert
        expect(retrievedUserData, equals(userData));
        expect(retrievedPostData, equals(postData));
      });

      test('can get to the same document through different path methods',
          () async {
        // Arrange - Create same path in different ways
        final path1 = FirefastStore.col('users')
            .doc('user123')
            .col('posts')
            .doc('post456');
        final path2 =
            FirefastStore.col('users').doc('user123').sub('posts', 'post456');

        final testData = {'test': 'data'};

        // Act
        await FirefastStore.instance.write(path1.path, testData);
        final result = await FirefastStore.instance.read(path2.path);

        // Assert
        expect(result, equals(testData));
        expect(path1.path, equals(path2.path));
      });
    });
  });
}
