import 'package:test/test.dart';
import 'package:firefast/firefast_core.dart';

void main() {
  group('FromFire Extensions', () {
    group('FromFireDelegate extension', () {
      test('converts async function to FromFire instance', () async {
        final List<String?> inputLog = [];

        fromFireDelegate(String? value) async {
          inputLog.add(value);
        }

        final fromFire = fromFireDelegate.fromFire();
        expect(fromFire, isA<FromFire<String>>());

        await fromFire.onInput('test');
        expect(inputLog, equals(['test']));
      });

      test('passes through custom guards', () async {
        final List<String?> inputLog = [];
        final validationGuard =
            FireValueGuard.sync((String? value) => value?.isNotEmpty == true);
        final allowOperationGuard =
            FireValueGuard.sync((String? value) => value != 'blocked');

        fromFireDelegate(String? value) async {
          inputLog.add(value);
        }

        final fromFire = fromFireDelegate.fromFire(
          validationGuard: validationGuard,
          allowOperationGuard: allowOperationGuard,
        );

        expect(await fromFire.isValid('test'), isTrue);
        expect(await fromFire.isValid(''), isFalse);

        expect(await fromFire.allowsOperation('test'), isTrue);
        expect(await fromFire.allowsOperation('blocked'), isFalse);
      });
    });

    group('FromFireSyncDelegate extension', () {
      test('converts sync function to FromFire instance', () async {
        final List<String?> inputLog = [];

        fromFireSyncDelegate(String? value) {
          inputLog.add(value);
        }

        final fromFire = fromFireSyncDelegate.fromFire();
        expect(fromFire, isA<FromFire<String>>());

        await fromFire.onInput('test');
        expect(inputLog, equals(['test']));
      });

      test('passes through custom guards', () async {
        final List<String?> inputLog = [];
        final validationGuard =
            FireValueGuard.sync((String? value) => value?.isNotEmpty == true);
        final allowOperationGuard =
            FireValueGuard.sync((String? value) => value != 'blocked');

        fromFireSyncDelegate(String? value) {
          inputLog.add(value);
        }

        final fromFire = fromFireSyncDelegate.fromFire(
          validationGuard: validationGuard,
          allowOperationGuard: allowOperationGuard,
        );

        expect(await fromFire.isValid('test'), isTrue);
        expect(await fromFire.isValid(''), isFalse);

        expect(await fromFire.allowsOperation('test'), isTrue);
        expect(await fromFire.allowsOperation('blocked'), isFalse);
      });
    });

    test('handles null values correctly', () async {
      final List<String?> inputLog = [];

      fromFireDelegate(String? value) async {
        inputLog.add(value);
      }

      final fromFire = fromFireDelegate.fromFire();

      await fromFire.onInput(null);
      expect(inputLog, equals([null]));
    });
  });
}
