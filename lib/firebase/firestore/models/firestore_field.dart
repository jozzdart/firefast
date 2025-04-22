import 'package:firefast/firefast_core.dart';
import 'package:firefast/firefast_firestore.dart';

/// Represents a single field within a Firestore document.
///
/// This class provides a type-safe way to reference and interact with
/// individual fields in a Firestore document. It maintains a connection
/// to its parent document and the specific field definition.
///
/// The generic type [T] represents the data type of the field's value.
class FirestoreField<T> extends FirePathField<FirefastStore,
    FirestoreDocumentPath, T, FirestoreDocument> {
  /// Creates a new [FirestoreField] instance.
  ///
  /// Parameters:
  ///   * [document]: Path to the Firestore document containing this field
  ///   * [field]: Definition of the field including name, data type, and validations
  FirestoreField({
    required FirestoreDocumentPath document,
    required FireField field,
  }) : super(
          base:
              FirestoreDocument.fromFields(document: document, fields: [field]),
        );

  /// The document path that contains this field.
  FirestoreDocumentPath get document => base.pathSegment;
}
