import 'package:firefast/firefast_core.dart';

class FireValue<T> extends FirePort<T> {
  final String name;

  const FireValue(
    this.name, {
    super.toFire,
    super.fromFire,
  });

  Future<MapEntryToFire?> toEntry(FireAdapterMap adapters) async =>
      await super.portToEntry(name, adapters.of<T>());

  Future<T?> fromMapEntry(dynamic rawValue, FireAdapterMap adapters) async =>
      await super.fromEntry(rawValue, adapters.of<T>());
}
