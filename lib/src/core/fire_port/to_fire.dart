import 'fire_port.dart';

class ToFireEmpty<T> extends ToFire<T> {
  @override
  ToFireDelegate<T> get receiveData => () async => null as T;

  ToFireEmpty() : super(_empty);
  static Future<T?> _empty<T>() async {
    return null as T;
  }
}

class ToFire<T> extends FirePortOperation<T> {
  final ToFireDelegate<T> receiveData;

  ToFire(
    this.receiveData, {
    super.validationGuard,
    super.allowOperationGuard,
  });

  ToFire.sync(
    T? value, {
    BaseValueGuard<T>? validationGuard,
    BaseValueGuard<T>? allowOperationGuard,
  }) : this(
          () async => value,
          validationGuard: validationGuard ?? EmptyValueGuard<T>(),
          allowOperationGuard: allowOperationGuard ?? EmptyValueGuard<T>(),
        );

  ToFire.empty() : this(() async => null);

  Future<MapEntryToFire> toMapEntry(String name, FireAdapter<T> adapter) async {
    final data = await receiveData();
    final allowsOperation = await super.allowsOperation(data);
    if (!allowsOperation) {
      return MapEntryToFire.cancelOperation();
    }
    final isValueValid = await super.isValid(data);
    if (!isValueValid) {
      return MapEntryToFire.invalid();
    }
    final fireData = await adapter.toFire(data);
    return MapEntryToFire.valid(name, fireData);
  }
}
