import 'package:flutter_test/flutter_test.dart';
import 'package:firefast/firefast_core.dart';

void main() {
  group('OperationGuardStatus', () {
    test('enum has expected values', () {
      expect(OperationGuardStatus.values.length, 3);
      expect(OperationGuardStatus.values, contains(OperationGuardStatus.valid));
      expect(
          OperationGuardStatus.values, contains(OperationGuardStatus.invalid));
      expect(OperationGuardStatus.values,
          contains(OperationGuardStatus.cancelOperation));
    });

    test('enum values have expected indices', () {
      expect(OperationGuardStatus.valid.index, 0);
      expect(OperationGuardStatus.invalid.index, 1);
      expect(OperationGuardStatus.cancelOperation.index, 2);
    });

    test('enum names match expected values', () {
      expect(OperationGuardStatus.valid.name, 'valid');
      expect(OperationGuardStatus.invalid.name, 'invalid');
      expect(OperationGuardStatus.cancelOperation.name, 'cancelOperation');
    });

    test('can be used in switch statements', () {
      String statusMessage;

      for (final status in OperationGuardStatus.values) {
        switch (status) {
          case OperationGuardStatus.valid:
            statusMessage = 'Operation is valid';
            break;
          case OperationGuardStatus.invalid:
            statusMessage = 'Operation is invalid';
            break;
          case OperationGuardStatus.cancelOperation:
            statusMessage = 'Operation was cancelled';
            break;
        }

        if (status == OperationGuardStatus.valid) {
          expect(statusMessage, 'Operation is valid');
        } else if (status == OperationGuardStatus.invalid) {
          expect(statusMessage, 'Operation is invalid');
        } else if (status == OperationGuardStatus.cancelOperation) {
          expect(statusMessage, 'Operation was cancelled');
        }
      }
    });
  });
}
