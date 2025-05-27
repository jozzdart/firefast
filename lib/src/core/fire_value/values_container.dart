import '../adapters/fire_adapter_map.dart';
import '../guards/guards.dart';

import 'fire_value_object.dart';
import 'output.dart';

abstract class FireValuesContainer {
  final List<FireValue> fireValues;

  const FireValuesContainer({
    this.fireValues = const [],
  });

  Future<bool> readAllowed() async {
    for (var i = 0; i < fireValues.length; i++) {
      final currentField = fireValues[i];
      final allows = await currentField.allowsRead();
      if (allows == false) {
        return false;
      }
    }
    return true;
  }

  Future<Map<String, dynamic>> toMap(FireAdapterMap adapters) async {
    final entries = <String, dynamic>{};
    for (final field in fireValues) {
      final entry = await field.toEntry(adapters);
      if (entry == null) continue;
      switch (entry.status) {
        case OperationGuardStatus.invalid:
          continue;
        case OperationGuardStatus.cancelOperation:
          return {};
        default:
          entries[entry.entry.key] = entry.entry.value;
      }
    }
    return entries;
  }

  Future<OperationOutputReader?> fromMap(
      Map<String, dynamic>? map, FireAdapterMap adapters) async {
    if (map == null) return null;
    Map<String, dynamic> outputs = {};
    for (final field in fireValues) {
      final exists = map.containsKey(field.name);
      if (!exists) continue;
      final raw = map[field.name];
      final value = await field.fromMapEntry(raw, adapters);
      outputs[field.name] = value;
    }
    return OperationOutputReader(fields: outputs);
  }
}
