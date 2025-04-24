part of 'adapters.dart';

class TimestampFireAdapter extends FireAdapter<DateTime> {
  @override
  Future<dynamic> toFire(DateTime? value) async =>
      (value == null) ? null : Timestamp.fromDate(value);

  @override
  Future<DateTime?> fromFire(dynamic value) async =>
      (value == null) ? null : (value as Timestamp).toDate();
}
