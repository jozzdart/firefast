import 'package:flutter_test/flutter_test.dart';
import 'package:firefast/firefast_core.dart';

// Mock implementation of OperationGuard for testing
class MockOperationGuard extends OperationGuard {
  final Future<bool> Function() _canPerformImpl;

  const MockOperationGuard(this._canPerformImpl);

  @override
  Future<bool> canPerform() async {
    return await _canPerformImpl();
  }
}

void main() {
  group('OperationGuard', () {
    test('canPerform returns the implementation result', () async {
      final alwaysAllowGuard = MockOperationGuard(() async => true);
      final alwaysDenyGuard = MockOperationGuard(() async => false);

      expect(await alwaysAllowGuard.canPerform(), true);
      expect(await alwaysDenyGuard.canPerform(), false);
    });

    test('canPerform correctly returns delayed results', () async {
      bool shouldAllow = false;
      final dynamicGuard = MockOperationGuard(() async {
        // Add delay to simulate async operation
        await Future.delayed(const Duration(milliseconds: 10));
        return shouldAllow;
      });

      expect(await dynamicGuard.canPerform(), false);

      shouldAllow = true;
      expect(await dynamicGuard.canPerform(), true);
    });

    test('can handle exceptions in the implementation', () async {
      final errorGuard = MockOperationGuard(() async {
        throw Exception('Test exception');
      });

      expect(() => errorGuard.canPerform(), throwsException);
    });
  });
}
