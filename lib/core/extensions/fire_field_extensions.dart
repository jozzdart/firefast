import 'package:firefast/firefast_core.dart';

/// Extensions on [List<FireField>] to provide additional functionality.
extension FireFieldCoreExtensions<P extends PathSegment> on List<FireField> {
  /// Converts a list of [FireField] to a [FireFieldSet].
  ///
  /// This provides a convenient way to transform a collection of fields
  /// into a structured set that can be used for Firebase operations.
  FireFieldSet<P> toFireSet() => FireFieldSet<P>(fields: this);
}
