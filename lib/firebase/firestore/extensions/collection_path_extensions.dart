import 'package:firefast/firefast_firestore.dart';

/// Extension on [FirestoreCollectionPath] that provides methods for working with documents in collections.
///
/// These extensions simplify the process of navigating from collections to documents.
extension CollectionPathExtensions on FirestoreCollectionPath {
  /// Creates a [FirestoreDocumentPath] for a document in this collection.
  ///
  /// * [documentId]: The ID of the document in the collection.
  ///
  /// Returns a [FirestoreDocumentPath] pointing to the specified document.
  FirestoreDocumentPath doc(String documentId) =>
      child(documentId).toFirestoreDocument();
}
