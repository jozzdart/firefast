import 'package:firefast/firefast_core.dart';

abstract class FirePortOperation<T> {
  final BaseValueGuard<T> validationGuard;
  final BaseValueGuard<T> allowOperationGuard;

  const FirePortOperation({
    this.validationGuard = const EmptyValueGuard(),
    this.allowOperationGuard = const EmptyValueGuard(),
  });

  bool get hasValidation => validationGuard.hasValidation;
  bool get mayBlockOperation => allowOperationGuard.hasValidation;

  Future<bool> isValid(T? value) async =>
      await validationGuard.isValueValid(value);

  Future<bool> allowsOperation(T? value) async =>
      await allowOperationGuard.isValueValid(value);
}
