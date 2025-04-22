import 'package:firefast/cache/models/cache_limiter_base.dart';
import 'package:prf/prf.dart';

class CooldownLimiter implements CacheLimiterBase {
  final PrfCooldown cooldown;

  CooldownLimiter(this.cooldown);

  @override
  Future<bool> isLimited() => cooldown.isCooldownActive();

  @override
  Future<void> update() => cooldown.activateCooldown();
}
