import 'package:firefast/firefast_core.dart';

/// An abstract class that handles a collection of fields at a specific database path.
///
/// This class provides operations for working with multiple fields at a given path
/// in a Firebase database. It supports reading, writing, updating, and deleting
/// both entire field sets and individual fields.
///
/// Type parameters:
/// * [S] - The data source type
/// * [P] - The path segment type
abstract class FirePathFields<S extends FastDataPathSource,
        P extends PathSegment>
    extends FireDataPathObjectSource<S, FireFieldsOutput> {
  final P _path;
  final FireFieldSet fieldSet;

  /// Creates a new [FirePathFields] with the given path and field set.
  ///
  /// [path] represents the database location where the fields will be stored.
  /// [fieldSet] contains the collection of fields to manage at this path.
  const FirePathFields({
    required P path,
    required this.fieldSet,
  }) : _path = path;

  /// The string representation of the path.
  String get path => _path.path;

  /// The path segment object.
  P get pathSegment => _path;

  /// The list of fields managed by this object.
  List<FireField> get fields => fieldSet.fields;

  @override

  /// Writes the field values to the database, merging with existing data.
  ///
  /// Converts the field set to a map and writes it to the specified path.
  Future<void> write() async {
    final data = await fieldSet.toMap();
    await datasource.write(path, data);
  }

  @override

  /// Overwrites all data at the path with the current field values.
  ///
  /// Unlike [write], this method replaces all existing data rather than merging.
  Future<void> overwrite() async {
    final data = await fieldSet.toMap();
    await datasource.overwrite(path, data);
  }

  @override

  /// Reads the field values from the database.
  ///
  /// Returns null if the path doesn't exist or if no fields could be populated
  /// from the data at the path.
  Future<FireFieldsOutput?> read() async {
    final rawData = await datasource.read(path);
    if (rawData == null) return null;
    final toMap = await fieldSet.fromMap(rawData, pathSegment);
    if (toMap.fields.isEmpty) return null;
    return toMap;
  }

  @override

  /// Deletes all data at the specified path.
  Future<void> delete() async => await datasource.delete(path);

  /// Deletes specific fields by setting them to null.
  ///
  /// [selectedFields] is the list of fields to delete.
  /// Does nothing if the list is empty.
  Future<void> deleteFields(List<FireField> selectedFields) async {
    final nullifiedData = {
      for (final field in selectedFields) field.name: null,
    };
    if (nullifiedData.isEmpty) return;
    await datasource.write(path, nullifiedData);
  }

  /// Retrieves the value of a specific field.
  ///
  /// [field] is the field whose value to retrieve.
  /// Returns null if the field or path doesn't exist.
  Future<T?> getField<T>(FireField<T> field) async {
    final all = await read();
    return all?.get(field);
  }
}
