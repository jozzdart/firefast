import 'dart:typed_data';
import 'package:test/test.dart';
import 'package:firefast/firefast_core.dart';

void main() {
  group('ToFire Extensions', () {
    group('Non-null primitive types', () {
      test('String extension creates ToFire instance', () async {
        final toFire = 'test'.toFire();
        expect(toFire, isA<ToFire<String>>());
        expect(await toFire.receiveData(), equals('test'));
      });

      test('int extension creates ToFire instance', () async {
        final toFire = 42.toFire();
        expect(toFire, isA<ToFire<int>>());
        expect(await toFire.receiveData(), equals(42));
      });

      test('double extension creates ToFire instance', () async {
        final toFire = 3.14.toFire();
        expect(toFire, isA<ToFire<double>>());
        expect(await toFire.receiveData(), equals(3.14));
      });

      test('bool extension creates ToFire instance', () async {
        final toFire = true.toFire();
        expect(toFire, isA<ToFire<bool>>());
        expect(await toFire.receiveData(), equals(true));
      });

      test('DateTime extension creates ToFire instance', () async {
        final date = DateTime(2023, 1, 1);
        final toFire = date.toFire();
        expect(toFire, isA<ToFire<DateTime>>());
        expect(await toFire.receiveData(), equals(date));
      });

      test('Uint8List extension creates ToFire instance', () async {
        final bytes = Uint8List.fromList([1, 2, 3]);
        final toFire = bytes.toFire();
        expect(toFire, isA<ToFire<Uint8List>>());
        expect(await toFire.receiveData(), equals(bytes));
      });

      test('Map extension creates ToFire instance', () async {
        final map = <String, dynamic>{'key': 'value'};
        final toFire = map.toFire();
        expect(toFire, isA<ToFire<Map<String, dynamic>>>());
        expect(await toFire.receiveData(), equals(map));
      });
    });

    group('Nullable primitive types', () {
      test('Nullable String extension creates ToFire instance', () async {
        String? nullableString = 'test';
        final toFire = nullableString.toFire();
        expect(toFire, isA<ToFire<String>>());
        expect(await toFire.receiveData(), equals('test'));

        nullableString = null;
        final nullToFire = nullableString.toFire();
        expect(await nullToFire.receiveData(), isNull);
      });

      test('Nullable int extension creates ToFire instance', () async {
        int? nullableInt = 42;
        final toFire = nullableInt.toFire();
        expect(toFire, isA<ToFire<int>>());
        expect(await toFire.receiveData(), equals(42));

        nullableInt = null;
        final nullToFire = nullableInt.toFire();
        expect(await nullToFire.receiveData(), isNull);
      });
    });

    group('List types', () {
      test('List<int> extension creates ToFire instance', () async {
        final list = [1, 2, 3];
        final toFire = list.toFire();
        expect(toFire, isA<ToFire<List<int?>>>());
        expect(await toFire.receiveData(), equals(list));
      });

      test('List<int?> extension creates ToFire instance', () async {
        final list = [1, null, 3];
        final toFire = list.toFire();
        expect(toFire, isA<ToFire<List<int?>>>());
        expect(await toFire.receiveData(), equals(list));
      });

      test('List<int?>? extension creates ToFire instance', () async {
        List<int?>? nullableList = [1, null, 3];
        final toFire = nullableList.toFire();
        expect(toFire, isA<ToFire<List<int?>>>());
        expect(await toFire.receiveData(), equals(nullableList));

        nullableList = null;
        final nullToFire = nullableList.toFire();
        expect(await nullToFire.receiveData(), isNull);
      });
    });

    group('Custom guard values', () {
      test('can pass custom validation guard', () async {
        final validationGuard =
            FireValueGuard.sync((String? value) => value?.isNotEmpty == true);
        final toFire = 'test'.toFire(validationGuard: validationGuard);

        expect(await toFire.isValid('test'), isTrue);
        expect(await toFire.isValid(''), isFalse);
      });

      test('can pass custom operation guard', () async {
        final allowOperationGuard =
            FireValueGuard.sync((int? value) => value != null && value > 0);
        final toFire = 42.toFire(allowOperationGuard: allowOperationGuard);

        expect(await toFire.allowsOperation(42), isTrue);
        expect(await toFire.allowsOperation(-5), isFalse);
      });
    });
  });
}
