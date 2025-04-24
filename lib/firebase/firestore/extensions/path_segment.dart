import 'package:firefast/firefast_core.dart';
import 'package:firefast/firefast_firestore.dart';

extension PathSegmentFirestoreExtensions on PathSegment {
  FirestoreDocumentPath toFirestoreDocument() =>
      FirestoreDocumentPath.fromPath(this);

  FirestoreCollectionPath toFirestoreCollection() =>
      FirestoreCollectionPath.fromPath(this);
}
