import '../fire_value/output.dart';

import 'path_operator.dart';

class FireSetPathRead extends FireObjectPathOperator<OperationOutputReader> {
  FireSetPathRead({
    required super.fireOperatable,
  });

  @override
  Future<OperationOutputReader?> perform() async {
    final readAllowed = await super.readAllowed();
    if (readAllowed) {
      final rawData = await datasource.read(path.path);
      return await fireOperatable.fromMap(rawData, adapters);
    }
    return null;
  }
}

class FireSetPathWrite extends FireObjectPathOperator<String> {
  const FireSetPathWrite({
    required super.fireOperatable,
  });

  @override
  Future<String?> perform() async {
    final data = await fireOperatable.toMap(adapters);
    if (data.isEmpty) return dataEmptyMessage;
    return await datasource.write(path.path, data);
  }
}

class FireSetPathOverwrite extends FireObjectPathOperator<String> {
  const FireSetPathOverwrite({
    required super.fireOperatable,
  });

  @override
  Future<String?> perform() async {
    final data = await fireOperatable.toMap(adapters);
    if (data.isEmpty) return dataEmptyMessage;
    return await datasource.overwrite(path.path, data);
  }
}

class FireSetPathDelete extends FireObjectPathOperator {
  const FireSetPathDelete({
    required super.fireOperatable,
  });

  @override
  Future<String?> perform() async {
    return await datasource.delete(path.path);
  }
}

const String dataEmptyMessage = "Data is empty, nothing to write to firestore";
