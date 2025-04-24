import 'package:firefast/firefast_core.dart';

abstract class FirePort<T> {
  final ToFireDelegate<T> receiveData;
  final FromFireDelegate<T> onFetched;
  final IsValid<T>? isValid;
  final ShouldCancelAll<T>? shouldCancelAll;

  const FirePort({
    required this.receiveData,
    required this.onFetched,
    this.isValid,
    this.shouldCancelAll,
  });
}
