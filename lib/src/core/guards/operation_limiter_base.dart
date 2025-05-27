abstract class OperationLimiterBase {
  Future<bool> isLimited();
  Future<void> update();
}
