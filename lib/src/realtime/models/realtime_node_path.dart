import 'models.dart';

class RealtimeNodePath extends PathSegment {
  const RealtimeNodePath(super.node, {required super.parent});

  factory RealtimeNodePath.fromPath(PathSegment pathSegment) {
    return RealtimeNodePath(pathSegment.segment, parent: pathSegment.parent);
  }

  RealtimeNodePath node(String node) => RealtimeNodePath.fromPath(child(node));
}
