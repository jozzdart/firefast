import 'dart:typed_data';

import 'package:firefast/firefast_core.dart';

part 'list.dart';

class RealtimeAdapters extends FireAdapterMap {
  RealtimeAdapters();
  static RealtimeAdapters instance = RealtimeAdapters();

  @override
  void registerAll() {
    if (registered) return;
    super.registerAdapters();
    registerListAdapters();
    super.registerAll();
  }

  void registerListAdapters() {
    register<List<bool?>>(RealtimeListAdapters<bool>());
    register<List<int?>>(RealtimeListAdapters<int>());
    register<List<double?>>(RealtimeListAdapters<double>());
    register<List<String?>>(RealtimeListAdapters<String>());
    register<List<Uint8List?>>(RealtimeListAdapters<Uint8List>());
    register<List<DateTime?>>(RealtimeListAdapters<DateTime>());
  }
}
