import 'package:firefast/firefast_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockFireField extends Mock implements FireField {}

class MockPathSegment extends Mock implements PathSegment {}

void main() {
  group('FireFieldCoreExtensions', () {
    late List<FireField> fields;

    setUp(() {
      fields = [
        MockFireField(),
        MockFireField(),
        MockFireField(),
      ];
    });

    test('toFireSet() should create a FireFieldSet with the correct fields',
        () {
      // Act
      final result = fields.toFireSet();

      // Assert
      expect(result, isA<FireFieldSet>());
      expect(result.fields, equals(fields));
      expect(result.fields.length, equals(3));
    });

    test('toFireSet() should create an empty FireFieldSet when list is empty',
        () {
      // Arrange
      fields = [];

      // Act
      final result = fields.toFireSet();

      // Assert
      expect(result, isA<FireFieldSet>());
      expect(result.fields, isEmpty);
      expect(result.fields.length, equals(0));
    });

    test('toFireSet() should handle list with a single FireField element', () {
      // Arrange
      final singleField = MockFireField();
      fields = [singleField];

      // Act
      final result = fields.toFireSet();

      // Assert
      expect(result, isA<FireFieldSet>());
      expect(result.fields, equals(fields));
      expect(result.fields.length, equals(1));
      expect(result.fields.first, equals(singleField));
    });

    test('toFireSet() should preserve ordering of fields', () {
      // Arrange
      final field1 = MockFireField();
      final field2 = MockFireField();
      final field3 = MockFireField();

      fields = [field1, field2, field3];

      // Act
      final result = fields.toFireSet();

      // Assert
      expect(result.fields[0], equals(field1));
      expect(result.fields[1], equals(field2));
      expect(result.fields[2], equals(field3));
    });
  });
}
