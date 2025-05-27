import 'dart:typed_data';

import '../guards/guards.dart';
import 'fire_port.dart';

// notNull
extension StringOperationExtensions on String {
  ToFire<String> toFire({
    BaseValueGuard<String> validationGuard = const EmptyValueGuard(),
    BaseValueGuard<String> allowOperationGuard = const EmptyValueGuard(),
  }) =>
      ToFire.sync(
        this,
        validationGuard: validationGuard,
        allowOperationGuard: allowOperationGuard,
      );
}

extension IntOperationExtensions on int {
  ToFire<int> toFire({
    BaseValueGuard<int> validationGuard = const EmptyValueGuard(),
    BaseValueGuard<int> allowOperationGuard = const EmptyValueGuard(),
  }) =>
      ToFire.sync(
        this,
        validationGuard: validationGuard,
        allowOperationGuard: allowOperationGuard,
      );
}

extension DoubleOperationExtensions on double {
  ToFire<double> toFire({
    BaseValueGuard<double> validationGuard = const EmptyValueGuard(),
    BaseValueGuard<double> allowOperationGuard = const EmptyValueGuard(),
  }) =>
      ToFire.sync(
        this,
        validationGuard: validationGuard,
        allowOperationGuard: allowOperationGuard,
      );
}

extension BoolOperationExtensions on bool {
  ToFire<bool> toFire({
    BaseValueGuard<bool> validationGuard = const EmptyValueGuard(),
    BaseValueGuard<bool> allowOperationGuard = const EmptyValueGuard(),
  }) =>
      ToFire.sync(
        this,
        validationGuard: validationGuard,
        allowOperationGuard: allowOperationGuard,
      );
}

extension DateTimeOperationExtensions on DateTime {
  ToFire<DateTime> toFire({
    BaseValueGuard<DateTime> validationGuard = const EmptyValueGuard(),
    BaseValueGuard<DateTime> allowOperationGuard = const EmptyValueGuard(),
  }) =>
      ToFire.sync(
        this,
        validationGuard: validationGuard,
        allowOperationGuard: allowOperationGuard,
      );
}

extension BytesOperationExtensions on Uint8List {
  ToFire<Uint8List> toFire({
    BaseValueGuard<Uint8List> validationGuard = const EmptyValueGuard(),
    BaseValueGuard<Uint8List> allowOperationGuard = const EmptyValueGuard(),
  }) =>
      ToFire.sync(
        this,
        validationGuard: validationGuard,
        allowOperationGuard: allowOperationGuard,
      );
}

extension MapOperationExtensions on Map<String, dynamic> {
  ToFire<Map<String, dynamic>> toFire({
    BaseValueGuard<Map<String, dynamic>> validationGuard =
        const EmptyValueGuard(),
    BaseValueGuard<Map<String, dynamic>> allowOperationGuard =
        const EmptyValueGuard(),
  }) =>
      ToFire.sync(
        this,
        validationGuard: validationGuard,
        allowOperationGuard: allowOperationGuard,
      );
}

// null

extension NullableStringOperationExtensions on String? {
  ToFire<String> toFire({
    BaseValueGuard<String> validationGuard = const EmptyValueGuard(),
    BaseValueGuard<String> allowOperationGuard = const EmptyValueGuard(),
  }) =>
      ToFire.sync(
        this,
        validationGuard: validationGuard,
        allowOperationGuard: allowOperationGuard,
      );
}

extension NullableIntOperationExtensions on int? {
  ToFire<int> toFire({
    BaseValueGuard<int> validationGuard = const EmptyValueGuard(),
    BaseValueGuard<int> allowOperationGuard = const EmptyValueGuard(),
  }) =>
      ToFire.sync(
        this,
        validationGuard: validationGuard,
        allowOperationGuard: allowOperationGuard,
      );
}

extension NullableDoubleOperationExtensions on double? {
  ToFire<double> toFire({
    BaseValueGuard<double> validationGuard = const EmptyValueGuard(),
    BaseValueGuard<double> allowOperationGuard = const EmptyValueGuard(),
  }) =>
      ToFire.sync(
        this,
        validationGuard: validationGuard,
        allowOperationGuard: allowOperationGuard,
      );
}

extension NullableBoolOperationExtensions on bool? {
  ToFire<bool> toFire({
    BaseValueGuard<bool> validationGuard = const EmptyValueGuard(),
    BaseValueGuard<bool> allowOperationGuard = const EmptyValueGuard(),
  }) =>
      ToFire.sync(
        this,
        validationGuard: validationGuard,
        allowOperationGuard: allowOperationGuard,
      );
}

extension NullableBytesOperationExtensions on Uint8List? {
  ToFire<Uint8List> toFire({
    BaseValueGuard<Uint8List> validationGuard = const EmptyValueGuard(),
    BaseValueGuard<Uint8List> allowOperationGuard = const EmptyValueGuard(),
  }) =>
      ToFire.sync(
        this,
        validationGuard: validationGuard,
        allowOperationGuard: allowOperationGuard,
      );
}

extension NullableDateTimeOperationExtensions on DateTime? {
  ToFire<DateTime> toFire({
    BaseValueGuard<DateTime> validationGuard = const EmptyValueGuard(),
    BaseValueGuard<DateTime> allowOperationGuard = const EmptyValueGuard(),
  }) =>
      ToFire.sync(
        this,
        validationGuard: validationGuard,
        allowOperationGuard: allowOperationGuard,
      );
}

extension NullableMapOperationExtensions on Map<String, dynamic>? {
  ToFire<Map<String, dynamic>> toFire({
    BaseValueGuard<Map<String, dynamic>> validationGuard =
        const EmptyValueGuard(),
    BaseValueGuard<Map<String, dynamic>> allowOperationGuard =
        const EmptyValueGuard(),
  }) =>
      ToFire.sync(
        this,
        validationGuard: validationGuard,
        allowOperationGuard: allowOperationGuard,
      );
}

/// list int

extension ListIntOperationExtensions on List<int> {
  ToFire<List<int?>> toFire({
    BaseValueGuard<List<int?>> validationGuard = const EmptyValueGuard(),
    BaseValueGuard<List<int?>> allowOperationGuard = const EmptyValueGuard(),
  }) =>
      ToFire.sync(
        this,
        validationGuard: validationGuard,
        allowOperationGuard: allowOperationGuard,
      );
}

extension NullableListIntOperationExtensions on List<int?> {
  ToFire<List<int?>> toFire({
    BaseValueGuard<List<int?>> validationGuard = const EmptyValueGuard(),
    BaseValueGuard<List<int?>> allowOperationGuard = const EmptyValueGuard(),
  }) =>
      ToFire.sync(
        this,
        validationGuard: validationGuard,
        allowOperationGuard: allowOperationGuard,
      );
}

extension NullableListNullableIntOperationExtensions on List<int?>? {
  ToFire<List<int?>> toFire({
    BaseValueGuard<List<int?>> validationGuard = const EmptyValueGuard(),
    BaseValueGuard<List<int?>> allowOperationGuard = const EmptyValueGuard(),
  }) =>
      ToFire.sync(
        this,
        validationGuard: validationGuard,
        allowOperationGuard: allowOperationGuard,
      );
}

/// list double

extension ListDoubleOperationExtensions on List<double> {
  ToFire<List<double?>> toFire({
    BaseValueGuard<List<double?>> validationGuard = const EmptyValueGuard(),
    BaseValueGuard<List<double?>> allowOperationGuard = const EmptyValueGuard(),
  }) =>
      ToFire.sync(
        this,
        validationGuard: validationGuard,
        allowOperationGuard: allowOperationGuard,
      );
}

extension NullableListDoubleOperationExtensions on List<double?> {
  ToFire<List<double?>> toFire({
    BaseValueGuard<List<double?>> validationGuard = const EmptyValueGuard(),
    BaseValueGuard<List<double?>> allowOperationGuard = const EmptyValueGuard(),
  }) =>
      ToFire.sync(
        this,
        validationGuard: validationGuard,
        allowOperationGuard: allowOperationGuard,
      );
}

extension NullableListNullableDoubleOperationExtensions on List<double?>? {
  ToFire<List<double?>> toFire({
    BaseValueGuard<List<double?>> validationGuard = const EmptyValueGuard(),
    BaseValueGuard<List<double?>> allowOperationGuard = const EmptyValueGuard(),
  }) =>
      ToFire.sync(
        this,
        validationGuard: validationGuard,
        allowOperationGuard: allowOperationGuard,
      );
}

/// list string

extension ListStringOperationExtensions on List<String> {
  ToFire<List<String?>> toFire({
    BaseValueGuard<List<String?>> validationGuard = const EmptyValueGuard(),
    BaseValueGuard<List<String?>> allowOperationGuard = const EmptyValueGuard(),
  }) =>
      ToFire.sync(
        this,
        validationGuard: validationGuard,
        allowOperationGuard: allowOperationGuard,
      );
}

extension NullableListStringOperationExtensions on List<String?> {
  ToFire<List<String?>> toFire({
    BaseValueGuard<List<String?>> validationGuard = const EmptyValueGuard(),
    BaseValueGuard<List<String?>> allowOperationGuard = const EmptyValueGuard(),
  }) =>
      ToFire.sync(
        this,
        validationGuard: validationGuard,
        allowOperationGuard: allowOperationGuard,
      );
}

extension NullableListNullableStringOperationExtensions on List<String?>? {
  ToFire<List<String?>> toFire({
    BaseValueGuard<List<String?>> validationGuard = const EmptyValueGuard(),
    BaseValueGuard<List<String?>> allowOperationGuard = const EmptyValueGuard(),
  }) =>
      ToFire.sync(
        this,
        validationGuard: validationGuard,
        allowOperationGuard: allowOperationGuard,
      );
}

/// list bool

extension ListBoolOperationExtensions on List<bool> {
  ToFire<List<bool?>> toFire({
    BaseValueGuard<List<bool?>> validationGuard = const EmptyValueGuard(),
    BaseValueGuard<List<bool?>> allowOperationGuard = const EmptyValueGuard(),
  }) =>
      ToFire.sync(
        this,
        validationGuard: validationGuard,
        allowOperationGuard: allowOperationGuard,
      );
}

extension NullableListBoolOperationExtensions on List<bool?> {
  ToFire<List<bool?>> toFire({
    BaseValueGuard<List<bool?>> validationGuard = const EmptyValueGuard(),
    BaseValueGuard<List<bool?>> allowOperationGuard = const EmptyValueGuard(),
  }) =>
      ToFire.sync(
        this,
        validationGuard: validationGuard,
        allowOperationGuard: allowOperationGuard,
      );
}

extension NullableListNullableBoolOperationExtensions on List<bool?>? {
  ToFire<List<bool?>> toFire({
    BaseValueGuard<List<bool?>> validationGuard = const EmptyValueGuard(),
    BaseValueGuard<List<bool?>> allowOperationGuard = const EmptyValueGuard(),
  }) =>
      ToFire.sync(
        this,
        validationGuard: validationGuard,
        allowOperationGuard: allowOperationGuard,
      );
}

/// list datetime

extension ListDateTimeOperationExtensions on List<DateTime> {
  ToFire<List<DateTime?>> toFire({
    BaseValueGuard<List<DateTime?>> validationGuard = const EmptyValueGuard(),
    BaseValueGuard<List<DateTime?>> allowOperationGuard =
        const EmptyValueGuard(),
  }) =>
      ToFire.sync(
        this,
        validationGuard: validationGuard,
        allowOperationGuard: allowOperationGuard,
      );
}

extension NullableListDateTimeOperationExtensions on List<DateTime?> {
  ToFire<List<DateTime?>> toFire({
    BaseValueGuard<List<DateTime?>> validationGuard = const EmptyValueGuard(),
    BaseValueGuard<List<DateTime?>> allowOperationGuard =
        const EmptyValueGuard(),
  }) =>
      ToFire.sync(
        this,
        validationGuard: validationGuard,
        allowOperationGuard: allowOperationGuard,
      );
}

extension NullableListNullableDateTimeOperationExtensions on List<DateTime?>? {
  ToFire<List<DateTime?>> toFire({
    BaseValueGuard<List<DateTime?>> validationGuard = const EmptyValueGuard(),
    BaseValueGuard<List<DateTime?>> allowOperationGuard =
        const EmptyValueGuard(),
  }) =>
      ToFire.sync(
        this,
        validationGuard: validationGuard,
        allowOperationGuard: allowOperationGuard,
      );
}

/// listbytes

extension ListBytesOperationExtensions on List<Uint8List> {
  ToFire<List<Uint8List?>> toFire({
    BaseValueGuard<List<Uint8List?>> validationGuard = const EmptyValueGuard(),
    BaseValueGuard<List<Uint8List?>> allowOperationGuard =
        const EmptyValueGuard(),
  }) =>
      ToFire.sync(
        this,
        validationGuard: validationGuard,
        allowOperationGuard: allowOperationGuard,
      );
}

extension NullableListBytesOperationExtensions on List<Uint8List?> {
  ToFire<List<Uint8List?>> toFire({
    BaseValueGuard<List<Uint8List?>> validationGuard = const EmptyValueGuard(),
    BaseValueGuard<List<Uint8List?>> allowOperationGuard =
        const EmptyValueGuard(),
  }) =>
      ToFire.sync(
        this,
        validationGuard: validationGuard,
        allowOperationGuard: allowOperationGuard,
      );
}

extension NullableListNullableBytesOperationExtensions on List<Uint8List?>? {
  ToFire<List<Uint8List?>> toFire({
    BaseValueGuard<List<Uint8List?>> validationGuard = const EmptyValueGuard(),
    BaseValueGuard<List<Uint8List?>> allowOperationGuard =
        const EmptyValueGuard(),
  }) =>
      ToFire.sync(
        this,
        validationGuard: validationGuard,
        allowOperationGuard: allowOperationGuard,
      );
}

/// list dynamic

extension DynamicListOperationExtensions on List<dynamic> {
  ToFire<List<dynamic>> toFire({
    BaseValueGuard<List<dynamic>> validationGuard = const EmptyValueGuard(),
    BaseValueGuard<List<dynamic>> allowOperationGuard = const EmptyValueGuard(),
  }) =>
      ToFire.sync(
        this,
        validationGuard: validationGuard,
        allowOperationGuard: allowOperationGuard,
      );
}

extension NullableDynamicListOperationExtensions on List<dynamic>? {
  ToFire<List<dynamic>> toFire({
    BaseValueGuard<List<dynamic>> validationGuard = const EmptyValueGuard(),
    BaseValueGuard<List<dynamic>> allowOperationGuard = const EmptyValueGuard(),
  }) =>
      ToFire.sync(
        this,
        validationGuard: validationGuard,
        allowOperationGuard: allowOperationGuard,
      );
}
