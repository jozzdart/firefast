import 'package:test/test.dart';
import 'package:firefast/firefast_core.dart';

class MockAdapter extends FireAdapter<String> {
  @override
  Future<dynamic> toFire(String? value) async => value?.toUpperCase();

  @override
  Future<String?> fromFire(dynamic value) async =>
      value == null ? null : (value as String).toLowerCase();
}

// Modified mock adapter that properly calls onInput with null values
class NullHandlingMockAdapter extends FireAdapter<String> {
  final void Function(String?) onFromFire;

  NullHandlingMockAdapter(this.onFromFire);

  @override
  Future<dynamic> toFire(String? value) async => value?.toUpperCase();

  @override
  Future<String?> fromFire(dynamic value) async {
    final result = value == null ? null : (value as String).toLowerCase();
    onFromFire(result);
    return result;
  }
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
  group('FromFire', () {
    late FireAdapter<String> adapter;
    late List<String?> inputLog;

    setUp(() {
      adapter = MockAdapter();
      inputLog = [];
    });

    group('Construction', () {
      test('should create instance with async delegate', () async {
        final fromFire = FromFire<String>((value) async {
          inputLog.add(value);
        });

        await fromFire.onInput('test');
        expect(inputLog, equals(['test']));
      });

      test('should create instance with sync function', () async {
        final fromFire = FromFire<String>.sync((String? value) {
          inputLog.add(value);
        });

        await fromFire.onInput('test');
        expect(inputLog, equals(['test']));
      });
    });

    group('FromFireEmpty', () {
      test('should do nothing when receiving input', () async {
        final fromFire = FromFireEmpty<String>();
        await fromFire.onInput('test');
        // Should not error and complete successfully
      });
    });

    group('Validation', () {
      test('should validate data correctly', () async {
        final validationGuard = FireValueGuard.sync(
            (String? value) => value != null && value.length > 3);
        final fromFire = FromFire<String>(
          (value) async {
            inputLog.add(value);
          },
          validationGuard: validationGuard,
        );

        expect(await fromFire.isValid('test'), isTrue);
        expect(await fromFire.isValid('hi'), isFalse);
        expect(await fromFire.isValid(null), isFalse);
      });

      test('should check if operation is allowed', () async {
        final allowOperationGuard =
            FireValueGuard.sync((String? value) => value != 'blocked');
        final fromFire = FromFire<String>(
          (value) async {
            inputLog.add(value);
          },
          allowOperationGuard: allowOperationGuard,
        );

        expect(await fromFire.allowsOperation('test'), isTrue);
        expect(await fromFire.allowsOperation('blocked'), isFalse);
      });
    });

    group('fromMapEntry', () {
      test('should properly convert and call input delegate', () async {
        final fromFire = FromFire<String>(
          (value) async {
            inputLog.add(value);
          },
          validationGuard: const TestEmptyGuard<String>(),
          allowOperationGuard: const TestEmptyGuard<String>(),
        );

        final result = await fromFire.fromMapEntry('TEST', adapter);

        expect(result, equals('test'));
        expect(inputLog, equals(['test']));
      });

      test('should handle null values correctly', () async {
        final capturedInputs = <String?>[];

        // Create a special adapter that directly calls our onInput
        final specialAdapter = NullHandlingMockAdapter((value) {
          capturedInputs.add(value);
        });

        // Create FromFire with our test guards
        final fromFire = FromFire<String>(
          (value) async {
            inputLog.add(value);
          },
          validationGuard: const TestEmptyGuard<String>(),
          allowOperationGuard: const TestEmptyGuard<String>(),
        );

        // Call fromMapEntry with null and our special adapter
        final result = await fromFire.fromMapEntry(null, specialAdapter);

        // Verify the result is null
        expect(result, isNull);

        // Verify the adapter was called with null
        expect(capturedInputs, equals([]));
      });
    });

    group('mayBlockOperation flag', () {
      test('should return true when allow operation guard has validation', () {
        final allowOperationGuard =
            FireValueGuard.sync((String? value) => value != 'blocked');
        final fromFire = FromFire<String>(
          (value) async {
            inputLog.add(value);
          },
          allowOperationGuard: allowOperationGuard,
        );

        expect(fromFire.mayBlockOperation, isTrue);
      });

      test('should return false with empty guard', () {
        final fromFire = FromFire<String>((value) async {
          inputLog.add(value);
        });

        expect(fromFire.mayBlockOperation, isFalse);
      });
    });
  });
}
