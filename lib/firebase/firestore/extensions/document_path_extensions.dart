import 'package:firefast/firefast_core.dart';
import 'package:firefast/firefast_firestore.dart';

/// Extensions on [FirestoreDocumentPath] that provide convenience methods for working with documents.
///
/// These extensions simplify the process of navigating, creating, and manipulating Firestore documents.
extension DocumentExtensions on FirestoreDocumentPath {
  /// Creates a [FirestoreCollectionPath] for a subcollection of this document.
  ///
  /// * [collection]: The name of the subcollection.
  ///
  /// Returns a [FirestoreCollectionPath] pointing to the specified subcollection.
  FirestoreCollectionPath col(String collection) =>
      child(collection).toFirestoreCollection();

  /// Creates a [FirestoreDocument] with the specified fields.
  ///
  /// * [fields]: A list of [FireField] objects to include in the document.
  ///
  /// Returns a new [FirestoreDocument] with the specified fields.
  FirestoreDocument withFields(List<FireField> fields) {
    return FirestoreDocument.fromFields(document: this, fields: fields);
  }

  /// Creates a [FirestoreDocument] with a single field.
  ///
  /// * [field]: The [FireField] to include in the document.
  ///
  /// Returns a new [FirestoreDocument] with the specified field.
  FirestoreDocument withField(FireField field) {
    return FirestoreDocument.fromFields(document: this, fields: [field]);
  }

  /// Alias for [withField] that creates a [FirestoreDocument] with a single field.
  ///
  /// * [field]: The [FireField] to include in the document.
  ///
  /// Returns a new [FirestoreDocument] with the specified field.
  FirestoreDocument addField(FireField field) => withField(field);

  /// Alias for [withFields] that creates a [FirestoreDocument] with multiple fields.
  ///
  /// * [fields]: A list of [FireField] objects to include in the document.
  ///
  /// Returns a new [FirestoreDocument] with the specified fields.
  FirestoreDocument addFields(List<FireField> fields) => withFields(fields);

  /// Creates a [FirestoreDocument] with a newly defined field.
  ///
  /// * [name]: The name of the field.
  /// * [toFire]: A delegate function to convert the field value to a Firestore-compatible format.
  /// * [fromFire]: A delegate function to convert the Firestore value back to the desired type.
  ///
  /// Returns a new [FirestoreDocument] with the newly defined field.
  FirestoreDocument addNewField<T>({
    required String name,
    required ToFireDelegate toFire,
    required FromFireDelegate<T> fromFire,
  }) =>
      withField(FireField<T>(name: name, toFire: toFire, fromFire: fromFire));

  /// Creates a [FirestoreField] from a [FireField].
  ///
  /// * [field]: The [FireField] to associate with this document path.
  ///
  /// Returns a [FirestoreField] that links the field to this document path.
  FirestoreField<T> toField<T>(FireField<T> field) {
    return FirestoreField<T>(document: this, field: field);
  }

  /// Creates a new [FirestoreField] with the specified properties.
  ///
  /// * [name]: The name of the field.
  /// * [toFire]: A delegate function to convert the field value to a Firestore-compatible format.
  /// * [fromFire]: A delegate function to convert the Firestore value back to the desired type.
  ///
  /// Returns a [FirestoreField] associated with this document path.
  FirestoreField<T> createField<T>({
    required String name,
    required ToFireDelegate toFire,
    required FromFireDelegate<T> fromFire,
  }) =>
      toField(FireField<T>(name: name, toFire: toFire, fromFire: fromFire));

  /// Creates a [FirestoreDocumentPath] for a document in a subcollection.
  ///
  /// * [collection]: The name of the subcollection.
  /// * [docId]: The ID of the document in the subcollection.
  ///
  /// Returns a [FirestoreDocumentPath] pointing to the specified document in the subcollection.
  FirestoreDocumentPath sub(String collection, String docId) =>
      FirestoreDocumentPath(
          docId, parent!.toFirestoreCollection().doc(segment).col(collection));
}
