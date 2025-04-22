/// Defines a path-based write operation interface.
///
/// This interface should be implemented by data sources that support
/// writing data to a specific path. The implementation determines how
/// the path is interpreted and how data is written (e.g., merging with
/// existing data or creating new entries).
///
/// The generic type [D] represents the data model to be written.
abstract class FastPathWrite<D> {
  /// Writes data to the specified path.
  ///
  /// The [path] parameter identifies the location where data should be written.
  /// The [data] parameter contains the data to be written.
  ///
  /// Returns a [Future] that completes when the write operation is finished.
  /// If the write operation fails, the future will complete with an error.
  Future<void> write(String path, D data);
}
