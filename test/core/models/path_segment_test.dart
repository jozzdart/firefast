import 'package:firefast/firefast_core.dart';
import 'package:test/test.dart';

// Define a concrete subclass for testing the generic child method
class TestPathSegment extends PathSegment {
  const TestPathSegment(super.segment, {super.parent});
}

void main() {
  group('PathSegment', () {
    test('should correctly initialize with a single segment', () {
      const segment = 'users';
      const pathSegment = PathSegment(segment);

      expect(pathSegment.segment, equals(segment));
      expect(pathSegment.path, equals(segment));
      expect(pathSegment.parent, isNull);
    });

    test('should correctly initialize with a parent segment', () {
      const parentSegmentStr = 'users';
      const childSegmentStr = 'userId123';
      const parentSegment = PathSegment(parentSegmentStr);
      final childSegment = PathSegment(childSegmentStr, parent: parentSegment);

      expect(childSegment.segment, equals(childSegmentStr));
      expect(childSegment.path, equals('$parentSegmentStr/$childSegmentStr'));
      expect(childSegment.parent, equals(parentSegment));
    });

    test('child() should create a child segment with the correct path', () {
      const parentSegmentStr = 'posts';
      const childSegmentStr = 'postId456';
      const parentSegment = PathSegment(parentSegmentStr);
      final childSegment = parentSegment.child(childSegmentStr);

      expect(childSegment, isA<PathSegment>());
      expect(childSegment.segment, equals(childSegmentStr));
      expect(childSegment.path, equals('$parentSegmentStr/$childSegmentStr'));
      expect(childSegment.parent, equals(parentSegment));
    });

    test('child() should handle multiple levels of nesting correctly', () {
      const rootSegmentStr = 'data';
      const level1SegmentStr = 'items';
      const level2SegmentStr = 'itemId789';
      const level3SegmentStr = 'details';

      const rootSegment = PathSegment(rootSegmentStr);
      final level1Segment = rootSegment.child(level1SegmentStr);
      final level2Segment = level1Segment.child(level2SegmentStr);
      final level3Segment = level2Segment.child(level3SegmentStr);

      expect(level3Segment, isA<PathSegment>());
      expect(level3Segment.segment, equals(level3SegmentStr));
      expect(
          level3Segment.path,
          equals(
              '$rootSegmentStr/$level1SegmentStr/$level2SegmentStr/$level3SegmentStr'));
      expect(level3Segment.parent, equals(level2Segment));
      expect(level3Segment.parent?.parent, equals(level1Segment));
      expect(level3Segment.parent?.parent?.parent, equals(rootSegment));
      expect(level3Segment.parent?.parent?.parent?.parent, isNull);
    });

    test('path should return only the segment name when parent is null', () {
      const segment = 'config';
      const pathSegment = PathSegment(segment);
      expect(pathSegment.path, equals(segment));
    });
  });
}
