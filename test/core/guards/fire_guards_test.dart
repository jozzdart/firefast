import 'package:flutter_test/flutter_test.dart';
import 'package:firefast/firefast_core.dart';

class TestOperationGuard extends OperationGuard {
  final bool returnValue;

  const TestOperationGuard(this.returnValue);

  @override
  Future<bool> canPerform() async => returnValue;
}

void main() {
  group('FireGuards', () {
    test('creates with empty lists by default', () {
      const guards = FireGuards();

      expect(guards.read, isEmpty);
      expect(guards.write, isEmpty);
      expect(guards.overwrite, isEmpty);
      expect(guards.delete, isEmpty);
    });

    test('initializes with provided guard lists', () {
      final readGuard = TestOperationGuard(true);
      final writeGuard = TestOperationGuard(false);
      final overwriteGuard = TestOperationGuard(true);
      final deleteGuard = TestOperationGuard(false);

      final guards = FireGuards(
        read: [readGuard],
        write: [writeGuard],
        overwrite: [overwriteGuard],
        delete: [deleteGuard],
      );

      expect(guards.read, hasLength(1));
      expect(guards.read.first, same(readGuard));

      expect(guards.write, hasLength(1));
      expect(guards.write.first, same(writeGuard));

      expect(guards.overwrite, hasLength(1));
      expect(guards.overwrite.first, same(overwriteGuard));

      expect(guards.delete, hasLength(1));
      expect(guards.delete.first, same(deleteGuard));
    });

    test('maintains multiple guards in the correct order', () {
      final guard1 = TestOperationGuard(true);
      final guard2 = TestOperationGuard(false);
      final guard3 = TestOperationGuard(true);

      final guards = FireGuards(
        read: [guard1, guard2, guard3],
      );

      expect(guards.read, hasLength(3));
      expect(guards.read[0], same(guard1));
      expect(guards.read[1], same(guard2));
      expect(guards.read[2], same(guard3));
    });

    test('accepts const instances', () {
      const guard1 = TestOperationGuard(true);
      const guard2 = TestOperationGuard(false);

      const guards = FireGuards(
        read: [guard1, guard2],
      );

      expect(identical(guards.read[0], guard1), true);
      expect(identical(guards.read[1], guard2), true);
    });

    test('different operation types can have different guards', () {
      const readGuard = TestOperationGuard(true);
      const writeGuard = TestOperationGuard(false);

      const guards = FireGuards(
        read: [readGuard],
        write: [writeGuard],
      );

      expect(guards.read, isNot(guards.write));
      expect(guards.read, contains(readGuard));
      expect(guards.write, contains(writeGuard));
      expect(guards.read, isNot(contains(writeGuard)));
      expect(guards.write, isNot(contains(readGuard)));
    });
  });
}
