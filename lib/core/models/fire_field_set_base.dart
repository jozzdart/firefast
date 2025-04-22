import 'package:firefast/firefast_core.dart';

/// Base interface for sets of fields in a Firebase document.
///
/// This abstract class defines the contract for classes that manage
/// collections of fields in a Firebase document, handling serialization
/// and deserialization operations.
///
/// Type parameters:
///   - [T]: The output type after deserialization
///   - [P]: The path segment type representing the document location
abstract class FireFieldSetBase<T, P extends PathSegment> {
  /// Converts all fields to a Firebase-compatible map.
  ///
  /// Returns a [Map] suitable for writing to a Firebase document.
  Future<Map<String, dynamic>> toMap();

  /// Extracts field values from a Firebase document map.
  ///
  /// Parameters:
  ///   - [map]: Map from a Firebase document
  ///   - [path]: The path segment pointing to this document
  ///
  /// Returns an object of type [T] containing the deserialized field values.
  Future<T> fromMap(Map<String, dynamic> map, P path);
}
