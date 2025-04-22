import 'package:firefast/firefast_core.dart';

/// Base interface for Firebase document fields.
///
/// This abstract class defines the contract for classes that represent
/// individual fields in a Firebase document. It specifies methods for
/// serialization and deserialization between application types and Firebase.
///
/// Type parameter [T] represents the application-side type for this field.
abstract class FireFieldBase<T> {
  /// The field name used in the Firebase document.
  String get name;

  /// Function that returns the value to be stored in Firebase.
  ToFireDelegate get toFire;

  /// Function that converts a Firebase value to the application type [T].
  FromFireDelegate<T> get fromFire;
}
