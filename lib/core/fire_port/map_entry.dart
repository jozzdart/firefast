import 'package:firefast/firefast_core.dart';

class MapEntryToFire {
  final OperationGuardStatus status;
  final MapEntry<String, dynamic> entry;

  const MapEntryToFire({required this.status, required this.entry});

  MapEntryToFire.valid(String key, dynamic value)
      : status = OperationGuardStatus.valid,
        entry = MapEntry(key, value);

  const MapEntryToFire.empty({required this.status})
      : entry = const MapEntry('', '');

  const MapEntryToFire.cancelOperation()
      : this.empty(status: OperationGuardStatus.cancelOperation);

  const MapEntryToFire.invalid()
      : this.empty(status: OperationGuardStatus.invalid);
}
