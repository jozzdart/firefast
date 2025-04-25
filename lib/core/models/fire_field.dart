import 'package:firefast/firefast_core.dart';

abstract class FireFieldBase<T> extends FirePort<T> {
  final String name;

  FireAdapter<T> get adapter;

  FireFieldBase(
    this.name, {
    required super.receiveData,
    required super.onFetched,
    super.isValid,
    super.shouldCancelAll,
  });

  Future<MapEntryOutput> toMapEntry() async {
    final data = await receiveData();
    final isValueValid = await isValid?.call(data) ?? true;

    if (!isValueValid) {
      return MapEntryOutput(
        entry: null,
        status: OperationGuardStatus.invalid,
      );
    }

    final shouldCancel = await shouldCancelAll?.call(data) ?? false;
    if (shouldCancel) {
      return MapEntryOutput(
        entry: null,
        status: OperationGuardStatus.cancelAll,
      );
    }

    final fireData = await adapter.toFire(data);
    return MapEntryOutput(
      entry: MapEntry(name, fireData),
      status: OperationGuardStatus.valid,
    );
  }

  Future<T?> fromMapEntry(dynamic rawValue) async {
    if (rawValue == null) return null;
    final value = await adapter.fromFire(rawValue);
    await onFetched(value);
    return value;
  }
}

enum OperationGuardStatus {
  invalid,
  valid,
  cancelAll,
}

class MapEntryOutput {
  final OperationGuardStatus status;
  final MapEntry<String, dynamic>? entry;
  MapEntryOutput({required this.status, required this.entry});
}
