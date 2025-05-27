import 'operations.dart';

abstract class PathBasedDataSource<S>
    implements
        ReadOnPath<Map<String, dynamic>>,
        WriteOnPath<Map<String, dynamic>>,
        OverwriteOnPath<Map<String, dynamic>>,
        DeleteOnPath {
  final S datasource;
  const PathBasedDataSource(this.datasource);
}
