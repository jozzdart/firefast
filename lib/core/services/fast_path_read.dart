/// Defines a path-based read operation interface.
///
/// This interface should be implemented by data sources that support
/// reading data from a specific path. The implementation determines how
/// the path is interpreted to locate and retrieve the data.
///
/// The generic type [D] represents the data model to be returned.
abstract class FastPathRead<D> {
  /// Reads data from the specified path.
  ///
  /// The [path] parameter identifies the location of the data to read.
  ///
  /// Returns a [Future] that completes with the data of type [D] if available,
  /// or `null` if no data exists at the specified path.
  /// If the read operation fails, the future will complete with an error.
  Future<D?> read(String path);
}
