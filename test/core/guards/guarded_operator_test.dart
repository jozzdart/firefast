import 'package:flutter_test/flutter_test.dart';
import 'package:firefast/firefast_core.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'guarded_operator_test.mocks.dart';

@GenerateMocks([OperationGuard])
class TestGuardedOperator extends FireGuardedOperator {
  final Function performCallback;
  bool performCalled = false;

  TestGuardedOperator({
    required this.performCallback,
    super.guards,
  });

  @override
  Future<void> perform() async {
    performCalled = true;
    await performCallback();
  }
}

void main() {
  group('FireGuardedOperator', () {
    late TestGuardedOperator operator;
    late MockOperationGuard mockGuard1;
    late MockOperationGuard mockGuard2;

    setUp(() {
      mockGuard1 = MockOperationGuard();
      mockGuard2 = MockOperationGuard();

      operator = TestGuardedOperator(
        performCallback: () async {},
        guards: [mockGuard1, mockGuard2],
      );
    });

    test('canPerform returns true when all guards allow', () async {
      when(mockGuard1.canPerform()).thenAnswer((_) async => true);
      when(mockGuard2.canPerform()).thenAnswer((_) async => true);

      final result = await operator.canPerform();

      expect(result, true);
      verify(mockGuard1.canPerform()).called(1);
      verify(mockGuard2.canPerform()).called(1);
    });

    test('canPerform returns false when any guard denies', () async {
      when(mockGuard1.canPerform()).thenAnswer((_) async => true);
      when(mockGuard2.canPerform()).thenAnswer((_) async => false);

      final result = await operator.canPerform();

      expect(result, false);
      verify(mockGuard1.canPerform()).called(1);
      verify(mockGuard2.canPerform()).called(1);
    });

    test('canPerform short-circuits on first denial', () async {
      when(mockGuard1.canPerform()).thenAnswer((_) async => false);
      when(mockGuard2.canPerform()).thenAnswer((_) async => true);

      final result = await operator.canPerform();

      expect(result, false);
      verify(mockGuard1.canPerform()).called(1);
      verifyNever(mockGuard2.canPerform());
    });

    test('tryPerform calls perform when guards allow', () async {
      when(mockGuard1.canPerform()).thenAnswer((_) async => true);
      when(mockGuard2.canPerform()).thenAnswer((_) async => true);

      await operator.tryPerform();

      expect(operator.performCalled, true);
      verify(mockGuard1.canPerform()).called(1);
      verify(mockGuard2.canPerform()).called(1);
    });

    test('tryPerform does not call perform when any guard denies', () async {
      when(mockGuard1.canPerform()).thenAnswer((_) async => true);
      when(mockGuard2.canPerform()).thenAnswer((_) async => false);

      await operator.tryPerform();

      expect(operator.performCalled, false);
      verify(mockGuard1.canPerform()).called(1);
      verify(mockGuard2.canPerform()).called(1);
    });

    test('canPerform works with no guards (always returns true)', () async {
      operator = TestGuardedOperator(
        performCallback: () async {},
        guards: [],
      );

      final result = await operator.canPerform();

      expect(result, true);
    });

    test('tryPerform always calls perform with no guards', () async {
      operator = TestGuardedOperator(
        performCallback: () async {},
        guards: [],
      );

      await operator.tryPerform();

      expect(operator.performCalled, true);
    });

    test('perform is properly called with arguments', () async {
      bool customFunctionCalled = false;
      operator = TestGuardedOperator(
        performCallback: () async {
          customFunctionCalled = true;
        },
      );

      await operator.perform();

      expect(customFunctionCalled, true);
    });

    test('tryPerform properly awaits canPerform', () async {
      // Using a simple flag instead of a completer
      bool guardChecked = false;

      // Use a mock that sets the flag
      when(mockGuard1.canPerform()).thenAnswer((_) async {
        await Future.delayed(const Duration(milliseconds: 50));
        guardChecked = true;
        return true;
      });

      when(mockGuard2.canPerform()).thenAnswer((_) async => true);

      // Call the method and await it
      await operator.tryPerform();

      // By this point, canPerform should have completed
      expect(guardChecked, true);
      expect(operator.performCalled, true);
    });
  });
}
