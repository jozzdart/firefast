import 'package:collection/collection.dart';
import 'package:firefast/firefast_core.dart';

/// A collection of multiple [FireFieldOutput] objects associated with a specific path segment.
///
/// This class provides a type-safe way to access field values using either the original [FireField]
/// reference or the field name as a string. It also offers conversion to a standard Dart [Map].
///
/// Type parameter [P] represents the specific [PathSegment] type that this collection of fields
/// is associated with.
///
/// Example:
/// ```dart
/// final userPath = UserPath();
/// final nameField = FireField<String>('name');
/// final ageField = FireField<int>('age');
///
/// final outputs = FireFieldsOutput(
///   source: userPath,
///   fields: [
///     FireFieldOutput(source: nameField, value: 'John Doe'),
///     FireFieldOutput(source: ageField, value: 30),
///   ],
/// );
///
/// // Get value using field reference (type-safe)
/// String? name = outputs.get(nameField); // Returns 'John Doe'
///
/// // Get value using field name
/// int? age = outputs.getValue<int>('age'); // Returns 30
///
/// // Convert to map
/// Map<String, dynamic> data = outputs.toMap();
/// // Results in: {'name': 'John Doe', 'age': 30}
/// ```
class FireFieldsOutput<P extends PathSegment> {
  /// The path segment source that these fields are associated with.
  final P source;

  /// The list of individual field outputs.
  final List<FireFieldOutput> fields;

  /// Creates a [FireFieldsOutput] with the required [source] path segment and [fields] list.
  const FireFieldsOutput({
    required this.source,
    required this.fields,
  });

  /// Gets a field value using a [FireField] reference.
  ///
  /// This is the type-safe way to retrieve values as it preserves the field's expected type.
  /// When multiple fields with the same name exist, this method first checks for an exact
  /// field reference match, then falls back to matching by name.
  ///
  /// Returns `null` if the field is not found or if the value cannot be cast to the expected type.
  ///
  /// Example:
  /// ```dart
  /// final nameField = FireField<String>('name');
  /// final name = outputs.get(nameField);
  /// ```
  T? get<T>(FireField<T> field) {
    // First try to find an exact match by field reference (identity)
    final exactMatch =
        fields.firstWhereOrNull((f) => identical(f.source, field));
    if (exactMatch != null) {
      return _castValue<T>(exactMatch);
    }

    // Fall back to matching by field name
    final nameMatch = fields.firstWhereOrNull((f) => f.fieldName == field.name);
    return _castValue<T>(nameMatch);
  }

  /// Gets a field value using its field name as a string.
  ///
  /// The type parameter [T] specifies the expected return type.
  /// Returns `null` if the field is not found or if the value cannot be cast to the expected type.
  ///
  /// Example:
  /// ```dart
  /// final name = outputs.getValue<String>('name');
  /// ```
  T? getValue<T>(String fieldName) {
    final raw = fields.firstWhereOrNull((f) => f.fieldName == fieldName);
    return _castValue<T>(raw);
  }

  /// Safely casts a [FireFieldOutput]'s value to the specified type [T].
  ///
  /// Returns `null` if the field is `null` or if the value cannot be cast to type [T].
  T? _castValue<T>(FireFieldOutput? field) {
    if (field == null) return null;
    try {
      return field.value as T;
    } catch (_) {
      return null;
    }
  }

  /// Converts all field outputs to a [Map] with field names as keys and field values as values.
  ///
  /// This is useful for serialization or when you need to work with standard Dart maps.
  /// Note that when duplicate field names exist, the last field's value will be used in the map.
  ///
  /// Example:
  /// ```dart
  /// final data = outputs.toMap();
  /// jsonEncode(data); // Convert to JSON
  /// ```
  Map<String, dynamic> toMap() => {
        for (final f in fields) f.fieldName: f.value,
      };
}
