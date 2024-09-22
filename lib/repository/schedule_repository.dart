import 'dart:async';

import 'package:calendar_scheduler/model/schedule_model.dart';
import 'package:calendar_scheduler/util/time.dart';
import 'package:dio/dio.dart';

import '../util/url.dart';

class ScheduleRepository {
  final _dio = Dio();
  final _targetUrl =
      'http://${getLocalHostName()}:8000/api/v1/schedule/schedules';

  Future<List<ScheduleModel>> getSchedules({
    required String accessToken,
    required DateTime date,
  }) async {
    final resp = await _dio.get(
      _targetUrl,
      options: Options(
        headers: {
          'authorization': 'Bearer $accessToken',
        },
      ),
      queryParameters: {
        'date': getDateString(date),
      },
    );

    if (resp.statusCode == 401) {

    }

    return resp.data
        .map<ScheduleModel>((x) => ScheduleModel.fromJson(json: x))
        .toList();
  }

  Future<int> createSchedule({
    required String accessToken,
    required ScheduleModel schedule,
  }) async {
    final json = schedule.toJson();

    final resp = await _dio.post(
      _targetUrl,
      options: Options(
        headers: {
          'authorization': 'Bearer $accessToken',
        },
      ),
      data: json,
    );

    return resp.data?['id'];
  }

  Future<void> deleteSchedule({
    required String accessToken,
    required int id,
  }) async {
    await _dio.delete(
      '$_targetUrl/$id',
      options: Options(
        headers: {
          'authorization': 'Bearer $accessToken',
        },
      ),
    );
    return;
  }
}
