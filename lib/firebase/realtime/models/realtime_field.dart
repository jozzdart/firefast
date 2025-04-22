import 'package:firefast/firefast_core.dart';
import 'package:firefast/firefast_realtime.dart';

class RealtimeField<T>
    extends FirePathField<FirefastReal, RealtimeNodePath, T, RealtimeNode> {
  const RealtimeField({
    required super.base,
  });

  factory RealtimeField.fromField({
    required RealtimeNodePath baseNode,
    required FireField field,
  }) =>
      RealtimeField.fromFields(baseNode: baseNode, fields: [field]);

  factory RealtimeField.fromFields({
    required RealtimeNodePath baseNode,
    required List<FireField> fields,
  }) =>
      RealtimeField(
          base: RealtimeNode.fromFields(node: baseNode, fields: fields));

  RealtimeNodePath get nodePath => base.pathSegment;

  RealtimeField copyWith({
    RealtimeNode? baseNode,
  }) {
    return RealtimeField(
      base: baseNode ?? base,
    );
  }
}
