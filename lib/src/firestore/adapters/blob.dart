import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'adapters.dart';

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
