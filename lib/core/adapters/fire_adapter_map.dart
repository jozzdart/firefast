import 'dart:typed_data';

import 'fire_adapters.dart';
import 'list_fire_adapters.dart';

class FireAdapterMap {
  final Map<Type, FireAdapter<dynamic>> _registry = {};
  bool get registered => _registry.isNotEmpty;
  FireAdapterMap();

  static FireAdapterMap instance = FireAdapterMap();

  /// Registers an adapter for type [T] if not already registered.
  void register<T>(
    FireAdapter<T> adapter, {
    bool override = false,
  }) {
    if (override || !_registry.containsKey(T)) {
      _registry[T] = adapter;
    }
  }

  /// Retrieves the adapter for type [T]. Throws if not registered.
  FireAdapter<T> of<T>() {
    if (!registered) {
      registerAll();
    }
    final adapter = _registry[T];
    if (adapter == null) {
      throw StateError('No adapter registered for type $T');
    }
    return adapter as FireAdapter<T>;
  }

  /// Retrieves the adapter for type [T]. Throws if not registered.
  FireAdapter<List<T?>> listOf<T>() => of<List<T?>>();

  /// Returns true if an adapter for type [T] has been registered.
  bool contains<T>() => _registry.containsKey(T);

  void registerAll() {
    if (registered) return;
    registerAdapters();
    registerListAdaptersWith(this);
  }

  void registerAdapters() {
    register<bool>(BoolFireAdapter());
    register<int>(IntFireAdapter());
    register<double>(DoubleFireAdapter());
    register<String>(StringFireAdapter());
    register<DateTime>(DateTimeFireAdapter());
    register<Uint8List>(BytesStringFireAdapter());
    register<Map<String, dynamic>>(MapFireAdapter());
    register<List<dynamic>>(ListDynamicFireAdapter());
  }

  void registerListAdaptersWith(FireAdapterMap adapters) {
    register<List<bool?>>(ListFireAdapter<bool>(adapters));
    register<List<int?>>(ListFireAdapter<int>(adapters));
    register<List<double?>>(ListFireAdapter<double>(adapters));
    register<List<String?>>(ListFireAdapter<String>(adapters));
    register<List<Uint8List?>>(ListFireAdapter<Uint8List>(adapters));
    register<List<DateTime?>>(ListFireAdapter<DateTime>(adapters));
  }
}
