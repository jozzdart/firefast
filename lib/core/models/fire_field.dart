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
        status: MapEntryOutputStatus.invalid,
      );
    }

    final shouldCancel = await shouldCancelAll?.call(data) ?? false;
    if (shouldCancel) {
      return MapEntryOutput(
        entry: null,
        status: MapEntryOutputStatus.cancelAll,
      );
    }

    final fireData = await adapter.toFire(data);
    return MapEntryOutput(
      entry: MapEntry(name, fireData),
      status: MapEntryOutputStatus.valid,
    );
  }

  Future<void> fromMapEntry(dynamic rawValue) async {
    if (rawValue == null) return;
    final value = await adapter.fromFire(rawValue);
    await onFetched(value);
  }
}

enum MapEntryOutputStatus {
  invalid,
  valid,
  cancelAll,
}

class MapEntryOutput {
  final MapEntryOutputStatus status;
  final MapEntry<String, dynamic>? entry;
  MapEntryOutput({required this.status, required this.entry});
}
