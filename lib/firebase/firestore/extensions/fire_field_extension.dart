import 'package:firefast/firefast_core.dart';
import 'package:firefast/firefast_firestore.dart';

/// Extension on [FireField] that provides helper methods for working with individual fields.
///
/// These extensions simplify the process of creating [FirestoreField] instances from [FireField] objects.
extension FireFieldExtension<T> on FireField<T> {
  /// Creates a [FirestoreField] by associating this field with a document path.
  ///
  /// * [document]: The document path where this field should be associated.
  ///
  /// Returns a [FirestoreField] that links the field to the specified document path.
  FirestoreField<T> firestore(FirestoreDocumentPath document) =>
      FirestoreField<T>(document: document, field: this);

  /// Creates a [FirestoreField] by associating this field with a new document path.
  ///
  /// * [collection]: The name of the collection.
  /// * [documentId]: The ID of the document.
  ///
  /// Returns a [FirestoreField] that links the field to the new document path.
  FirestoreField<T> firestoreNewDoc(String collection, String documentId) =>
      firestore(FirefastStore.col(collection).doc(documentId));
}
