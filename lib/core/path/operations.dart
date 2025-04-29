/// Defines a path-based write operation interface.
///
/// This interface should be implemented by data sources that support
/// writing data to a specific path. The implementation determines how
/// the path is interpreted and how data is written (e.g., merging with
/// existing data or creating new entries).
///
/// The generic type [D] represents the data model to be written.
abstract class WriteOnPath<D> {
  /// Writes data to the specified path.
  ///
  /// The [path] parameter identifies the location where data should be written.
  /// The [data] parameter contains the data to be written.
  ///
  /// Returns a [Future] that completes when the write operation is finished.
  /// If the write operation fails, the future will complete with an error.
  Future<String?> write(String path, D data);
}

/// Defines a path-based read operation interface.
///
/// This interface should be implemented by data sources that support
/// reading data from a specific path. The implementation determines how
/// the path is interpreted to locate and retrieve the data.
///
/// The generic type [D] represents the data model to be returned.
abstract class ReadOnPath<D> {
  /// Reads data from the specified path.
  ///
  /// The [path] parameter identifies the location of the data to read.
  ///
  /// Returns a [Future] that completes with the data of type [D] if available,
  /// or `null` if no data exists at the specified path.
  /// If the read operation fails, the future will complete with an error.
  Future<D?> read(String path);
}

/// Defines a path-based overwrite operation interface.
///
/// This interface should be implemented by data sources that support
/// overwriting existing data at a specific path. The overwrite operation
/// explicitly replaces any existing data, unlike write which might
/// merge or append depending on the implementation.
///
/// The generic type [D] represents the data model to be written.
abstract class OverwriteOnPath<D> {
  /// Overwrites data at the specified path.
  ///
  /// The [path] parameter identifies the location where data should be overwritten.
  /// The [data] parameter contains the new data that will replace any existing data.
  ///
  /// Returns a [Future] that completes when the overwrite operation is finished.
  /// If the overwrite operation fails, the future will complete with an error.
  Future<String?> overwrite(String path, D data);
}

/// Defines a path-based delete operation interface.
///
/// This interface should be implemented by data sources that support
/// deleting data at a specific path. The implementation determines how
/// the path is interpreted to locate and remove the data.
abstract class DeleteOnPath {
  /// Deletes data at the specified path.
  ///
  /// The [path] parameter identifies the location of the data to delete.
  ///
  /// Returns a [Future] that completes when the delete operation is finished.
  /// If the delete operation fails, the future will complete with an error.
  Future<String?> delete(String path);
}
