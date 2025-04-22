import 'package:firefast/firefast_core.dart';

/// An abstract class that represents a single field at a specific database path.
///
/// This class provides operations for interacting with a single field in a Firebase
/// database. It works with a [FirePathFields] instance as its base and focuses
/// operations on a single field within that collection of fields.
///
/// Type parameters:
/// * [S] - The data source type
/// * [P] - The path segment type
/// * [T] - The field value type
/// * [F] - The type of the fields collection
abstract class FirePathField<
    S extends FastDataPathSource,
    P extends PathSegment,
    T,
    F extends FirePathFields<S, P>> implements FireDataPathObject<T> {
  /// The base fields collection that contains this field.
  final F base;

  /// Creates a new [FirePathField] with the given base fields collection.
  const FirePathField({required this.base});

  @override

  /// Deletes this field by setting it to null.
  ///
  /// Only performs the operation if there is exactly one field in the base collection.
  Future<void> delete() async {
    if (base.fields.length != 1) return;
    final toDelete = base.fields.first;
    await base.deleteFields([toDelete]);
  }

  @override

  /// Overwrites this field's value.
  ///
  /// Delegates to [write] since the behavior is the same for a single field.
  Future<void> overwrite() async => await write();

  @override

  /// Reads the value of this field from the database.
  ///
  /// Returns null if there are multiple fields in the base collection
  /// or if the field doesn't exist in the database.
  Future<T?> read() async {
    if (base.fields.length != 1) return null;
    final output = await base.read();
    if (output == null) return null;
    final FireField<T> first = base.fields.first as FireField<T>;
    final data = output.get(first);
    return data;
  }

  @override

  /// Writes this field's value to the database.
  ///
  /// Delegates to the base fields collection's write method.
  Future<void> write() async => await base.write();
}
