/// Defines a path-based delete operation interface.
///
/// This interface should be implemented by data sources that support
/// deleting data at a specific path. The implementation determines how
/// the path is interpreted to locate and remove the data.
abstract class FastPathDelete {
  /// Deletes data at the specified path.
  ///
  /// The [path] parameter identifies the location of the data to delete.
  ///
  /// Returns a [Future] that completes when the delete operation is finished.
  /// If the delete operation fails, the future will complete with an error.
  Future<void> delete(String path);
}
