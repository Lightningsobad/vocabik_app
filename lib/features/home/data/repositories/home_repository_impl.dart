import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:vocabik_app/core/cache/json_disk_cache.dart';
import 'package:vocabik_app/core/errors/exceptions.dart';
import 'package:vocabik_app/core/errors/failures.dart';
import 'package:vocabik_app/features/home/data/datasources/home_remote_data_source.dart';
import 'package:vocabik_app/features/home/data/models/daily_pick_model.dart';
import 'package:vocabik_app/features/home/data/models/personalized_slot_model.dart';
import 'package:vocabik_app/features/home/domain/entities/daily_pick_entity.dart';
import 'package:vocabik_app/features/home/domain/entities/personalized_slot_entity.dart';
import 'package:vocabik_app/features/home/domain/repositories/home_repository.dart';

class _HomeCacheEntry<T> {
  final T data;
  final DateTime cachedAt;

  const _HomeCacheEntry(this.data, this.cachedAt);
}

@LazySingleton(as: HomeRepository)
class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;
  final JsonDiskCache? _diskCache;
  final DateTime Function() _now;

  static const Duration _cacheTtl = Duration(minutes: 3);
  static const String _dailyPickDiskKey =
      '${JsonDiskCache.homeKeyPrefix}daily_pick';
  static const String _personalizedDiskKey =
      '${JsonDiskCache.homeKeyPrefix}personalized_slots';

  _HomeCacheEntry<DailyPickEntity>? _dailyPickCache;
  _HomeCacheEntry<List<PersonalizedSlotEntity>>? _personalizedCache;

  @factoryMethod
  HomeRepositoryImpl({
    required this.remoteDataSource,
    required JsonDiskCache diskCache,
    // ignore: prefer_initializing_formals
  })  : _diskCache = diskCache,
        _now = DateTime.now {
    JsonDiskCache.registerHomeMemoryClearer(_clearMemoryCache);
  }

  @visibleForTesting
  HomeRepositoryImpl.withClock(
    this.remoteDataSource,
    this._now, [
    this._diskCache,
  ]) {
    JsonDiskCache.registerHomeMemoryClearer(_clearMemoryCache);
  }

  void _clearMemoryCache() {
    _dailyPickCache = null;
    _personalizedCache = null;
  }

  _HomeCacheEntry<DailyPickEntity>? _getOrLoadDailyPick() {
    if (_dailyPickCache != null) return _dailyPickCache;
    final disk = _diskCache?.read(_dailyPickDiskKey);
    if (disk?.data is! Map<String, dynamic>) return null;
    try {
      final model = DailyPickModel.fromJson(disk!.data as Map<String, dynamic>);
      _dailyPickCache = _HomeCacheEntry(model, disk.cachedAt);
      return _dailyPickCache;
    } catch (_) {
      return null;
    }
  }

  _HomeCacheEntry<List<PersonalizedSlotEntity>>? _getOrLoadPersonalized() {
    if (_personalizedCache != null) return _personalizedCache;
    final disk = _diskCache?.read(_personalizedDiskKey);
    if (disk?.data is! List<dynamic>) return null;
    try {
      final slots = (disk!.data as List<dynamic>)
          .map(
            (item) => PersonalizedSlotModel.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList();
      _personalizedCache = _HomeCacheEntry(slots, disk.cachedAt);
      return _personalizedCache;
    } catch (_) {
      return null;
    }
  }

  @override
  DailyPickEntity? getCachedDailyPick() => _getOrLoadDailyPick()?.data;

  @override
  List<PersonalizedSlotEntity>? getCachedPersonalizedSlots() =>
      _getOrLoadPersonalized()?.data;

  @override
  Future<Either<Failure, DailyPickEntity>> getDailyPick({
    bool forceRefresh = false,
  }) async {
    final cached = _getOrLoadDailyPick();
    if (!forceRefresh &&
        cached != null &&
        _now().difference(cached.cachedAt) < _cacheTtl) {
      return right(cached.data);
    }

    try {
      final result = await remoteDataSource.getDailyPick();
      final now = _now();
      _dailyPickCache = _HomeCacheEntry(result, now);
      await _diskCache?.write(_dailyPickDiskKey, result.toJson(), now: now);
      return right(result);
    } on ServerException catch (e) {
      if (!forceRefresh && cached != null) return right(cached.data);
      return left(ServerFailure(e.message));
    } catch (e) {
      if (!forceRefresh && cached != null) return right(cached.data);
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PersonalizedSlotEntity>>> getPersonalizedSlots({
    bool forceRefresh = false,
  }) async {
    final cached = _getOrLoadPersonalized();
    if (!forceRefresh &&
        cached != null &&
        _now().difference(cached.cachedAt) < _cacheTtl) {
      return right(cached.data);
    }

    try {
      final result = await remoteDataSource.getPersonalizedSlots();
      final now = _now();
      _personalizedCache = _HomeCacheEntry(result, now);
      await _diskCache?.write(
        _personalizedDiskKey,
        result.map((e) => e.toJson()).toList(),
        now: now,
      );
      return right(result);
    } on ServerException catch (e) {
      if (!forceRefresh && cached != null) return right(cached.data);
      return left(ServerFailure(e.message));
    } catch (e) {
      if (!forceRefresh && cached != null) return right(cached.data);
      return left(ServerFailure(e.toString()));
    }
  }
}
