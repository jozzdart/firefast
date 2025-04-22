typedef GetCacheFunction<T> = Future<T?> Function();
typedef UpdateCacheFunction<T> = Future<void> Function(T value);
typedef IsDataValidCache<T> = Future<bool> Function(T value);
