import 'package:firefast/firefast_core.dart';

abstract class OperatablePathObject<S extends PathBasedDataSource,
        P extends PathSegment> extends FireValuesContainer
    implements ReadNoParams, WriteNoParams, OverwriteNoParams, DeleteNoParams {
  final P path;
  final FireGuards fireGuards;

  S get datasource;
  FireAdapterMap get adapters => FireAdapterMap.instance;

  const OperatablePathObject({
    required this.path,
    required super.fireValues,
    this.fireGuards = const FireGuards(),
  });

  List<FireValue> get fields => fireValues;

  @override
  Future<void> write() async =>
      await FireSetPathWrite(fireOperatable: this).tryPerform();

  @override
  Future<void> overwrite() async =>
      await FireSetPathOverwrite(fireOperatable: this).tryPerform();

  @override
  Future<void> read() async =>
      await FireSetPathRead(fireOperatable: this).tryPerform();

  @override
  Future<void> delete() async =>
      await FireSetPathDelete(fireOperatable: this).tryPerform();
}
