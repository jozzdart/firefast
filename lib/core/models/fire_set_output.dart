import 'package:firefast/firefast_core.dart';

class FireSetOutput {
  final Map<String, dynamic> fields;

  const FireSetOutput({
    required this.fields,
  });

  T? get<T>(FireFieldBase<T> field) => getValue<T>(field.name);

  T? getValue<T>(String fieldName) {
    if (!fields.containsKey(fieldName)) {
      return null;
    }

    final value = fields[fieldName];
    if (value == null) {
      return null;
    }

    try {
      final afterCast = value as T;
      return afterCast;
    } catch (e) {
      throw FieldTypeMismatchException(
          'Field "$fieldName" could not be cast to the expected type: ${e.toString()}');
    }
  }
}

class FieldTypeMismatchException implements Exception {
  final String message;
  FieldTypeMismatchException(this.message);

  @override
  String toString() => 'FieldTypeMismatchException: $message';
}
