import 'package:firefast/firefast_core.dart';
import 'package:firefast/firefast_firestore.dart';

/// Extensions on [FirestoreDocument] that provide helper methods for working with document fields.
///
/// These extensions simplify the process of adding and modifying fields within a Firestore document.
extension FirestoreDocumentExtensions on FirestoreDocument {
  /// Creates a new [FirestoreDocument] by combining the current fields with new fields.
  ///
  /// * [newFields]: A list of [FireField] objects to add to the document.
  ///
  /// Returns a new [FirestoreDocument] with all fields included.
  FirestoreDocument withFields(List<FireField> newFields) {
    final currentFields = fieldSet.fields;
    return copyWith(fieldSet: [...currentFields, ...newFields].toFireSet());
  }

  /// Creates a new [FirestoreDocument] with an additional field.
  ///
  /// * [field]: The [FireField] to add to the document.
  ///
  /// Returns a new [FirestoreDocument] with the additional field.
  FirestoreDocument addField(FireField field) {
    final currentFields = fieldSet.fields;
    return copyWith(fieldSet: [...currentFields, field].toFireSet());
  }

  /// Alias for [withFields] that creates a new [FirestoreDocument] with additional fields.
  ///
  /// * [newFields]: A list of [FireField] objects to add to the document.
  ///
  /// Returns a new [FirestoreDocument] with all fields included.
  FirestoreDocument addFields(List<FireField> newFields) =>
      withFields(newFields);

  /// Creates a new [FirestoreDocument] with a newly defined field.
  ///
  /// This method allows specifying the field properties directly rather than
  /// creating a [FireField] separately.
  ///
  /// * [name]: The name of the field to add.
  /// * [toFire]: A delegate function to convert the field value to a Firestore-compatible format.
  /// * [fromFire]: A delegate function to convert the Firestore value back to the desired type.
  ///
  /// Returns a new [FirestoreDocument] with the newly defined field.
  FirestoreDocument addNewField<T>({
    required String name,
    required ToFireDelegate toFire,
    required FromFireDelegate<T> fromFire,
  }) =>
      addField(FireField<T>(name: name, toFire: toFire, fromFire: fromFire));
}
