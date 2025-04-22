import 'package:firefast/firefast_core.dart';
import 'package:firefast/firefast_firestore.dart';

/// Represents a path to a Firestore document.
///
/// This class provides a structured way to represent and manipulate Firestore
/// document paths. It encapsulates the document ID and its parent collection,
/// ensuring that all document paths maintain the proper Firestore hierarchical
/// structure.
///
/// Extends [PathSegment] to inherit path navigation and manipulation capabilities.
class FirestoreDocumentPath extends PathSegment {
  /// Creates a new [FirestoreDocumentPath] instance.
  ///
  /// Parameters:
  ///   * [document]: The document ID
  ///   * [collection]: The parent collection containing this document
  const FirestoreDocumentPath(
      super.document, FirestoreCollectionPath collection)
      : super(parent: collection);

  /// Creates a [FirestoreDocumentPath] from an existing [PathSegment].
  ///
  /// This factory constructor converts a generic path segment into a
  /// Firestore-specific document path, with validation to ensure the
  /// path has a proper parent collection.
  ///
  /// Parameters:
  ///   * [pathSegment]: The source path segment to convert
  ///
  /// Throws an [ArgumentError] if the path segment doesn't have a parent,
  /// as all document paths must have a parent collection.
  factory FirestoreDocumentPath.fromPath(PathSegment pathSegment) {
    if (pathSegment.parent == null) {
      throw ArgumentError('Document paths must have a collection parent');
    }
    return FirestoreDocumentPath(pathSegment.segment,
        FirestoreCollectionPath.fromPath(pathSegment.parent!));
  }
}
