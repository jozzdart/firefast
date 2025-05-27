import 'fire_port.dart';

class FromFireEmpty<T> extends FromFire<T> {
  @override
  FromFireDelegate<T> get onInput => (e) async => {};

  FromFireEmpty() : super(_empty);
  static Future<void> _empty<T>(T? value) async {}
}

class FromFire<T> extends FirePortOperation<T> {
  final FromFireDelegate<T> onInput;

  FromFire(
    this.onInput, {
    super.validationGuard,
    super.allowOperationGuard,
  });

  FromFire.sync(
    FromFireSyncDelegate<T> function, {
    BaseValueGuard<T>? validationGuard,
    BaseValueGuard<T>? allowOperationGuard,
  }) : this(
          (v) async => function(v),
          validationGuard: validationGuard ?? EmptyValueGuard<T>(),
          allowOperationGuard: allowOperationGuard ?? EmptyValueGuard<T>(),
        );

  Future<T?> fromMapEntry(dynamic rawValue, FireAdapter<T> adapter) async {
    if (rawValue == null) return null;
    final value = await adapter.fromFire(rawValue);
    await onInput(value);
    return value;
  }
}
