import 'package:firefast/firefast_core.dart';

/// An abstract class that connects a [FireDataPathObject] to a data source.
///
/// This class serves as a bridge between path-based data objects and their underlying
/// data sources. It extends [FireDataPathObject] by requiring a datasource property
/// that provides the actual implementation for database operations.
///
/// Type parameters:
/// * [S] - The type of data source (must extend [FastDataPathSource])
/// * [O] - The output type for the data object
abstract class FireDataPathObjectSource<S extends FastDataPathSource, O>
    implements FireDataPathObject<O> {
  /// Returns the data source that this path object uses for database operations.
  S get datasource;

  /// Creates a new [FireDataPathObjectSource].
  const FireDataPathObjectSource();
}
