import 'package:firefast/firefast_core.dart';
import 'package:firefast/firefast_realtime.dart';

class RealtimeNode extends FirePathFields<FirefastReal, RealtimeNodePath> {
  const RealtimeNode({
    required super.path,
    required super.fieldSet,
  });

  RealtimeNodePath get node => pathSegment;

  factory RealtimeNode.fromFields({
    required RealtimeNodePath node,
    required List<FireField> fields,
  }) =>
      RealtimeNode(path: node, fieldSet: fields.toFireSet());

  RealtimeNode copyWith({
    RealtimeNodePath? path,
    FireFieldSet<PathSegment>? fieldSet,
  }) {
    return RealtimeNode(
      path: path ?? pathSegment,
      fieldSet: fieldSet ?? this.fieldSet,
    );
  }

  @override
  FirefastReal get datasource => FirefastReal.instance;
}
