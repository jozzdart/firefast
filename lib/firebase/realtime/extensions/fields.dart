import 'package:firefast/firefast_realtime.dart';

extension FireFieldListRealtimeExtensions on List<RealtimeField> {
  RealtimeNode realtime(RealtimeNodePath node) =>
      RealtimeNode.fromFields(node: node, fields: this);

  RealtimeNode realtimeNewNode(String node) =>
      realtime(FirefastReal.node(node));
}

extension FireFieldRealtimeExtensions on RealtimeField {
  RealtimeNode realtime(RealtimeNodePath node) => [this].realtime(node);

  RealtimeNode realtimeNewNode(String node) =>
      realtime(FirefastReal.node(node));
}
