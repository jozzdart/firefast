/// A class that represents a segment in a hierarchical path structure.
///
/// [PathSegment] manages path segments in a tree-like structure where each segment
/// can have a parent segment and child segments. This is particularly useful for
/// building hierarchical database paths.
class PathSegment {
  final String _segment;
  final PathSegment? parent;

  /// Creates a new [PathSegment] with the given segment string.
  ///
  /// Optionally, a [parent] segment can be provided to build a hierarchical path.
  const PathSegment(this._segment, {this.parent});

  /// Returns the current segment string.
  String get segment => _segment;

  /// Returns the full path string including all parent segments.
  ///
  /// Segments are joined using forward slashes (/).
  /// If there is no parent, returns just the current segment.
  String get path {
    if (parent == null) return _segment;
    return '${parent!.path}/$_segment';
  }

  /// Creates a child [PathSegment] with this segment as the parent.
  ///
  /// [childSegment] is the string value of the child segment.
  PathSegment child(String childSegment) =>
      PathSegment(childSegment, parent: this);

  @override
  String toString() => path;
}
