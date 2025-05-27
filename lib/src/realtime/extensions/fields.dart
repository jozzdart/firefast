import 'package:firefast/firefast_core.dart';

import '../realtime.dart';

extension FireFieldListRealtimeExtensions on List<FireValue> {
  RealtimeNode realtime(RealtimeNodePath node) =>
      RealtimeNode(path: node, fireValues: this);

  RealtimeNode realtimeNewNode(String node) =>
      realtime(FirefastReal.node(node));
}

extension FireFieldRealtimeExtensions on FireValue {
  RealtimeNode realtime(RealtimeNodePath node) => [this].realtime(node);

  RealtimeNode realtimeNewNode(String node) =>
      realtime(FirefastReal.node(node));
}
