abstract class CacheLimiterBase {
  Future<bool> isLimited();
  Future<void> update();
}
