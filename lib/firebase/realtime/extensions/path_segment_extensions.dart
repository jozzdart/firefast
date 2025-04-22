import 'package:firefast/firefast_core.dart';
import 'package:firefast/firefast_realtime.dart';

extension PathSegmentRealtimeExtensions on PathSegment {
  RealtimeNodePath toRealtimeNode() => RealtimeNodePath.fromPath(this);
}
