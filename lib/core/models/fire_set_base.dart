abstract class FireSetBase<O> {
  /// Converts all fields to a Firebase-compatible map.
  ///
  /// Returns a [Map] suitable for writing to a Firebase document.
  Future<Map<String, dynamic>?> toMap();

  /// Extracts field values from a Firebase document map.
  ///
  /// Parameters:
  ///   - [map]: Map from a Firebase document
  ///   - [path]: The path segment pointing to this document
  ///
  /// Returns an object of type [T] containing the deserialized field values.
  Future<O?> fromMap(Map<String, dynamic>? map);
}
