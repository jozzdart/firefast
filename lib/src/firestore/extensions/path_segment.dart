import 'extensions.dart';

extension PathSegmentFirestoreExtensions on PathSegment {
  FirestoreDocumentPath toFirestoreDocument() =>
      FirestoreDocumentPath.fromPath(this);

  FirestoreCollectionPath toFirestoreCollection() =>
      FirestoreCollectionPath.fromPath(this);
}
