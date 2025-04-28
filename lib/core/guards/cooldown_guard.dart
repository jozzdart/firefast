import 'package:firefast/core/guards/operation_limiter_base.dart';
import 'package:firefast/firefast_core.dart';
import 'package:prf/prf.dart';

class CooldownGuard extends OperationGuard implements OperationLimiterBase {
  final PrfCooldown cooldown;

  const CooldownGuard(this.cooldown);

  @override
  Future<bool> isLimited() async => await cooldown.isCooldownActive();

  @override
  Future<void> update() async => await cooldown.activateCooldown();

  @override
  Future<bool> canPerform() async => await isLimited();
}
