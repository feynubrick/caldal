import 'dart:async';

import 'package:calendar_scheduler/model/schedule_model.dart';
import 'package:calendar_scheduler/util/time.dart';
import 'package:dio/dio.dart';

import '../util/url.dart';

class ScheduleRepository {
  final _dio = Dio();
  final _targetUrl = 'http://${getLocalHostName()}:8000/api/v1/schedule/schedules';

  Future<List<ScheduleModel>> getSchedules({
    required DateTime date,
  }) async {
    final resp = await _dio.get(
      _targetUrl,
      queryParameters: {
        'date': getDateString(date),
      },
    );

    return resp.data
        .map<ScheduleModel>((x) => ScheduleModel.fromJson(json: x))
        .toList();
  }

  Future<int> createSchedule({
    required ScheduleModel schedule,
  }) async {
    final json = schedule.toJson();

    final resp = await _dio.post(_targetUrl, data: json);

    return resp.data?['id'];
  }

  Future<void> deleteSchedule({
    required int id,
  }) async {
    await _dio.delete('$_targetUrl/$id');
    return;
  }
}
