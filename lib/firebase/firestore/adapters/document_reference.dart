part of 'adapters.dart';

class DocumentReferenceFireAdapter extends FireAdapter<DocumentReference> {
  @override
  Future<dynamic> toFire(DocumentReference? value) async => value;

  @override
  Future<DocumentReference?> fromFire(dynamic value) async =>
      value as DocumentReference;
}
