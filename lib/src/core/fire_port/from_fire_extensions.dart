import 'fire_port.dart';

extension FromFireDelegateExtensions<T> on FromFireDelegate<T> {
  FromFire<T> fromFire({
    BaseValueGuard<T> validationGuard = const EmptyValueGuard(),
    BaseValueGuard<T> allowOperationGuard = const EmptyValueGuard(),
  }) {
    return FromFire<T>(
      this,
      validationGuard: validationGuard,
      allowOperationGuard: allowOperationGuard,
    );
  }
}

extension FromFireSyncDelegateExtensions<T> on FromFireSyncDelegate<T> {
  FromFire<T> fromFire({
    BaseValueGuard<T> validationGuard = const EmptyValueGuard(),
    BaseValueGuard<T> allowOperationGuard = const EmptyValueGuard(),
  }) {
    return FromFire<T>.sync(
      this,
      validationGuard: validationGuard,
      allowOperationGuard: allowOperationGuard,
    );
  }
}
