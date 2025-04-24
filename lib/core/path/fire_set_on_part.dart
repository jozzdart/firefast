import 'package:firefast/firefast_core.dart';

abstract class FireSetOnPath<S extends PathBasedDataSource,
        P extends PathSegment, Self extends FireSetOnPath<S, P, Self>>
    extends DataOnPathWithSource<S, FireSetOutput> {
  final P _path;
  final FireSet fieldSet;
  final FireSetOnPathFactory<S, P, Self> _factory;

  const FireSetOnPath({
    required P path,
    required this.fieldSet,
    required FireSetOnPathFactory<S, P, Self> factory,
  })  : _path = path,
        _factory = factory;

  String get path => _path.path;

  P get pathSegment => _path;

  List<FireFieldBase> get fields => fieldSet.fields;

  @override
  Future<void> write() async {
    final data = await fieldSet.toMap();
    if (data.isEmpty) return;
    await datasource.write(path, data);
  }

  @override
  Future<void> overwrite() async {
    final data = await fieldSet.toMap();
    if (data.isEmpty) return;
    await datasource.overwrite(path, data);
  }

  @override
  Future<FireSetOutput?> read() async {
    final rawData = await datasource.read(path);
    if (rawData == null) return null;
    final toMap = await fieldSet.fromMap(rawData);
    if (toMap == null) return null;
    if (toMap.fields.isEmpty) return null;
    return toMap;
  }

  Future<void> deleteFields(List<FireFieldBase> selectedFields) async {
    final nullifiedData = {
      for (final field in selectedFields) field.name: null,
    };
    if (nullifiedData.isEmpty) return;
    await datasource.write(path, nullifiedData);
  }

  Future<T?> getField<T>(FireFieldBase<T> field) async {
    final all = await read();
    return all?.get<T>(field);
  }

  @override
  Future<void> delete() async => await datasource.delete(path);

  Self copyWith({
    P? path,
    FireSet? fieldSet,
  }) {
    return _factory(
      path: path ?? this._path,
      fieldSet: fieldSet ?? this.fieldSet,
    );
  }

  Self fromFields({
    required P path,
    required List<FireFieldBase> fields,
  }) {
    return _factory(path: path, fieldSet: FireSet(fields: fields));
  }

  Self addFields(List<FireFieldBase> newFields) {
    final currentFields = fieldSet.fields;
    return copyWith(
        fieldSet: FireSet(fields: [...currentFields, ...newFields]));
  }

  Self addField(FireFieldBase field) => addFields([field]);
}

typedef FireSetOnPathFactory<S extends PathBasedDataSource,
        P extends PathSegment, Self extends FireSetOnPath<S, P, Self>>
    = Self Function({
  required P path,
  required FireSet fieldSet,
});
