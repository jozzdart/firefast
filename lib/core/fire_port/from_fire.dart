import 'package:firefast/firefast_core.dart';

class FromFireEmpty<T> extends FromFire<T> {
  @override
  FromFireDelegate<T> get onInput => (e) async => {};

  const FromFireEmpty() : super(_empty);
  static Future<void> _empty<T>(T? value) async {}
}

class FromFire<T> extends FirePortOperation<T> {
  final FromFireDelegate<T> onInput;

  const FromFire(
    this.onInput, {
    super.validationGuard,
    super.allowOperationGuard,
  });

  FromFire.sync(
    FromFireSyncDelegate<T> function, {
    BaseValueGuard<T> validationGuard = const EmptyValueGuard(),
    BaseValueGuard<T> allowOperationGuard = const EmptyValueGuard(),
  }) : this(
          (v) async => function(v),
          validationGuard: validationGuard,
          allowOperationGuard: allowOperationGuard,
        );

  Future<T?> fromMapEntry(dynamic rawValue, FireAdapter<T> adapter) async {
    if (rawValue == null) return null;
    final value = await adapter.fromFire(rawValue);
    await onInput(value);
    return value;
  }
}
