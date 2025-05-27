import 'operation_guard.dart';

class FireGuards {
  final List<OperationGuard> read;
  final List<OperationGuard> write;
  final List<OperationGuard> overwrite;
  final List<OperationGuard> delete;

  const FireGuards({
    this.read = const [],
    this.write = const [],
    this.overwrite = const [],
    this.delete = const [],
  });
}
