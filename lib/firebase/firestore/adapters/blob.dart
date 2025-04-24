part of 'adapters.dart';

class BlobFireAdapter extends FireAdapter<Uint8List> {
  @override
  Future<dynamic> toFire(Uint8List? value) async =>
      (value == null) ? null : Blob(value);

  @override
  Future<Uint8List?> fromFire(dynamic value) async =>
      (value == null) ? null : (value as Blob).bytes;
}
