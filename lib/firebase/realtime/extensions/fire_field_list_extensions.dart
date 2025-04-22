import 'package:firefast/firefast_core.dart';
import 'package:firefast/firefast_realtime.dart';

extension FireFieldRealtimeExtensions on List<FireField> {
  RealtimeNode realtime(RealtimeNodePath node) =>
      RealtimeNode.fromFields(node: node, fields: this);

  RealtimeNode realtimeNewNode(String node) =>
      realtime(FirefastReal.node(node));
}
