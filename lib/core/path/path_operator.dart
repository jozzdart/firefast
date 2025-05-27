import '../adapters/adapters.dart';
import '../guards/guards.dart';
import '../fire_value/fire_value_object.dart';

import 'data_source.dart';
import 'path_segment.dart';
import 'operatable_object.dart';

abstract class FireObjectPathOperator<T> extends FireGuardedOperator<T> {
  final OperatablePathObject fireOperatable;
  @override
  List<FireValue> get fireValues => fireOperatable.fireValues;
  PathBasedDataSource get datasource => fireOperatable.datasource;
  PathSegment get path => fireOperatable.path;
  FireAdapterMap get adapters => fireOperatable.adapters;

  const FireObjectPathOperator({
    required this.fireOperatable,
  });
}
