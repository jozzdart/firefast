/// A Dart library that provides a simplified, type-safe API for Firebase Firestore.
///
/// The Firefast Firestore library offers an enhanced developer experience when working with
/// Firestore by providing:
///
/// * **Type-safe data access**: Strong typing for Firestore documents and fields
/// * **Path management**: Convenient handling of collection and document paths
/// * **Fluent API**: Chain-friendly methods for building complex operations
/// * **Extension methods**: Utilities that extend Firestore functionality
/// * **Simplified CRUD operations**: Streamlined data reading and writing
///
/// ## Key Components
///
/// ### Services
/// * [FirefastStore]: Core service providing CRUD operations for Firestore documents
///
/// ### Models
/// * [FirestoreDocument]: Represents a Firestore document with typed fields
/// * [FirestoreDocumentPath]: Represents a path to a Firestore document
/// * [FirestoreCollectionPath]: Represents a path to a Firestore collection
/// * [FirestoreField]: Represents a typed field within a Firestore document
///
/// ### Extensions
/// * Document extensions: Methods for manipulating Firestore documents
/// * Path extensions: Utilities for working with document and collection paths
/// * Field extensions: Helpers for working with Firestore fields
///
/// ## Usage Example
///
/// ```dart
/// // Access Firestore through the FirefastStore
/// final db = FirefastStore.instance;
///
/// // Create paths to collections and documents
/// final usersCol = FirefastStore.col('users');
/// final userDoc = usersCol.doc('user123');
///
/// // Create a document with typed fields
/// final user = userDoc.withFields([
///   FireField<String>(
///     name: 'name',
///     toFire: (value) => getData(),
///     fromFire: (value) => value as String,
///   ),
///   FireField<int>(
///     name: 'age',
///     toFire: (value) => getData(),
///     fromFire: (value) => value as int,
///   ),
/// ]);
///
/// // Write to Firestore
/// await user.write();
/// ```
library;

export 'firebase/firestore/extensions/collection_path_extensions.dart';
export 'firebase/firestore/extensions/document_path_extensions.dart';
export 'firebase/firestore/extensions/fire_field_extension.dart';
export 'firebase/firestore/extensions/fire_field_list_extensions.dart';
export 'firebase/firestore/extensions/firestore_document_extensions.dart';
export 'firebase/firestore/extensions/path_segment_extensions.dart';
export 'firebase/firestore/models/firestore_collection_path.dart';
export 'firebase/firestore/models/firestore_document.dart';
export 'firebase/firestore/models/firestore_document_output.dart';
export 'firebase/firestore/models/firestore_document_path.dart';
export 'firebase/firestore/models/firestore_field.dart';
export 'firebase/firestore/services/firefast_store.dart';
