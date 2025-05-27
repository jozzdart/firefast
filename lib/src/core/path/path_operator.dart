import 'path.dart';

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
