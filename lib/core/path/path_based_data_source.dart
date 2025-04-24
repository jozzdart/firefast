import 'package:firefast/firefast_core.dart';

/// Base abstract class for data source operations with path-based access.
///
/// This class serves as a foundation for implementing data sources that support
/// the standard CRUD operations (Create, Read, Update, Delete) via paths.
///
/// The generic type [D] represents the data model being operated on.
/// The generic type [S] represents the underlying data source implementation.
///
/// Implementations of this class should handle the specific data source interactions
/// while adhering to the path-based operation interfaces.
abstract class PathBasedDataSource<D, S>
    implements ReadOnPath<D>, WriteOnPath<D>, OverwriteOnPath<D>, DeleteOnPath {
  /// The underlying data source instance.
  final S datasource;

  /// Creates a new instance with the specified data source.
  ///
  /// The [datasource] parameter should be an instance of the underlying
  /// data source technology (e.g., a database connection, API client, etc.)
  const PathBasedDataSource(this.datasource);
}
