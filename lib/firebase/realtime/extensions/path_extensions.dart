import 'package:firefast/firefast_core.dart';
import 'package:firefast/firefast_realtime.dart';

extension RealtimeNodePathExtensions on RealtimeNodePath {
  RealtimeField field<T>(FireField<T> field) {
    return RealtimeField.fromField(baseNode: this, field: field);
  }

  RealtimeNode withFields<T>(List<FireField> fields) {
    return RealtimeNode.fromFields(node: this, fields: fields);
  }

  RealtimeField newField<T>({
    required String name,
    required ToFireDelegate toFire,
    required FromFireDelegate<T> fromFire,
  }) =>
      field<T>(FireField<T>(name: name, toFire: toFire, fromFire: fromFire));
}
