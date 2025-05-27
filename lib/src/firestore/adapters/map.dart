import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'adapters.dart';

class FirestoreAdapters extends FireAdapterMap {
  FirestoreAdapters();
  static FirestoreAdapters instance = FirestoreAdapters();

  @override
  void registerAdapters() {
    register<Uint8List>(BlobFireAdapter());
    register<DateTime>(TimestampFireAdapter());
    register<GeoPoint>(GeoPointFireAdapter());
    register<DocumentReference>(DocumentReferenceFireAdapter());
    super.registerAdapters();
  }
}
