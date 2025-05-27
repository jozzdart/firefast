import 'package:firefast/firefast_core.dart';

class EmptyValueGuard<T> extends BaseValueGuard<T> {
  const EmptyValueGuard();

  @override
  bool get hasValidation => false;

  @override
  Future<bool> isValueValid(T? value) async => true;
}
