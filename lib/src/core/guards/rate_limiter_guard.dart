import 'package:limit/limit.dart';

import 'operation_guard.dart';
import 'operation_limiter_base.dart';

class RateLimiterGuard extends OperationGuard implements OperationLimiterBase {
  final RateLimiter limiter;

  const RateLimiterGuard(this.limiter);

  @override
  Future<bool> isLimited() async => await limiter.isLimitedNow();

  @override
  Future<void> update() async => await limiter.tryConsume();

  @override
  Future<bool> canPerform() async => await isLimited();
}
