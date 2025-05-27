import 'base_value_guard.dart';

class EmptyValueGuard<T> extends BaseValueGuard<T> {
  const EmptyValueGuard();

  @override
  bool get hasValidation => false;

  @override
  Future<bool> isValueValid(T? value) async => true;
}
