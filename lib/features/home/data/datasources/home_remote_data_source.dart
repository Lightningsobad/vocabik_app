import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:vocabik_app/core/errors/exceptions.dart';
import 'package:vocabik_app/features/home/data/models/daily_pick_model.dart';
import 'package:vocabik_app/features/home/data/models/personalized_slot_model.dart';

abstract class HomeRemoteDataSource {
  Future<DailyPickModel> getDailyPick();
  Future<List<PersonalizedSlotModel>> getPersonalizedSlots();
}

@LazySingleton(as: HomeRemoteDataSource)
class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final Dio dio;

  HomeRemoteDataSourceImpl(this.dio);

  @override
  Future<DailyPickModel> getDailyPick() async {
    try {
      final response = await dio.get('/public/daily-pick');
      if (response.statusCode == 200 && response.data != null) {
        return DailyPickModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw ServerException();
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Unknown DioException');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<PersonalizedSlotModel>> getPersonalizedSlots() async {
    try {
      final response = await dio.get('/internal/featured-slots/personalized');
      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        final occupants = data['occupants'] as List<dynamic>? ?? [];
        return occupants
            .map((item) => PersonalizedSlotModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw ServerException();
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Unknown DioException');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}

