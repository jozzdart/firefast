import 'package:firebase_database/firebase_database.dart';
import 'package:firefast/firefast_core.dart';
import 'package:firefast/firefast_realtime.dart';

class FirefastReal
    extends PathBasedDataSource<Map<String, dynamic>, FirebaseDatabase> {
  static FirefastReal? _instance;

  /// Get the singleton instance, or create it if it doesn't exist
  static FirefastReal get instance =>
      _instance ?? (_instance = FirefastReal(FirebaseDatabase.instance));

  static void overrideInstance(FirefastReal customServices) {
    _instance = customServices;
  }

  static void resetInstance() {
    _instance = null;
  }

  FirefastReal(super.datasource);

  @override
  Future<void> write(String path, Map<String, dynamic> data) async {
    await datasource.ref(path).update(data);
  }

  @override
  Future<void> overwrite(String path, Map<String, dynamic> data) async {
    await datasource.ref(path).set(data);
  }

  @override
  Future<Map<String, dynamic>?> read(String path) async {
    final snapshot = await datasource.ref(path).get();
    final value = snapshot.value;
    if (value == null) return null;

    if (value is Map<Object?, Object?>) {
      return value.map(
        (key, val) => MapEntry(key.toString(), val),
      );
    }

    return null;
  }

  @override
  Future<void> delete(String path) async {
    await datasource.ref(path).remove();
  }

  static RealtimeNodePath node(String node) =>
      RealtimeNodePath(node, parent: null);
}
