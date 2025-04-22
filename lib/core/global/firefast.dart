import 'package:firefast/firefast_core.dart';

/// The main entry point for accessing Firefast functionality.
///
/// This class provides static factory methods for creating common Firefast objects
/// like path segments and fields, making it easier to work with Firebase data.
///
/// Example:
/// ```dart
/// // Create a path segment
/// final usersPath = Firefast.path('users');
///
/// // Create a field
/// final nameField = Firefast.field<String>(
///   name: 'name',
///   toFire: () async => user.name,
///   fromFire: (value) => value as String,
/// );
/// ```
class Firefast {
  /// Creates a new [PathSegment] with the specified segment string.
  ///
  /// This is a convenience method for creating path segments that represent
  /// locations in your Firebase database.
  ///
  /// [segment] is the string value for this path segment.
  ///
  /// Returns a new [PathSegment] instance.
  static PathSegment path(String segment) => PathSegment(segment);

  /// Creates a new [FireField] with the specified configuration.
  ///
  /// This is a convenience method for creating typed fields that can be
  /// serialized to and from Firebase.
  ///
  /// Parameters:
  /// * [name] - The field name as it appears in Firebase
  /// * [toFire] - A function that returns the value to store in Firebase
  /// * [fromFire] - A function that converts Firebase data to the application type
  ///
  /// Type parameter [T] represents the application-side type for this field.
  ///
  /// Returns a new [FireField] instance.
  static FireField<T> field<T>(
          {required String name,
          required ToFireDelegate toFire,
          required FromFireDelegate<T> fromFire}) =>
      FireField(name: name, toFire: toFire, fromFire: fromFire);
}
