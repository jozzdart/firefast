import 'package:test/test.dart';
import 'package:firefast/firefast_core.dart';

class MockAdapter extends FireAdapter<String> {
  @override
  Future<dynamic> toFire(String? value) async => value?.toUpperCase();

  @override
  Future<String?> fromFire(dynamic value) async =>
      value == null ? null : (value as String).toLowerCase();
}

// Custom guard that accepts any type
class TestEmptyGuard<T> extends BaseValueGuard<T> {
  @override
  bool get hasValidation => false;

  @override
  Future<bool> isValueValid(T? value) async => true;

  const TestEmptyGuard();
}

class TestFirePort extends FirePort<String> {
  final FireAdapter<String> adapter;

  const TestFirePort({
    required this.adapter,
    super.toFire,
    super.fromFire,
  });
}

void main() {
  group('FirePort', () {
    late FireAdapter<String> adapter;
    late ToFire<String> toFire;
    late FromFire<String> fromFire;
    late List<String?> inputLog;

    setUp(() {
      adapter = MockAdapter();
      inputLog = [];

      // Create ToFire with explicit guards
      toFire = ToFire.sync(
        'test-data',
        validationGuard: const TestEmptyGuard<String>(),
        allowOperationGuard: const TestEmptyGuard<String>(),
      );

      // Create FromFire with explicit guards
      fromFire = FromFire<String>(
        (value) async {
          inputLog.add(value);
        },
        validationGuard: const TestEmptyGuard<String>(),
        allowOperationGuard: const TestEmptyGuard<String>(),
      );
    });

    test('should properly initialize with both delegates', () {
      final firePort = TestFirePort(
        adapter: adapter,
        toFire: toFire,
        fromFire: fromFire,
      );

      expect(firePort.toFire, equals(toFire));
      expect(firePort.fromFire, equals(fromFire));
    });

    test('should initialize with default empty delegates when none provided',
        () {
      final firePort = TestFirePort(adapter: adapter);

      expect(firePort.toFire, isA<ToFireEmpty<String>>());
      expect(firePort.fromFire, isA<FromFireEmpty<String>>());
    });

    test('portToEntry should call toFire.toMapEntry', () async {
      final firePort = TestFirePort(
        adapter: adapter,
        toFire: toFire,
      );

      final result = await firePort.portToEntry('key', adapter);

      expect(result?.status, equals(OperationGuardStatus.valid));
      expect(result?.entry.key, equals('key'));
      expect(result?.entry.value, equals('TEST-DATA'));
    });

    test('fromEntry should call fromFire.fromMapEntry', () async {
      final firePort = TestFirePort(
        adapter: adapter,
        fromFire: fromFire,
      );

      final result = await firePort.fromEntry('TEST', adapter);

      expect(result, equals('test'));
      expect(inputLog, equals(['test']));
    });

    test('receiveToFire should call toFire.receiveData', () async {
      final firePort = TestFirePort(
        adapter: adapter,
        toFire: toFire,
      );

      final result = await firePort.receiveToFire();

      expect(result, equals('test-data'));
    });

    test('onInput should call fromFire.onInput', () async {
      final firePort = TestFirePort(
        adapter: adapter,
        fromFire: fromFire,
      );

      await firePort.onInput('test-input');

      expect(inputLog, equals(['test-input']));
    });

    group('allowsRead', () {
      test(
          'should return true when fromFire does not have an allowOperationGuard',
          () async {
        final firePort = TestFirePort(
          adapter: adapter,
          fromFire: FromFire<String>((value) async {
            inputLog.add(value);
          }),
        );

        final result = await firePort.allowsRead();

        expect(result, isTrue);
      });

      test('should return result of allowsOperation when guard exists',
          () async {
        final guardAllowsFire = TestFirePort(
          adapter: adapter,
          toFire: toFire,
          fromFire: FromFire<String>(
            (value) async {
              inputLog.add(value);
            },
            allowOperationGuard: FireValueGuard.sync((value) => true),
          ),
        );

        final guardBlocksFire = TestFirePort(
          adapter: adapter,
          toFire: toFire,
          fromFire: FromFire<String>(
            (value) async {
              inputLog.add(value);
            },
            allowOperationGuard: FireValueGuard.sync((value) => false),
          ),
        );

        expect(await guardAllowsFire.allowsRead(), isTrue);
        expect(await guardBlocksFire.allowsRead(), isFalse);
      });
    });
  });
}
