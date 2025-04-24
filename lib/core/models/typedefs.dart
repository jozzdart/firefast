typedef ToFireDelegate<T> = Future<T?> Function();
typedef FromFireDelegate<T> = Future<void> Function(T?);
typedef IsValid<T> = Future<bool> Function(T?);
typedef ShouldCancelAll<T> = Future<bool> Function(T?);
