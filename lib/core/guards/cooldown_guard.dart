import 'package:limit/limit.dart';

import 'operation_limiter_base.dart';
import 'operation_guard.dart';

class CooldownGuard extends OperationGuard implements OperationLimiterBase {
  final Cooldown cooldown;

  const CooldownGuard(this.cooldown);

  @override
  Future<bool> isLimited() async => await cooldown.isCooldownActive();

  @override
  Future<void> update() async => await cooldown.activateCooldown();

  @override
  Future<bool> canPerform() async => await isLimited();
}
