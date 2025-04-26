import 'package:test/test.dart';
import 'package:firefast/firefast_core.dart';

abstract class FireFieldBase<T> extends FirePort<T> {
  final String name;
  FireAdapter<T> get adapter;

  FireFieldBase(
    this.name, {
    super.fromFire,
    super.toFire,
  });

  Future<MapEntryToFire?> toMapEntry() async =>
      await super.portToEntry(name, adapter);

  Future<T?> fromMapEntry(dynamic rawValue) async =>
      super.fromEntry(rawValue, adapter);
}

class TestFirePort<T> extends FirePort<T> {
  TestFirePort({
    super.fromFire,
    super.toFire,
  });
}

void main() {
  group('FirePort', () {
    late ToFire<String> toFire;
    late BaseValueGuard<String> isValid;
    late BaseValueGuard<String> allowOperation;
    late TestFirePort<String> firePort;

    setUp(() {
      // Set up the delegates
      isValid = FireValueGuard.sync((String? value) => value != null);
      allowOperation =
          FireValueGuard.sync((String? value) => value != 'cancel');

      toFire = 'test-data'.toFire(
        validationGuard: isValid,
        allowOperationGuard: allowOperation,
      );

      firePort = TestFirePort<String>(
        toFire: toFire,
      );
    });

    test('should properly initialize with required delegates', () {
      expect(firePort.toFire.receiveData, equals(toFire.receiveData));
      expect(firePort.toFire.validationGuard, equals(isValid));
      expect(firePort.toFire.allowOperationGuard, equals(allowOperation));
    });

    test('should allow initialization with only required delegates', () {
      final basicFirePort = TestFirePort<String>(
        toFire: toFire,
      );

      expect(basicFirePort.toFire.receiveData, equals(toFire.receiveData));

      expect(basicFirePort.toFire.validationGuard, equals(isValid));
      expect(basicFirePort.toFire.allowOperationGuard, equals(allowOperation));
    });

    test('delegates should execute properly', () async {
      final result = await firePort.receiveToFire();
      expect(result, equals('test-data'));

      bool? validResult = await firePort.toFire.isValid('test-data');
      expect(validResult, isTrue);

      bool? cancelResult = await firePort.toFire.allowsOperation('cancel');
      expect(cancelResult, isFalse);
    });

    test('isValid should return false for null values', () async {
      bool? validResult = await firePort.toFire.isValid(null);
      expect(validResult, isFalse);
    });

    test('shouldCancelAll should return false for non-cancel values', () async {
      bool? cancelResult = await firePort.toFire.allowsOperation('not-cancel');
      expect(cancelResult, isTrue);
    });

    test('can use different data types', () async {
      final intPort = TestFirePort<int>(
        toFire: 42.toFire(),
      );

      final boolPort = TestFirePort<bool>(
        toFire: true.toFire(),
      );

      final dateTimePort = TestFirePort<DateTime>(
        toFire: DateTime(2023, 1, 1).toFire(),
      );

      expect(await intPort.receiveToFire(), equals(42));
      expect(await boolPort.receiveToFire(), equals(true));
      expect(await dateTimePort.receiveToFire(), equals(DateTime(2023, 1, 1)));
    });
  });
}
