import 'package:firefast/firefast_core.dart';

/// Represents a path to a Firestore collection.
///
/// This class provides a structured way to represent and manipulate Firestore
/// collection paths. It encapsulates the collection name and its position in the
/// Firestore hierarchy, including any potential parent documents or collections.
///
/// Extends [PathSegment] to incorporate path navigation and manipulation methods.
class FirestoreCollectionPath extends PathSegment {
  /// Creates a new [FirestoreCollectionPath] instance.
  ///
  /// Parameters:
  ///   * [collection]: The name of the collection
  ///   * [parent]: Optional parent path segment (for subcollections)
  const FirestoreCollectionPath(super.collection, {super.parent});

  /// Creates a [FirestoreCollectionPath] from an existing [PathSegment].
  ///
  /// This factory constructor allows converting a generic path segment
  /// into a Firestore-specific collection path.
  ///
  /// Parameters:
  ///   * [pathSegment]: The source path segment to convert
  factory FirestoreCollectionPath.fromPath(PathSegment pathSegment) =>
      FirestoreCollectionPath(pathSegment.segment, parent: pathSegment.parent);
}
