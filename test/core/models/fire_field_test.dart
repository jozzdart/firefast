import 'package:test/test.dart';
import 'package:firefast/firefast_core.dart';

import '../adapters/fire_adapters_test.dart';

class TestFireField<T> extends FireFieldBase<T> {
  @override
  final FireAdapter<T> adapter = TestFireAdapterMap.instance.of<T>();

  TestFireField(
    super.name, {
    required super.receiveData,
    required super.onFetched,
    super.isValid,
    super.shouldCancelAll,
  });
}

void main() {
  group('FireField', () {
    late TestFireAdapterMap adapterMap;

    setUp(() {
      // Ensure adapter map is initialized once
      adapterMap = TestFireAdapterMap.instance;
      adapterMap.registerAll();
    });

    test('should initialize with all properties', () {
      final stringAdapter = adapterMap.of<String>();
      final field = TestFireField<String>(
        'testField',
        receiveData: () async => 'test-data',
        onFetched: (_) async {},
        isValid: (value) async => value != null,
        shouldCancelAll: (value) async => value == 'cancel',
      );

      expect(field.name, equals('testField'));
      expect(field.adapter, equals(stringAdapter));
    });

    test('should properly inherit FirePort methods', () async {
      String receivedValue = '';

      final field = TestFireField<String>(
        'testField',
        receiveData: () async => 'test-data',
        onFetched: (value) async {
          receivedValue = value ?? '';
        },
      );

      expect(await field.receiveData(), equals('test-data'));

      await field.onFetched('received-data');
      expect(receivedValue, equals('received-data'));
    });

    test('works with various data types using their corresponding adapters',
        () async {
      // Test with string adapter
      final stringField = TestFireField<String>(
        'stringField',
        receiveData: () async => 'string-value',
        onFetched: (_) async {},
      );
      expect(stringField.adapter, isA<StringFireAdapter>());
      expect(await stringField.receiveData(), equals('string-value'));

      // Test with int adapter
      final intField = TestFireField<int>(
        'intField',
        receiveData: () async => 42,
        onFetched: (_) async {},
      );
      expect(intField.adapter, isA<IntFireAdapter>());
      expect(await intField.receiveData(), equals(42));

      // Test with bool adapter
      final boolField = TestFireField<bool>(
        'boolField',
        receiveData: () async => true,
        onFetched: (_) async {},
      );
      expect(boolField.adapter, isA<BoolFireAdapter>());
      expect(await boolField.receiveData(), equals(true));

      // Test with datetime adapter
      final datetimeField = TestFireField<DateTime>(
        'datetimeField',
        receiveData: () async => DateTime(2023, 1, 1),
        onFetched: (_) async {},
      );
      expect(datetimeField.adapter, isA<DateTimeFireAdapter>());
      expect(await datetimeField.receiveData(), equals(DateTime(2023, 1, 1)));
    });

    test('adapter should be able to convert values to and from Fire format',
        () async {
      final field = TestFireField<String>(
        'testField',
        receiveData: () async => 'test-data',
        onFetched: (_) async {},
      );

      final fieldValue = await field.receiveData();
      expect(fieldValue, equals('test-data'));

      final fireValue = await field.adapter.toFire(fieldValue);
      expect(fireValue, equals('test-data'));

      final reconstructedValue = await field.adapter.fromFire(fireValue);
      expect(reconstructedValue, equals('test-data'));
    });

    test('list field works properly with list adapter', () async {
      final listField = TestFireField<List<String?>>(
        'listField',
        receiveData: () async => ['a', 'b', null, 'c'],
        onFetched: (_) async {},
      );

      final fieldValue = await listField.receiveData();
      expect(fieldValue, equals(['a', 'b', null, 'c']));

      final fireValue = await listField.adapter.toFire(fieldValue);
      expect(fireValue, isA<List>());
      expect(fireValue, equals(['a', 'b', null, 'c']));

      final reconstructedValue = await listField.adapter.fromFire(fireValue);
      expect(reconstructedValue, equals(['a', 'b', null, 'c']));
    });
  });
}
