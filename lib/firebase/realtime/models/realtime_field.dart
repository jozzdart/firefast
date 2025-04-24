import 'package:firefast/firefast_core.dart';

class RealtimeField<T> extends FireFieldBase<T> {
  @override
  final FireAdapter<T> adapter = FireRealtimeAdapters.instance.of<T>();

  RealtimeField(
    super.name, {
    required super.receiveData,
    required super.onFetched,
    super.isValid,
    super.shouldCancelAll,
  });
}

class FireRealtimeAdapters extends FireAdapterMap {
  FireRealtimeAdapters();
  static FireRealtimeAdapters instance = FireRealtimeAdapters();
}
