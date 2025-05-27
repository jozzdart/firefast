import 'models.dart';

class FirestoreCollectionPath extends PathSegment {
  const FirestoreCollectionPath(super.collection, {super.parent});

  factory FirestoreCollectionPath.fromPath(PathSegment pathSegment) =>
      FirestoreCollectionPath(pathSegment.segment, parent: pathSegment.parent);
}

class FirestoreDocumentPath extends PathSegment {
  const FirestoreDocumentPath(
      super.document, FirestoreCollectionPath collection)
      : super(parent: collection);

  factory FirestoreDocumentPath.fromPath(PathSegment pathSegment) {
    if (pathSegment.parent == null) {
      throw ArgumentError('Document paths must have a collection parent');
    }
    return FirestoreDocumentPath(pathSegment.segment,
        FirestoreCollectionPath.fromPath(pathSegment.parent!));
  }
}
