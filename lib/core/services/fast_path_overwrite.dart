/// Defines a path-based overwrite operation interface.
///
/// This interface should be implemented by data sources that support
/// overwriting existing data at a specific path. The overwrite operation
/// explicitly replaces any existing data, unlike write which might
/// merge or append depending on the implementation.
///
/// The generic type [D] represents the data model to be written.
abstract class FastPathOverwrite<D> {
  /// Overwrites data at the specified path.
  ///
  /// The [path] parameter identifies the location where data should be overwritten.
  /// The [data] parameter contains the new data that will replace any existing data.
  ///
  /// Returns a [Future] that completes when the overwrite operation is finished.
  /// If the overwrite operation fails, the future will complete with an error.
  Future<void> overwrite(String path, D data);
}
