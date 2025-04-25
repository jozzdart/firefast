// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firefast/firefast_core.dart';

abstract class OperationGuard<T> {
  final IsValueValid<T>? isValid;
  final ValueCancelOperation<T>? valueCancelOperation;
  OperationGuard({
    this.isValid,
    this.valueCancelOperation,
  });

  bool get hasValidation => isValid != null;
  bool get mayBlockOperation => valueCancelOperation != null;

  Future<bool> isValueValid(T? value) async {
    if (hasValidation) {
      final result = await isValid!.call(value);
      return result;
    }
    return true;
  }

  Future<bool> allowsOperation(T? value) async {
    if (mayBlockOperation) {
      final cancelOperation = await valueCancelOperation!.call(value);
      final allow = cancelOperation ? false : true;
      return allow; // just for readability (: !!!!!!!!!!!!!!!!!
    }
    return true;
  }
}

class OutputOperation<T> extends OperationGuard<T> {
  final ToFireDelegate<T> receiveData;

  OutputOperation({
    required this.receiveData,
    super.isValid,
    super.valueCancelOperation,
  });

  OutputOperation.simple(
    this.receiveData,
  );

  Future<MapEntryOutput> toMapEntry(String name, FireAdapter<T> adapter) async {
    final data = await receiveData();

    final allowsOperation = await super.allowsOperation(data);
    if (!allowsOperation) {
      return MapEntryOutput(
        entry: null,
        status: OperationGuardStatus.cancelAll,
      );
    }

    final isValueValid = await super.isValueValid(data);
    if (!isValueValid) {
      return MapEntryOutput(
        entry: null,
        status: OperationGuardStatus.invalid,
      );
    }

    final fireData = await adapter.toFire(data);
    return MapEntryOutput(
      entry: MapEntry(name, fireData),
      status: OperationGuardStatus.valid,
    );
  }
}

class InputOperation<T> extends OperationGuard<T> {
  final ToFireDelegate<T> receiveData;

  InputOperation({
    required this.receiveData,
    super.isValid,
    super.valueCancelOperation,
  });

  InputOperation.simple(
    this.receiveData,
  );

  Future<T?> fromMapEntry(dynamic rawValue, ) async {
    if (rawValue == null) return null;
    final value = await adapter.fromFire(rawValue, FireAdapter<T> adapter);
    await onFetched(value);
    return value;
  }
}
