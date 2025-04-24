part of 'adapters.dart';

class FirestoreListAdapters<T> extends ListFireAdapter<T> {
  @override
  FireAdapter<T> itemAdapter = FirestoreAdapters.instance.of<T>();
}
