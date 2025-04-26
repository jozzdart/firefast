import 'package:test/test.dart';
import 'package:firefast/firefast_core.dart';

class TestFirePortOperation<T> extends FirePortOperation<T> {
  const TestFirePortOperation({
    super.validationGuard,
    super.allowOperationGuard,
  });
}

// Custom guard that accepts any type
class TestEmptyGuard<T> extends BaseValueGuard<T> {
  @override
  bool get hasValidation => false;

  @override
  Future<bool> isValueValid(T? value) async => true;

  const TestEmptyGuard();
}

void main() {
  group('FirePortOperation', () {
    group('hasValidation', () {
      test('should return false for empty guard', () {
        final operation = TestFirePortOperation<String>();
        expect(operation.hasValidation, isFalse);
      });

      test('should return true for guard with validation', () {
        final validationGuard =
            FireValueGuard.sync((String? value) => value != null);
        final operation = TestFirePortOperation<String>(
          validationGuard: validationGuard,
        );
        expect(operation.hasValidation, isTrue);
      });
    });

    group('mayBlockOperation', () {
      test('should return false for empty guard', () {
        final operation = TestFirePortOperation<String>();
        expect(operation.mayBlockOperation, isFalse);
      });

      test('should return true for guard with validation', () {
        final allowOperationGuard =
            FireValueGuard.sync((String? value) => value != null);
        final operation = TestFirePortOperation<String>(
          allowOperationGuard: allowOperationGuard,
        );
        expect(operation.mayBlockOperation, isTrue);
      });
    });

    group('isValid', () {
      test('should call validationGuard.isValueValid', () async {
        final validationGuard =
            FireValueGuard.sync((String? value) => value == 'valid');
        final operation = TestFirePortOperation<String>(
          validationGuard: validationGuard,
        );

        expect(await operation.isValid('valid'), isTrue);
        expect(await operation.isValid('invalid'), isFalse);
        expect(await operation.isValid(null), isFalse);
      });

      test('should return true with empty guard', () async {
        // Use our custom test empty guard that works with any type
        final operation = TestFirePortOperation<String>(
          validationGuard: const TestEmptyGuard<String>(),
        );
        expect(await operation.isValid('any value'), isTrue);
        expect(await operation.isValid(null), isTrue);
      });
    });

    group('allowsOperation', () {
      test('should call allowOperationGuard.isValueValid', () async {
        final allowOperationGuard =
            FireValueGuard.sync((String? value) => value != 'blocked');
        final operation = TestFirePortOperation<String>(
          allowOperationGuard: allowOperationGuard,
        );

        expect(await operation.allowsOperation('allowed'), isTrue);
        expect(await operation.allowsOperation('blocked'), isFalse);
      });

      test('should return true with empty guard', () async {
        // Use our custom test empty guard that works with any type
        final operation = TestFirePortOperation<String>(
          allowOperationGuard: const TestEmptyGuard<String>(),
        );
        expect(await operation.allowsOperation('any value'), isTrue);
        expect(await operation.allowsOperation(null), isTrue);
      });
    });

    group('with both guards', () {
      test('should validate independently', () async {
        final validationGuard =
            FireValueGuard.sync((int? value) => value != null && value > 0);
        final allowOperationGuard =
            FireValueGuard.sync((int? value) => value != null && value < 100);

        final operation = TestFirePortOperation<int>(
          validationGuard: validationGuard,
          allowOperationGuard: allowOperationGuard,
        );

        // Value is valid and operation is allowed
        expect(await operation.isValid(50), isTrue);
        expect(await operation.allowsOperation(50), isTrue);

        // Value is valid but operation is not allowed
        expect(await operation.isValid(150), isTrue);
        expect(await operation.allowsOperation(150), isFalse);

        // Value is not valid but operation should still be checkable
        // Since -10 < 100, it would pass the allowOperation check in isolation
        expect(await operation.isValid(-10), isFalse);
        expect(await operation.allowsOperation(-10), isTrue);

        // Both invalid
        expect(await operation.isValid(null), isFalse);
        expect(await operation.allowsOperation(null), isFalse);
      });
    });
  });
}
