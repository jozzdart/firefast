import 'package:firefast/firefast_core.dart';
import 'package:test/test.dart';

// Define a custom path segment subclass
class UserPath extends PathSegment {
  final String userId;

  const UserPath(this.userId) : super('users');

  // A method to create a document path for this user
  PathSegment document(String docType) => child(userId).child(docType);
}

void main() {
  group('PathSegment', () {
    test('constructor initializes properties correctly', () {
      const segment = 'users';
      final pathSegment = PathSegment(segment);

      expect(pathSegment.segment, equals(segment));
      expect(pathSegment.parent, isNull);
    });

    test('constructor with parent initializes correctly', () {
      final parent = PathSegment('collections');
      final child = PathSegment('documents', parent: parent);

      expect(child.segment, equals('documents'));
      expect(child.parent, equals(parent));
    });

    test('path returns correct string for single segment', () {
      final segment = PathSegment('users');

      expect(segment.path, equals('users'));
    });

    test('path returns correct string for nested segments', () {
      final root = PathSegment('root');
      final level1 = PathSegment('level1', parent: root);
      final level2 = PathSegment('level2', parent: level1);

      expect(root.path, equals('root'));
      expect(level1.path, equals('root/level1'));
      expect(level2.path, equals('root/level1/level2'));
    });

    test('toString returns path string', () {
      final root = PathSegment('database');
      final collections = PathSegment('collections', parent: root);

      expect(root.toString(), equals('database'));
      expect(collections.toString(), equals('database/collections'));
    });

    test('child method creates correct child segment', () {
      final parent = PathSegment('users');
      final child = parent.child('profiles');

      expect(child.segment, equals('profiles'));
      expect(child.parent, equals(parent));
      expect(child.path, equals('users/profiles'));
    });

    test('nested child method creates correct hierarchy', () {
      final root = PathSegment('root');
      final child1 = root.child('child1');
      final child2 = child1.child('child2');
      final child3 = child2.child('child3');

      expect(child3.segment, equals('child3'));
      expect(child3.parent, equals(child2));
      expect(child3.parent?.parent, equals(child1));
      expect(child3.parent?.parent?.parent, equals(root));
      expect(child3.path, equals('root/child1/child2/child3'));
    });

    test('works with empty segment strings', () {
      final emptySegment = PathSegment('');
      final child = emptySegment.child('child');

      expect(emptySegment.segment, equals(''));
      expect(emptySegment.path, equals(''));
      expect(child.path, equals('/child'));
    });

    test('works with special characters in segments', () {
      final specialChars = PathSegment('user@example.com');
      final child = specialChars.child('data#123');

      expect(specialChars.segment, equals('user@example.com'));
      expect(child.segment, equals('data#123'));
      expect(child.path, equals('user@example.com/data#123'));
    });

    test('works with very long paths', () {
      // Create a deep nesting of segments
      PathSegment current = PathSegment('level0');

      for (var i = 1; i <= 10; i++) {
        current = PathSegment('level$i', parent: current);
      }

      // Check the final path
      final expectedPath =
          'level0/level1/level2/level3/level4/level5/level6/level7/level8/level9/level10';
      expect(current.path, equals(expectedPath));
    });

    test(
        'different constructed segments with same path are still separate objects',
        () {
      final path1 = PathSegment('a').child('b').child('c');

      final rootA = PathSegment('a');
      final pathB = PathSegment('b', parent: rootA);
      final path2 = PathSegment('c', parent: pathB);

      // They should have the same string representation
      expect(path1.path, equals(path2.path));

      // But they are different objects
      expect(identical(path1, path2), isFalse);
    });

    test('custom path segment subclass works correctly', () {
      final userPath = UserPath('user123');
      final profilePath = userPath.document('profile');

      expect(userPath.segment, equals('users'));
      expect(userPath.userId, equals('user123'));
      expect(profilePath.path, equals('users/user123/profile'));
    });
  });
}
