import 'package:calendar_scheduler/model/schedule_model.dart';
import 'package:calendar_scheduler/repository/auth_repository.dart';
import 'package:calendar_scheduler/repository/schedule_repository.dart';
import 'package:flutter/material.dart';

class ScheduleProvider extends ChangeNotifier {
  final AuthRepository authRepository;
  final ScheduleRepository scheduleRepository;

  DateTime selectedDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  Map<DateTime, List<ScheduleModel>> cache = {};

  ScheduleProvider({
    required this.scheduleRepository,
    required this.authRepository,
  }) : super() {
    _initializeSchedules();
  }

  Future<void> _initializeSchedules() async {
    final token = await authRepository.getAccessToken();
    if (token != null) {
      getSchedules(date: selectedDate);
    }
  }

  Future<void> register({
    required String email,
    required String password,
  }) async {
    await authRepository.register(
      email: email,
      password: password,
    );
    notifyListeners();
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    await authRepository.login(
      email: email,
      password: password,
    );
    notifyListeners();
    getSchedules(date: selectedDate);
  }

  Future<void> logout() async {
    await authRepository.clearTokens();
    cache = {};
    notifyListeners();
  }

  Future<String?> _getValidAccessToken() async {
    String? token = await authRepository.getAccessToken();
    if (token == null) {
      return null;
    }
    // 토큰 만료 체크 로직이 필요하다면 여기에 추가
    return token;
  }

  Future<void> getSchedules({
    required DateTime date,
  }) async {
    final token = await _getValidAccessToken();
    if (token == null) {
      return;
    }

    final resp = await scheduleRepository.getSchedules(
      accessToken: token,
      date: date,
    );

    cache.update(date, (value) => resp, ifAbsent: () => resp);

    notifyListeners();
  }

  Future<void> createSchedule({
    required ScheduleModel schedule,
  }) async {
    final token = await _getValidAccessToken();
    if (token == null) {
      // 토큰이 없으면 로그인 필요
      return;
    }

    final targetDate = schedule.date;

    const tempId = 0;
    final newSchedule = schedule.copyWith(id: tempId);

    cache.update(
      targetDate,
          (value) => [
        ...value,
        newSchedule,
      ]..sort(
            (a, b) => a.startTime.compareTo(
          b.startTime,
        ),
      ),
      ifAbsent: () => [newSchedule],
    );

    notifyListeners();

    try {
      final savedScheduleId = await scheduleRepository.createSchedule(
        accessToken: token,
        schedule: schedule,
      );
      cache.update(
        targetDate,
            (value) => value
            .map((e) => e.id == tempId
            ? e.copyWith(
          id: savedScheduleId,
        )
            : e)
            .toList(),
      );
    } catch (e) {
      cache.update(
        targetDate,
            (value) => value.where((e) => e.id != tempId).toList(),
      );
    }

    notifyListeners();
  }

  Future<void> deleteSchedule({
    required DateTime date,
    required int id,
  }) async {
    final token = await _getValidAccessToken();
    if (token == null) {
      // 토큰이 없으면 로그인 필요
      return;
    }

    final targetSchedule = cache[date]!.firstWhere(
          (e) => e.id == id,
    );

    cache.update(
      date,
          (value) => value.where((e) => e.id != id).toList(),
      ifAbsent: () => [],
    );

    notifyListeners();

    try {
      await scheduleRepository.deleteSchedule(
        accessToken: token,
        id: id,
      );
    } catch (e) {
      cache.update(
        date,
            (value) => [...value, targetSchedule]..sort(
              (a, b) => a.startTime.compareTo(
            b.startTime,
          ),
        ),
      );
    }

    notifyListeners();
  }

  void changeSelectedDate({
    required DateTime date,
  }) {
    selectedDate = date;
    notifyListeners();
  }
}