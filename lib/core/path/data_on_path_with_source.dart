import 'package:firefast/firefast_core.dart';

abstract class DataOnPathWithSource<S extends PathBasedDataSource, O>
    implements DataOnPathObject<O> {
  S get datasource;

  const DataOnPathWithSource();
}
