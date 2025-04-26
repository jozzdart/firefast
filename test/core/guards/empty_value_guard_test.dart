import 'package:flutter_test/flutter_test.dart';
import 'package:firefast/firefast_core.dart';

void main() {
  group('EmptyValueGuard', () {
    late EmptyValueGuard<String> guard;

    setUp(() {
      guard = const EmptyValueGuard<String>();
    });

    test('hasValidation should always return false', () {
      expect(guard.hasValidation, false);
    });

    test('isValueValid should always return true regardless of the value',
        () async {
      expect(await guard.isValueValid('test'), true);
      expect(await guard.isValueValid(''), true);
      expect(await guard.isValueValid(null), true);
    });

    test('isValueValid should always return true for different types',
        () async {
      const intGuard = EmptyValueGuard<int>();
      const boolGuard = EmptyValueGuard<bool>();
      const objectGuard = EmptyValueGuard<Object>();

      expect(await intGuard.isValueValid(42), true);
      expect(await intGuard.isValueValid(null), true);

      expect(await boolGuard.isValueValid(true), true);
      expect(await boolGuard.isValueValid(false), true);
      expect(await boolGuard.isValueValid(null), true);

      expect(await objectGuard.isValueValid(Object()), true);
      expect(await objectGuard.isValueValid(null), true);
    });
  });
}
