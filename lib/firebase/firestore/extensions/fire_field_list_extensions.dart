import 'package:firefast/firefast_core.dart';
import 'package:firefast/firefast_firestore.dart';

/// Extension on [List<FireField>] that provides helper methods for working with collections of fields.
///
/// These extensions simplify the process of creating documents from collections of fields.
extension FireFieldListExtension on List<FireField> {
  /// Creates a [FirestoreDocument] at the specified document path with this list of fields.
  ///
  /// * [document]: The document path where the fields should be associated.
  ///
  /// Returns a new [FirestoreDocument] with all the fields in the list.
  FirestoreDocument firestore(FirestoreDocumentPath document) =>
      FirestoreDocument.fromFields(document: document, fields: this);

  /// Creates a [FirestoreDocument] at a new document path with this list of fields.
  ///
  /// * [collection]: The name of the collection.
  /// * [documentId]: The ID of the document.
  ///
  /// Returns a new [FirestoreDocument] with all the fields in the list.
  FirestoreDocument firestoreNewDoc(String collection, String documentId) =>
      firestore(FirefastStore.col(collection).doc(documentId));
}
