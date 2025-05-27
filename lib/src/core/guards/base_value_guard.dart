abstract class BaseValueGuard<T> {
  const BaseValueGuard();

  bool get hasValidation;
  Future<bool> isValueValid(T? value);
}
