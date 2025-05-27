import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firefast/firefast_core.dart';

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

class BlobFireAdapter extends FireAdapter<Uint8List> {
  @override
  Future<dynamic> toFire(Uint8List? value) async =>
      (value == null) ? null : Blob(value);

  @override
  Future<Uint8List?> fromFire(dynamic value) async {
    if (value == null) {
      return null;
    } else if (value is Blob) {
      return value.bytes;
    } else if (value is List) {
      // Convert List<dynamic> → Uint8List (safe for iOS)
      return Uint8List.fromList(value.cast<int>());
    } else {
      throw Exception(
          'BlobFireAdapter.fromFire: Unsupported type ${value.runtimeType}');
    }
  }
}

class TimestampFireAdapter extends FireAdapter<DateTime> {
  @override
  Future<dynamic> toFire(DateTime? value) async =>
      (value == null) ? null : Timestamp.fromDate(value);

  @override
  Future<DateTime?> fromFire(dynamic value) async =>
      (value == null) ? null : (value as Timestamp).toDate();
}

class GeoPointFireAdapter extends FireAdapter<GeoPoint> {
  @override
  Future<dynamic> toFire(GeoPoint? value) async => value;

  @override
  Future<GeoPoint?> fromFire(dynamic value) async => value as GeoPoint;
}

class DocumentReferenceFireAdapter extends FireAdapter<DocumentReference> {
  @override
  Future<dynamic> toFire(DocumentReference? value) async => value;

  @override
  Future<DocumentReference?> fromFire(dynamic value) async =>
      value as DocumentReference;
}
