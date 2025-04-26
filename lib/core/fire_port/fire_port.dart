import 'package:firefast/firefast_core.dart';

abstract class FirePort<T> {
  final ToFire<T>? _toFire;
  final FromFire<T>? _fromFire;

  ToFire<T> get toFire => _toFire ?? ToFireEmpty<T>();
  FromFire<T> get fromFire => _fromFire ?? FromFireEmpty<T>();

  const FirePort({
    ToFire<T>? toFire,
    FromFire<T>? fromFire,
  })  : _toFire = toFire,
        _fromFire = fromFire;

  Future<MapEntryToFire?> portToEntry(
    String name,
    FireAdapter<T> adapter,
  ) async =>
      await toFire.toMapEntry(name, adapter);

  Future<T?> fromEntry(dynamic rawValue, FireAdapter<T> adapter) async =>
      await fromFire.fromMapEntry(rawValue, adapter);

  Future<T?> receiveToFire() async => await toFire.receiveData();

  Future<bool> allowsRead() async {
    final canBlock = fromFire.mayBlockOperation;
    if (canBlock == true) {
      final localData = await receiveToFire();
      final allows = await fromFire.allowsOperation(localData);
      return allows;
    }
    return true;
  }

  Future<void> onInput(T? value) async => await fromFire.onInput(value);
}
