import 'package:firefast/firefast_core.dart';

/// A collection of [FireField] instances that can be serialized as a group.
///
/// [FireFieldSet] manages a set of fields that can be converted to and from
/// Firebase document format. It implements the [FireFieldSetBase] interface.
///
/// Type parameter [P] represents the path segment type for this field set.
///
/// Example:
/// ```dart
/// final userFields = FireFieldSet<UserPath>(
///   fields: [
///     nameField,
///     ageField,
///     emailField,
///   ],
/// );
///
/// // Convert to Firebase map
/// final data = await userFields.toMap();
/// ```
class FireFieldSet<P extends PathSegment>
    implements FireFieldSetBase<FireFieldsOutput<P>, P> {
  /// The list of fields contained in this set.
  final List<FireField> fields;

  /// Creates a new [FireFieldSet] with the provided [fields].
  const FireFieldSet({required this.fields});

  /// Converts all fields to a Firebase-compatible map.
  ///
  /// Calls the [toFire] function on each field and collects the results
  /// into a map using field names as keys.
  ///
  /// Returns a [Map] suitable for writing to a Firebase document.
  @override
  Future<Map<String, dynamic>> toMap() async {
    final entries = <String, dynamic>{};
    for (final field in fields) {
      final value = await field.toFire();
      entries[field.name] = value;
    }
    return entries;
  }

  /// Extracts field values from a Firebase document map.
  ///
  /// Calls [fromFire] on each field with the corresponding value from [map].
  /// Fields not present in the map are skipped.
  ///
  /// Parameters:
  ///   - [map]: Map from a Firebase document
  ///   - [path]: The path segment pointing to this document
  ///
  /// Returns a [FireFieldsOutput] containing all extracted field values.
  @override
  Future<FireFieldsOutput<P>> fromMap(Map<String, dynamic> map, P path) async {
    final outputs = <FireFieldOutput>[];
    for (final field in fields) {
      final raw = map[field.name];
      if (raw == null) continue;
      final value = field.fromFire(raw);
      outputs.add(FireFieldOutput(source: field, value: value));
    }
    return FireFieldsOutput<P>(source: path, fields: outputs);
  }

  /// Creates a copy of this [FireFieldSet] with optional updates.
  ///
  /// Parameters:
  ///   - [fields]: Optional new list of fields
  ///
  /// Returns a new [FireFieldSet] instance with the updated fields.
  FireFieldSet<P> copyWith({
    List<FireField>? fields,
  }) {
    return FireFieldSet(
      fields: fields ?? this.fields,
    );
  }
}
