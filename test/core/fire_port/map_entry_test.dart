import 'package:test/test.dart';
import 'package:firefast/firefast_core.dart';

void main() {
  group('MapEntryToFire', () {
    test('should create valid entry', () {
      final entry = MapEntryToFire.valid('key', 'value');

      expect(entry.status, equals(OperationGuardStatus.valid));
      expect(entry.entry.key, equals('key'));
      expect(entry.entry.value, equals('value'));
    });

    test('should create valid entry with null value', () {
      final entry = MapEntryToFire.valid('key', null);

      expect(entry.status, equals(OperationGuardStatus.valid));
      expect(entry.entry.key, equals('key'));
      expect(entry.entry.value, isNull);
    });

    test('should create invalid entry', () {
      final entry = MapEntryToFire.invalid();

      expect(entry.status, equals(OperationGuardStatus.invalid));
      expect(entry.entry.key, equals(''));
      expect(entry.entry.value, equals(''));
    });

    test('should create cancel operation entry', () {
      final entry = MapEntryToFire.cancelOperation();

      expect(entry.status, equals(OperationGuardStatus.cancelOperation));
      expect(entry.entry.key, equals(''));
      expect(entry.entry.value, equals(''));
    });

    test('should create empty entry with custom status', () {
      final entry = MapEntryToFire.empty(status: OperationGuardStatus.valid);

      expect(entry.status, equals(OperationGuardStatus.valid));
      expect(entry.entry.key, equals(''));
      expect(entry.entry.value, equals(''));
    });

    test('should create entry with constructor', () {
      final mapEntry = MapEntry<String, dynamic>('test-key', 'test-value');
      final entry = MapEntryToFire(
        status: OperationGuardStatus.valid,
        entry: mapEntry,
      );

      expect(entry.status, equals(OperationGuardStatus.valid));
      expect(entry.entry.key, equals('test-key'));
      expect(entry.entry.value, equals('test-value'));
    });
  });
}
