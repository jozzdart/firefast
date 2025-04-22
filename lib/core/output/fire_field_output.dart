import 'package:firefast/firefast_core.dart';

/// A container for a single [FireField]'s output value.
///
/// This class holds a reference to the source [FireField] and its corresponding value,
/// providing an easily accessible way to retrieve field information and its value.
///
/// Type parameter [T] represents the expected type of the field value.
///
/// Example:
/// ```dart
/// final nameField = FireField<String>('name');
/// final nameOutput = FireFieldOutput(source: nameField, value: 'John Doe');
/// print(nameOutput.fieldName); // Outputs: name
/// print(nameOutput.value); // Outputs: John Doe
/// ```
class FireFieldOutput<T> {
  /// The source [FireField] that this output is associated with.
  final FireField<T> source;

  /// The value of the field.
  final T value;

  /// Creates a [FireFieldOutput] with the required [source] field and [value].
  const FireFieldOutput({
    required this.source,
    required this.value,
  });

  /// Returns the name of the source field.
  String get fieldName => source.name;
}
