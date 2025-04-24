import 'dart:convert';
import 'dart:typed_data';

abstract class BaseFireAdapter<T> {
  Future<dynamic> toFire(T value);
  Future<T> fromFire(dynamic value);
  const BaseFireAdapter();
}

abstract class FireAdapter<T> extends BaseFireAdapter<T?> {
  const FireAdapter();
}

abstract class FireAdapterMap {
  final Map<Type, FireAdapter<dynamic>> _registry = {};
  bool registered = false;

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
    registered = true;
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
}

class BoolFireAdapter extends FireAdapter<bool> {
  @override
  Future<dynamic> toFire(bool? value) async => value;

  @override
  Future<bool?> fromFire(dynamic value) async => value as bool?;
}

class BytesStringFireAdapter extends FireAdapter<Uint8List> {
  @override
  Future<dynamic> toFire(Uint8List? value) async =>
      (value == null) ? null : base64Encode(value);

  @override
  Future<Uint8List?> fromFire(dynamic value) async =>
      (value == null) ? null : base64Decode(value as String);
}

class DoubleFireAdapter extends FireAdapter<double> {
  @override
  Future<dynamic> toFire(double? value) async => value;

  @override
  Future<double?> fromFire(dynamic value) async => value as double?;
}

class IntFireAdapter extends FireAdapter<int> {
  @override
  Future<dynamic> toFire(int? value) async => value;

  @override
  Future<int?> fromFire(dynamic value) async => value as int?;
}

class StringFireAdapter extends FireAdapter<String> {
  @override
  Future<dynamic> toFire(String? value) async => value;

  @override
  Future<String?> fromFire(dynamic value) async => value as String?;
}

class MapFireAdapter extends FireAdapter<Map<String, dynamic>> {
  @override
  Future<dynamic> toFire(Map<String, dynamic>? value) async => value;

  @override
  Future<Map<String, dynamic>?> fromFire(dynamic value) async =>
      value as Map<String, dynamic>?;
}

class ListDynamicFireAdapter extends FireAdapter<List<dynamic>> {
  @override
  Future<dynamic> toFire(List<dynamic>? value) async => value;

  @override
  Future<List<dynamic>?> fromFire(dynamic value) async =>
      value as List<dynamic>?;
}

class DateTimeFireAdapter extends FireAdapter<DateTime> {
  @override
  Future<dynamic> toFire(DateTime? value) async {
    if (value == null) return null;
    final bytes = ByteData(8)..setInt64(0, value.millisecondsSinceEpoch);
    final byteList = bytes.buffer.asUint8List();
    return base64Encode(byteList);
  }

  @override
  Future<DateTime?> fromFire(dynamic value) async {
    if (value == null) return null;
    final byteList = base64Decode(value as String);
    final byteData = ByteData.sublistView(Uint8List.fromList(byteList));
    final millisecondsSinceEpoch = byteData.getInt64(0);
    return DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
  }
}
