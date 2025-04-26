import 'package:flutter_test/flutter_test.dart';
import 'package:firefast/firefast_core.dart';

void main() {
  group('FireValueGuard', () {
    group('with async validator', () {
      test('hasValidation returns true when isValid is provided', () {
        final guard = FireValueGuard<String>((value) async => true);
        expect(guard.hasValidation, true);
      });

      test('hasValidation returns false when isValid is null', () {
        const guard = FireValueGuard<String>(null);
        expect(guard.hasValidation, false);
      });

      test('isValueValid returns the result of the validation function',
          () async {
        final alwaysValidGuard = FireValueGuard<String>((value) async => true);
        final alwaysInvalidGuard =
            FireValueGuard<String>((value) async => false);

        expect(await alwaysValidGuard.isValueValid('test'), true);
        expect(await alwaysInvalidGuard.isValueValid('test'), false);
      });

      test('isValueValid returns true when isValid is null', () async {
        const guard = FireValueGuard<String>(null);
        expect(await guard.isValueValid('test'), true);
      });

      test('isValueValid passes the correct value to validation function',
          () async {
        String? capturedValue;
        final guard = FireValueGuard<String>((value) async {
          capturedValue = value;
          return true;
        });

        await guard.isValueValid('test');
        expect(capturedValue, 'test');

        await guard.isValueValid(null);
        expect(capturedValue, null);
      });
    });

    group('FireValueGuard.sync constructor', () {
      test('creates a guard with a sync validator converted to async',
          () async {
        bool validatorCalled = false;
        final guard = FireValueGuard<String>.sync((value) {
          validatorCalled = true;
          return value?.isNotEmpty ?? false;
        });

        expect(guard.hasValidation, true);

        expect(await guard.isValueValid('test'), true);
        expect(validatorCalled, true);

        validatorCalled = false;
        expect(await guard.isValueValid(''), false);
        expect(validatorCalled, true);

        validatorCalled = false;
        expect(await guard.isValueValid(null), false);
        expect(validatorCalled, true);
      });
    });

    group('with complex validation logic', () {
      test('validates email format', () async {
        final emailGuard = FireValueGuard<String>.sync((value) {
          if (value == null) return false;
          return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value);
        });

        expect(await emailGuard.isValueValid('test@example.com'), true);
        expect(await emailGuard.isValueValid('invalid-email'), false);
        expect(await emailGuard.isValueValid(null), false);
      });

      test('validates string length', () async {
        final minLengthGuard = FireValueGuard<String>.sync((value) {
          return value != null && value.length >= 5;
        });

        expect(await minLengthGuard.isValueValid('12345'), true);
        expect(await minLengthGuard.isValueValid('1234'), false);
        expect(await minLengthGuard.isValueValid(null), false);
      });
    });
  });
}
