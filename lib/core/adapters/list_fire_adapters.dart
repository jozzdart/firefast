import 'package:firefast/firefast_core.dart';

abstract class ListFireAdapter<T> extends FireAdapter<List<T?>> {
  FireAdapter<T> get itemAdapter;
  const ListFireAdapter();

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
