import 'package:firefast/firefast_core.dart';

/// A field for Firebase document data with serialization capabilities.
///
/// [FireField] encapsulates a field name along with functions to convert data
/// to and from Firebase format. It implements the [FireFieldBase] interface.
///
/// Type parameter [T] represents the type of data this field will handle.
///
/// Example:
/// ```dart
/// final nameField = FireField<String>(
///   name: 'name',
///   toFire: () async => user.name,
///   fromFire: (dynamic value) => value as String,
/// );
/// ```
class FireField<T> implements FireFieldBase<T> {
  /// The name of this field in the Firebase document.
  @override
  final String name;

  /// Function that returns the value to be stored in Firebase.
  ///
  /// This delegate is called when converting local data to Firebase format.
  @override
  final ToFireDelegate toFire;

  /// Function that converts a Firebase value to the local type [T].
  ///
  /// This delegate is called when retrieving data from Firebase.
  @override
  final FromFireDelegate<T> fromFire;

  /// Creates a new [FireField] instance.
  ///
  /// All parameters are required:
  /// - [name]: The field name as stored in Firebase
  /// - [toFire]: Function that returns the data to be stored
  /// - [fromFire]: Function that converts Firebase data to type [T]
  const FireField({
    required this.name,
    required this.toFire,
    required this.fromFire,
  });
}
