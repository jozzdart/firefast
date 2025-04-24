import 'package:firefast/firefast_core.dart';
import 'package:firefast/firefast_realtime.dart';

class RealtimeNode
    extends FireSetOnPath<FirefastReal, RealtimeNodePath, RealtimeNode> {
  const RealtimeNode({
    required super.path,
    required super.fieldSet,
  }) : super(factory: _create);

  static RealtimeNode _create({
    required RealtimeNodePath path,
    required FireSet fieldSet,
  }) =>
      RealtimeNode(path: path, fieldSet: fieldSet);

  RealtimeNodePath get node => pathSegment;

  factory RealtimeNode.fromFields({
    required RealtimeNodePath node,
    required List<RealtimeField> fields,
  }) =>
      RealtimeNode(path: node, fieldSet: FireSet(fields: fields));

  @override
  FirefastReal get datasource => FirefastReal.instance;
}
