import 'package:firefast/firefast_core.dart';
import 'package:firefast/firefast_firestore.dart';

class FirestoreField<T> extends FireFieldBase<T> {
  @override
  final FireAdapter<T> adapter = FirestoreAdapters.instance.of<T>();

  FirestoreField(
    super.name, {
    required super.receiveData,
    required super.onFetched,
    super.isValid,
    super.shouldCancelAll,
  });
}
