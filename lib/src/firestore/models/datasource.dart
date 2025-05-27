import 'package:cloud_firestore/cloud_firestore.dart';

import 'models.dart';

/// A service class that provides simplified access to Firestore operations.
///
/// [FirefastStore] extends [PathBasedDataSource] to provide CRUD operations
/// for Firestore documents, using the singleton pattern for global access.
/// This class acts as a wrapper around [FirebaseFirestore] to provide a more
/// convenient API for working with Firestore data.
class FirefastStore extends PathBasedDataSource<FirebaseFirestore> {
  static FirefastStore? _instance;

  /// Gets the singleton instance of [FirefastStore].
  ///
  /// If the instance doesn't exist, it creates one using the default
  /// [FirebaseFirestore] instance.
  ///
  /// Returns a [FirefastStore] instance.
  static FirefastStore get instance =>
      _instance ?? (_instance = FirefastStore(FirebaseFirestore.instance));

  /// Overrides the default singleton instance with a custom implementation.
  ///
  /// This is particularly useful for testing where you might want to inject
  /// a mock or fake implementation.
  ///
  /// * [customServices]: The custom [FirefastStore] instance to use.
  static void overrideInstance(FirefastStore customServices) {
    _instance = customServices;
  }

  /// Resets the singleton instance to null.
  ///
  /// The next call to [instance] will create a new instance.
  static void resetInstance() {
    _instance = null;
  }

  /// Creates a new [FirefastStore] instance with the provided [FirebaseFirestore].
  FirefastStore(super.datasource);

  /// Writes data to a Firestore document at the specified path.
  ///
  /// This method performs a merge operation, preserving any existing fields
  /// in the document that aren't explicitly overwritten.
  ///
  /// * [path]: The path to the document.
  /// * [data]: The data to write to the document.
  @override
  Future<String?> write(String path, Map<String, dynamic> data) async {
    try {
      await datasource.doc(path).set(data, SetOptions(merge: true));
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  /// Overwrites a Firestore document with the provided data.
  ///
  /// This method replaces the entire document with the provided data,
  /// removing any existing fields not included in the new data.
  ///
  /// * [path]: The path to the document.
  /// * [data]: The data to replace the document with.
  @override
  Future<String?> overwrite(String path, Map<String, dynamic> data) async {
    try {
      await datasource.doc(path).set(data, SetOptions(merge: false));
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  /// Reads a Firestore document at the specified path.
  ///
  /// * [path]: The path to the document.
  ///
  /// Returns a [Future] containing the document data as a [Map],
  /// or `null` if the document doesn't exist.
  @override
  Future<Map<String, dynamic>?> read(String path) async {
    final snapshot = await datasource.doc(path).get();
    return snapshot.data();
  }

  /// Deletes a Firestore document at the specified path.
  ///
  /// * [path]: The path to the document to delete.
  @override
  Future<String?> delete(String path) async {
    try {
      await datasource.doc(path).delete();
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  /// Creates a [FirestoreCollectionPath] for the specified collection.
  ///
  /// This is a convenience method for starting a path to a collection.
  ///
  /// * [collection]: The name of the collection.
  ///
  /// Returns a [FirestoreCollectionPath] for the specified collection.
  static FirestoreCollectionPath col(String collection) =>
      FirestoreCollectionPath(collection);
}
