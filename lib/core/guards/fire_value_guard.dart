import 'package:firefast/firefast_core.dart';

typedef IsValueValid<T> = Future<bool> Function(T?);
typedef IsValueValidSync<T> = bool Function(T?);

class FireValueGuard<T> extends BaseValueGuard<T> {
  final IsValueValid<T>? isValid;
  const FireValueGuard(
    this.isValid,
  );

  FireValueGuard.sync(IsValueValidSync<T> function)
      : isValid = ((v) async => function(v));

  @override
  bool get hasValidation => isValid != null;

  @override
  Future<bool> isValueValid(T? value) async {
    if (hasValidation) {
      final result = await isValid!.call(value);
      return result;
    }
    return true;
  }
}
