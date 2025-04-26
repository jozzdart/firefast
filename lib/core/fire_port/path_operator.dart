import 'package:firefast/firefast_core.dart';

abstract class FireObjectPathOperator extends FireGuardedOperator {
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
