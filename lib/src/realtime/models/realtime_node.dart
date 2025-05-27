import 'models.dart';

class RealtimeNode
    extends OperatablePathObject<FirefastReal, RealtimeNodePath> {
  const RealtimeNode({
    required super.path,
    required super.fireValues,
    super.fireGuards,
  });

  RealtimeNodePath get node => path;

  @override
  FirefastReal get datasource => FirefastReal.instance;
}
