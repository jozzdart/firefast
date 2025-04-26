import 'package:firefast/firefast_core.dart';

class FireSetPathRead extends FireObjectPathOperator {
  FireSetPathRead({
    required super.fireOperatable,
  });

  @override
  Future<void> perform() async {
    final readAllowed = await super.readAllowed();
    if (readAllowed) {
      final rawData = await datasource.read(path.path);
      await fireOperatable.fromMap(rawData, adapters);
    }
  }
}

class FireSetPathWrite extends FireObjectPathOperator {
  const FireSetPathWrite({
    required super.fireOperatable,
  });

  @override
  Future<void> perform() async {
    final data = await fireOperatable.toMap(adapters);
    if (data.isEmpty) return;
    await datasource.write(path.path, data);
  }
}

class FireSetPathOverwrite extends FireObjectPathOperator {
  const FireSetPathOverwrite({
    required super.fireOperatable,
  });

  @override
  Future<void> perform() async {
    final data = await fireOperatable.toMap(adapters);
    if (data.isEmpty) return;
    await datasource.overwrite(path.path, data);
  }
}

class FireSetPathDelete extends FireObjectPathOperator {
  const FireSetPathDelete({
    required super.fireOperatable,
  });

  @override
  Future<void> perform() async {
    await datasource.delete(path.path);
  }
}
