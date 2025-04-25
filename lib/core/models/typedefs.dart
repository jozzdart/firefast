typedef ToFireDelegate<T> = Future<T?> Function();
typedef FromFireDelegate<T> = Future<void> Function(T?);
