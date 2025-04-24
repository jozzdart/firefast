part of 'adapters.dart';

class RealtimeListAdapters<T> extends ListFireAdapter<T> {
  @override
  FireAdapter<T> itemAdapter = RealtimeAdapters.instance.of<T>();
}
