import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firefast/firefast_core.dart';

part 'blob.dart';
part 'document_reference.dart';
part 'geo_point.dart';
part 'timestamp.dart';
part 'list.dart';

class FirestoreAdapters extends FireAdapterMap {
  FirestoreAdapters();
  static FirestoreAdapters instance = FirestoreAdapters();

  @override
  void registerAll() {
    if (registered) return;
    super.registerAll();
    register<Uint8List>(BlobFireAdapter());
    register<DateTime>(TimestampFireAdapter());
    register<GeoPoint>(GeoPointFireAdapter());
    register<DocumentReference>(DocumentReferenceFireAdapter());
    super.registerAdapters();
    registerListAdapters();
  }

  void registerListAdapters() {
    register<List<bool?>>(FirestoreListAdapters<bool>());
    register<List<int?>>(FirestoreListAdapters<int>());
    register<List<double?>>(FirestoreListAdapters<double>());
    register<List<String?>>(FirestoreListAdapters<String>());
    register<List<Uint8List?>>(FirestoreListAdapters<Uint8List>());
    register<List<DateTime?>>(FirestoreListAdapters<DateTime>());
  }
}
