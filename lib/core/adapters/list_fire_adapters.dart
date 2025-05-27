import 'fire_adapters.dart';
import 'fire_adapter_map.dart';

class ListFireAdapter<T> extends FireAdapter<List<T?>> {
  FireAdapter<T> get itemAdapter => adapters.of<T>();
  final FireAdapterMap adapters;
  const ListFireAdapter(this.adapters);

  @override
  Future<List<T?>?> fromFire(value) async {
    if (value == null) return null;
    final results = await Future.wait(
        (value as List).map((e) => itemAdapter.fromFire(e)).toList());
    return results;
  }

  @override
  Future toFire(List<T?>? value) async {
    if (value == null) return null;
    final results = await Future.wait(value.map((e) => itemAdapter.toFire(e)));
    return results;
  }
}
