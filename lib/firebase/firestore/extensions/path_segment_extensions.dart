import 'package:firefast/firefast_core.dart';
import 'package:firefast/firefast_firestore.dart';

/// Extension on [PathSegment] that provides conversion methods for Firestore path types.
///
/// These extensions simplify the process of converting generic path segments to
/// Firestore-specific document and collection path types.
extension PathSegmentFirestoreExtensions on PathSegment {
  /// Converts this path segment to a [FirestoreDocumentPath].
  ///
  /// This is useful when you have a generic path segment and need to
  /// use functionality specific to document paths.
  ///
  /// Returns a [FirestoreDocumentPath] representing the same path.
  FirestoreDocumentPath toFirestoreDocument() =>
      FirestoreDocumentPath.fromPath(this);

  /// Converts this path segment to a [FirestoreCollectionPath].
  ///
  /// This is useful when you have a generic path segment and need to
  /// use functionality specific to collection paths.
  ///
  /// Returns a [FirestoreCollectionPath] representing the same path.
  FirestoreCollectionPath toFirestoreCollection() =>
      FirestoreCollectionPath.fromPath(this);
}
