import 'package:firefast/cache/models/cache_limiter_base.dart';
import 'package:firefast/cache/models/typedefs.dart';
import 'package:firefast/firefast_core.dart';
import 'package:flutter/material.dart';

abstract class FireCacheBox<T, O extends FireDataPathObject>
    implements FireDataPathObject<T> {
  final O object;

  FireCacheBox({required this.object});

  CacheLimiterBase? get readLimiter;
  CacheLimiterBase? get writeLimiter;
  CacheLimiterBase? get deleteLimiter;

  GetCacheFunction<T>? get getCache;
  UpdateCacheFunction<T>? get updateCache;
  IsDataValidCache<T>? get isDataValid;

  ToFireDelegate get toFire;
  FromFireDelegate<T> get fromFire;

  @override
  Future<T?> read() async {
    final isLimited = await readLimiter?.isLimited() ?? false;
    final cached = getCache?.call();
    if (isLimited && cached != null) return cached;

    final data = await object.read();
    final valid = await isDataValid?.call(data) ?? false;
    if (valid) {
      await readLimiter?.update();
      await updateCache?.call(data);
      return data;
    }
    return null;
  }

  @override
  Future<void> write() async {
    final isLimited = await writeLimiter?.isLimited() ?? false;
    if (isLimited) return;
    final toFireValue = await toFire();
    final data = fromFire(toFireValue);
    final valid = await isDataValid?.call(data) ?? false;
    if (!valid) return;

    try {
      await object.write();
    } catch (e) {
      debugPrint(e.toString());
      return;
    }

    await writeLimiter?.update();
    await updateCache?.call(data);
  }

  @override
  Future<void> overwrite() async => await write();

  @override
  Future<void> delete() async {
    final isLimited = await deleteLimiter?.isLimited() ?? false;
    if (isLimited) return;

    try {
      await object.delete();
    } catch (e) {
      debugPrint(e.toString());
      return;
    }

    await deleteLimiter?.update();
    await updateCache?.call(null as T);
  }
}
