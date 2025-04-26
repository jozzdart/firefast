import 'package:firefast/firefast_core.dart';

abstract class FireGuardedOperator extends FireValuesContainer {
  final List<OperationGuard> guards;

  const FireGuardedOperator({
    this.guards = const [],
  });

  Future<bool> canPerform() async {
    for (var guard in guards) {
      final allow = await guard.canPerform();
      if (allow == false) return false;
    }
    return true;
  }

  Future<void> tryPerform() async {
    final canPerformAction = await canPerform();
    if (canPerformAction) await perform();
  }

  Future<void> perform();
}
