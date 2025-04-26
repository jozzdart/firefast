import 'package:flutter_test/flutter_test.dart';
import 'package:firefast/firefast_core.dart';

// Mock implementation of BaseValueGuard for testing
class MockBaseValueGuard extends BaseValueGuard<String> {
  final bool _hasValidation;
  final bool Function(String? value) _isValueValidImpl;

  const MockBaseValueGuard({
    required bool hasValidation,
    required bool Function(String? value) isValueValidImpl,
  })  : _hasValidation = hasValidation,
        _isValueValidImpl = isValueValidImpl;

  @override
  bool get hasValidation => _hasValidation;

  @override
  Future<bool> isValueValid(String? value) async {
    return _isValueValidImpl(value);
  }
}

void main() {
  group('BaseValueGuard', () {
    test('hasValidation getter should return configured value', () {
      final guardWithValidation = MockBaseValueGuard(
        hasValidation: true,
        isValueValidImpl: (_) => true,
      );

      final guardWithoutValidation = MockBaseValueGuard(
        hasValidation: false,
        isValueValidImpl: (_) => true,
      );

      expect(guardWithValidation.hasValidation, true);
      expect(guardWithoutValidation.hasValidation, false);
    });

    test('isValueValid should return result from implementation', () async {
      final alwaysValidGuard = MockBaseValueGuard(
        hasValidation: true,
        isValueValidImpl: (_) => true,
      );

      final alwaysInvalidGuard = MockBaseValueGuard(
        hasValidation: true,
        isValueValidImpl: (_) => false,
      );

      expect(await alwaysValidGuard.isValueValid('test'), true);
      expect(await alwaysInvalidGuard.isValueValid('test'), false);
    });

    test('isValueValid should handle null values properly', () async {
      final nullCheckingGuard = MockBaseValueGuard(
        hasValidation: true,
        isValueValidImpl: (value) => value != null,
      );

      expect(await nullCheckingGuard.isValueValid('test'), true);
      expect(await nullCheckingGuard.isValueValid(null), false);
    });
  });
}
