part of 'adapters.dart';

class GeoPointFireAdapter extends FireAdapter<GeoPoint> {
  @override
  Future<dynamic> toFire(GeoPoint? value) async => value;

  @override
  Future<GeoPoint?> fromFire(dynamic value) async => value as GeoPoint;
}
