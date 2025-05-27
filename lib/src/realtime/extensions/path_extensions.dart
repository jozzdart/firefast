import 'extensions.dart';

extension RealtimeNodePathExtensions on RealtimeNodePath {
  RealtimeNode withFields(List<FireValue> values) {
    return RealtimeNode(path: this, fireValues: values);
  }

  RealtimeNode withField(FireValue value) => withFields([value]);

  RealtimeNode addField(FireValue value) => withField(value);

  RealtimeNode addFields(List<FireValue> values) => withFields(values);

  Future<void> delete() async => await withFields([]).delete();

  Future<void> writeFields(List<FireValue> values) async =>
      await withFields(values).delete();
}
