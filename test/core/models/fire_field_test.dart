import 'package:test/test.dart';
import 'package:firefast/firefast_core.dart';

import '../adapters/fire_adapters_test.dart';

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
      final field = FireValue<String>(
        'testField',
        toFire: ToFire.sync('test-data'),
      );

      expect(field.name, equals('testField'));
      expect(adapterMap.of<String>(), equals(stringAdapter));
    });

    test('should properly inherit FirePort methods', () async {
      String receivedValue = '';

      final field = FireValue<String>(
        'testField',
        toFire: 'test-data'.toFire(),
        fromFire: FromFire.sync(
          (value) {
            receivedValue = value ?? '';
          },
        ),
      );

      expect(await field.receiveToFire(), equals('test-data'));

      await field.onInput('received-data');
      expect(receivedValue, equals('received-data'));
    });

    test('works with various data types using their corresponding adapters',
        () async {
      // Test with string adapter
      final stringField = FireValue<String>(
        'stringField',
        toFire: 'string-value'.toFire(),
      );
      expect(adapterMap.of<String>(), isA<StringFireAdapter>());
      expect(await stringField.receiveToFire(), equals('string-value'));

      // Test with int adapter
      final intField = FireValue<int>(
        'intField',
        toFire: 42.toFire(),
      );
      expect(adapterMap.of<int>(), isA<IntFireAdapter>());
      expect(await intField.receiveToFire(), equals(42));

      // Test with bool adapter
      final boolField = FireValue<bool>(
        'boolField',
        toFire: true.toFire(),
      );
      expect(adapterMap.of<bool>(), isA<BoolFireAdapter>());
      expect(await boolField.receiveToFire(), equals(true));

      // Test with datetime adapter
      final datetimeField = FireValue<DateTime>(
        'datetimeField',
        toFire: DateTime(2023, 1, 1).toFire(),
      );
      expect(adapterMap.of<DateTime>(), isA<DateTimeFireAdapter>());
      expect(await datetimeField.receiveToFire(), equals(DateTime(2023, 1, 1)));
    });

    test('adapter should be able to convert values to and from Fire format',
        () async {
      final field = FireValue<String>(
        'testField',
        toFire: 'test-data'.toFire(),
      );

      final fieldValue = await field.receiveToFire();
      expect(fieldValue, equals('test-data'));

      final fireValue = await adapterMap.of<String>().toFire(fieldValue);
      expect(fireValue, equals('test-data'));

      final reconstructedValue =
          await adapterMap.of<String>().fromFire(fireValue);
      expect(reconstructedValue, equals('test-data'));
    });

    test('list field works properly with list adapter', () async {
      final listField = FireValue<List<String?>>(
        'listField',
        toFire: ['a', 'b', null, 'c'].toFire(),
      );

      final fieldValue = await listField.receiveToFire();
      expect(fieldValue, equals(['a', 'b', null, 'c']));

      final fireValue = await adapterMap.of<List<String?>>().toFire(fieldValue);
      expect(fireValue, isA<List>());
      expect(fireValue, equals(['a', 'b', null, 'c']));

      final reconstructedValue =
          await adapterMap.of<List<String?>>().fromFire(fireValue);
      expect(reconstructedValue, equals(['a', 'b', null, 'c']));
    });
  });
}
