import 'package:firefast/firefast_core.dart';

class FireSet {
  final List<FireFieldBase> fields;

  const FireSet({required this.fields});

  Future<Map<String, dynamic>> toMap() async {
    final entries = <String, dynamic>{};
    for (final field in fields) {
      final entry = await field.toMapEntry();
      switch (entry.status) {
        case MapEntryOutputStatus.invalid:
          continue;
        case MapEntryOutputStatus.cancelAll:
          return {};
        default:
          entries[entry.entry!.key] = entry.entry!.value;
      }
    }
    return entries;
  }

  Future<FireSetOutput?> fromMap(Map<String, dynamic>? map) async {
    if (map == null) return null;
    Map<String, dynamic> outputs = {};
    for (final field in fields) {
      final exists = map.containsKey(field.name);
      if (!exists) continue;
      final raw = map[field.name];
      await field.fromMapEntry(raw);
      outputs[field.name] = raw;
    }
    return FireSetOutput(fields: outputs);
  }

  FireSet copyWith({
    List<FireFieldBase>? fields,
  }) {
    return FireSet(
      fields: fields ?? this.fields,
    );
  }

  FireSet addField(FireFieldBase field) {
    return FireSet(
      fields: [...fields, field],
    );
  }

  FireSet addFields(List<FireFieldBase> newFields) {
    return FireSet(
      fields: [...fields, ...newFields],
    );
  }
}
