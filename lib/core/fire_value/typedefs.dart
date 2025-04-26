typedef ToFireDelegate<T> = Future<T?> Function();
typedef FromFireDelegate<T> = Future<void> Function(T?);
typedef FromFireSyncDelegate<T> = void Function(T?);
