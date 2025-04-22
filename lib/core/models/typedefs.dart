/// Function that returns a value to be stored in Firebase.
/// This function should return a Firebase-compatible value type like
/// String, num, bool, Map, List, or null.
typedef ToFireDelegate = Future<dynamic> Function();

/// Function that converts a Firebase value to an application type [T].
/// Used to deserialize data coming from Firebase into strongly-typed objects.
/// Type parameter [T] is the application-side type being converted to.
typedef FromFireDelegate<T> = T Function(dynamic);
