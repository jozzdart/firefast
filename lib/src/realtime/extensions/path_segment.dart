import 'extensions.dart';

extension PathSegmentRealtimeExtensions on PathSegment {
  RealtimeNodePath toRealtimeNode() => RealtimeNodePath.fromPath(this);
}
