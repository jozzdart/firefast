import '../guards/guards.dart';

abstract class FirePortOperation<T> {
  final BaseValueGuard<T> validationGuard;
  final BaseValueGuard<T> allowOperationGuard;

  FirePortOperation({
    BaseValueGuard<T>? validationGuard,
    BaseValueGuard<T>? allowOperationGuard,
  })  : validationGuard = validationGuard ?? EmptyValueGuard<T>(),
        allowOperationGuard = allowOperationGuard ?? EmptyValueGuard<T>();

  bool get hasValidation => validationGuard.hasValidation;
  bool get mayBlockOperation => allowOperationGuard.hasValidation;

  Future<bool> isValid(T? value) async =>
      await validationGuard.isValueValid(value);

  Future<bool> allowsOperation(T? value) async =>
      await allowOperationGuard.isValueValid(value);
}
