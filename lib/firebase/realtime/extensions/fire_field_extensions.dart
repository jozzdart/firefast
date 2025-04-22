import 'package:firefast/firefast_core.dart';
import 'package:firefast/firefast_realtime.dart';

extension FireFieldRealtimeExtensions<T> on FireField<T> {
  RealtimeField<T> realtime(RealtimeNodePath node) =>
      RealtimeField.fromField(baseNode: node, field: this);
}
