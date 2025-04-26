import 'package:firefast/firefast_core.dart';
import 'package:test/test.dart';

void main() {
  group('PathSegment', () {
    test('should initialize with a segment string', () {
      final segment = PathSegment('users');
      expect(segment.segment, equals('users'));
      expect(segment.path, equals('users'));
      expect(segment.parent, isNull);
    });

    test('should initialize with a parent segment', () {
      final parent = PathSegment('users');
      final segment = PathSegment('123', parent: parent);
      expect(segment.segment, equals('123'));
      expect(segment.parent, equals(parent));
    });

    test('should build full path including parent segments', () {
      final root = PathSegment('root');
      final level1 = PathSegment('level1', parent: root);
      final level2 = PathSegment('level2', parent: level1);
      final level3 = PathSegment('level3', parent: level2);

      expect(root.path, equals('root'));
      expect(level1.path, equals('root/level1'));
      expect(level2.path, equals('root/level1/level2'));
      expect(level3.path, equals('root/level1/level2/level3'));
    });

    test('should create child segments properly', () {
      final users = PathSegment('users');
      final userId = users.child('123');
      final profile = userId.child('profile');

      expect(userId.segment, equals('123'));
      expect(userId.parent, equals(users));
      expect(userId.path, equals('users/123'));

      expect(profile.segment, equals('profile'));
      expect(profile.parent, equals(userId));
      expect(profile.path, equals('users/123/profile'));
    });

    test('toString should return the full path', () {
      final users = PathSegment('users');
      final userId = users.child('123');

      expect(users.toString(), equals('users'));
      expect(userId.toString(), equals('users/123'));
    });

    test('should handle special characters in path segments', () {
      final segment = PathSegment('path#with.special@chars');
      expect(segment.path, equals('path#with.special@chars'));

      final parent = PathSegment('parent');
      final child = PathSegment('child?with&special=chars', parent: parent);
      expect(child.path, equals('parent/child?with&special=chars'));
    });

    test('should handle empty segment strings', () {
      final segment = PathSegment('');
      expect(segment.segment, equals(''));
      expect(segment.path, equals(''));

      final parent = PathSegment('parent');
      final child = PathSegment('', parent: parent);
      expect(child.path, equals('parent/'));
    });
  });
}
