import 'package:firefast/firefast_core.dart';

import '../firestore.dart';

/// Represents a document within a Firestore collection.
///
/// The [FirestoreDocument] class provides a structured way to interact with
/// Firestore documents, maintaining information about both the document's
/// path in the database and its field data.
///
/// This class extends [OperatablePathObject] with Firestore-specific implementation,
/// providing methods to access document metadata and perform operations.
class FirestoreDocument
    extends OperatablePathObject<FirefastStore, FirestoreDocumentPath> {
  /// Creates a new [FirestoreDocument] instance.
  ///
  /// Requires the document's [path] within the Firestore database and
  /// a [fieldSet] containing the document's fields and their values.
  FirestoreDocument({
    required super.path,
    required super.fireValues,
    super.fireGuards,
  });

  /// The ID of this document within its collection.
  String get id => path.segment;

  /// The collection that contains this document.
  FirestoreCollectionPath get collection =>
      path.parent!.toFirestoreCollection();

  @override
  get datasource => FirefastStore.instance;

  @override
  FireAdapterMap get adapters => FirestoreAdapters.instance;
}
