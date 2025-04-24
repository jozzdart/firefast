import 'package:test/test.dart';
import 'package:firefast/firefast_core.dart';

class TestFirePort<T> extends FirePort<T> {
  TestFirePort({
    required super.receiveData,
    required super.onFetched,
    super.isValid,
    super.shouldCancelAll,
  });
}

void main() {
  group('FirePort', () {
    late ToFireDelegate<String> receiveData;
    late FromFireDelegate<String> onFetched;
    late IsValid<String> isValid;
    late ShouldCancelAll<String> shouldCancelAll;
    late TestFirePort<String> firePort;

    setUp(() {
      // Set up the delegates
      receiveData = () async => 'test-data';
      onFetched = (_) async {};
      isValid = (value) async => value != null;
      shouldCancelAll = (value) async => value == 'cancel';

      firePort = TestFirePort<String>(
        receiveData: receiveData,
        onFetched: onFetched,
        isValid: isValid,
        shouldCancelAll: shouldCancelAll,
      );
    });

    test('should properly initialize with required delegates', () {
      expect(firePort.receiveData, equals(receiveData));
      expect(firePort.onFetched, equals(onFetched));
      expect(firePort.isValid, equals(isValid));
      expect(firePort.shouldCancelAll, equals(shouldCancelAll));
    });

    test('should allow initialization with only required delegates', () {
      final basicFirePort = TestFirePort<String>(
        receiveData: receiveData,
        onFetched: onFetched,
      );

      expect(basicFirePort.receiveData, equals(receiveData));
      expect(basicFirePort.onFetched, equals(onFetched));
      expect(basicFirePort.isValid, isNull);
      expect(basicFirePort.shouldCancelAll, isNull);
    });

    test('delegates should execute properly', () async {
      final result = await firePort.receiveData();
      expect(result, equals('test-data'));

      bool validResult = await firePort.isValid!('test-data');
      expect(validResult, isTrue);

      bool cancelResult = await firePort.shouldCancelAll!('cancel');
      expect(cancelResult, isTrue);
    });

    test('isValid should return false for null values', () async {
      bool validResult = await firePort.isValid!(null);
      expect(validResult, isFalse);
    });

    test('shouldCancelAll should return false for non-cancel values', () async {
      bool cancelResult = await firePort.shouldCancelAll!('not-cancel');
      expect(cancelResult, isFalse);
    });

    test('can use different data types', () async {
      final intPort = TestFirePort<int>(
        receiveData: () async => 42,
        onFetched: (_) async {},
      );

      final boolPort = TestFirePort<bool>(
        receiveData: () async => true,
        onFetched: (_) async {},
      );

      final dateTimePort = TestFirePort<DateTime>(
        receiveData: () async => DateTime(2023, 1, 1),
        onFetched: (_) async {},
      );

      expect(await intPort.receiveData(), equals(42));
      expect(await boolPort.receiveData(), equals(true));
      expect(await dateTimePort.receiveData(), equals(DateTime(2023, 1, 1)));
    });
  });
}
