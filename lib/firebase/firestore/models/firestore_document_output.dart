import 'package:firefast/firefast_core.dart';
import 'package:firefast/firefast_firestore.dart';

/// Represents the output of a Firestore document operation.
///
/// This class encapsulates the data returned when reading from or writing to
/// a Firestore document. It includes information about both the document's path
/// and its field values.
///
/// Extends [FireFieldsOutput] to provide Firestore-specific functionality
/// for handling document data.
class FirestoreDocumentOutput extends FireFieldsOutput<FirestoreDocumentPath> {
  /// Creates a new [FirestoreDocumentOutput] instance.
  ///
  /// Parameters:
  ///   * [source]: The path to the Firestore document
  ///   * [fields]: The field values associated with the document
  FirestoreDocumentOutput({required super.source, required super.fields});
}
