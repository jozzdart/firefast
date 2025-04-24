import 'package:firefast/firefast_realtime.dart';

extension RealtimeNodePathExtensions on RealtimeNodePath {
  RealtimeNode withFields(List<RealtimeField> fields) {
    return RealtimeNode.fromFields(node: this, fields: fields);
  }

  RealtimeNode withField(RealtimeField field) => withFields([field]);

  RealtimeNode addField(RealtimeField field) => withField(field);

  RealtimeNode addFields(List<RealtimeField> fields) => withFields(fields);
}
