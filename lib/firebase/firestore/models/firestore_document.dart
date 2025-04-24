import 'package:firefast/firefast_core.dart';
import 'package:firefast/firefast_firestore.dart';

/// Represents a document within a Firestore collection.
///
/// The [FirestoreDocument] class provides a structured way to interact with
/// Firestore documents, maintaining information about both the document's
/// path in the database and its field data.
///
/// This class extends [FireSetOnPath] with Firestore-specific implementation,
/// providing methods to access document metadata and perform operations.
class FirestoreDocument extends FireSetOnPath<FirefastStore,
    FirestoreDocumentPath, FirestoreDocument> {
  /// Creates a new [FirestoreDocument] instance.
  ///
  /// Requires the document's [path] within the Firestore database and
  /// a [fieldSet] containing the document's fields and their values.
  const FirestoreDocument({
    required super.path,
    required super.fieldSet,
  }) : super(factory: _create);

  static FirestoreDocument _create({
    required FirestoreDocumentPath path,
    required FireSet fieldSet,
  }) =>
      FirestoreDocument(path: path, fieldSet: fieldSet);

  /// Creates a [FirestoreDocument] from a list of [FireFieldBase] objects.
  ///
  /// This factory constructor simplifies creating document instances when
  /// working with individual fields rather than a pre-constructed field set.
  ///
  /// Parameters:
  ///   * [document]: The path to the document in Firestore
  ///   * [fields]: List of fields that belong to this document
  factory FirestoreDocument.fromFields(
          {required FirestoreDocumentPath document,
          required List<FirestoreField> fields}) =>
      FirestoreDocument(path: document, fieldSet: FireSet(fields: fields));

  /// The ID of this document within its collection.
  String get id => pathSegment.segment;

  /// The collection that contains this document.
  FirestoreCollectionPath get collection =>
      pathSegment.parent!.toFirestoreCollection();

  @override
  get datasource => FirefastStore.instance;
}
