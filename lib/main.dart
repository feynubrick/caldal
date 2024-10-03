import 'package:calendar_scheduler/database/drift_database.dart';
import 'package:calendar_scheduler/provider/schedule_provider.dart';
import 'package:calendar_scheduler/repository/auth_repository.dart';
import 'package:calendar_scheduler/repository/schedule_repository.dart';
import 'package:calendar_scheduler/screen/auth_screen.dart';
import 'package:calendar_scheduler/storage/token_storage.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting();

  final database = LocalDatabase();
  GetIt.I.registerSingleton<LocalDatabase>(database);

  final tokenStorage = TokenStorage();
  final authRepository = AuthRepository(tokenStorage: tokenStorage);
  final scheduleRepository = ScheduleRepository();
  final scheduleProvider = ScheduleProvider(
    scheduleRepository: scheduleRepository,
    authRepository: authRepository,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => scheduleProvider),
        Provider<AuthRepository>.value(value: authRepository),
      ],
      child: MaterialApp(
        home: AuthScreen(),
        theme: ThemeData(
          fontFamily: 'Pretendard',
          textTheme: TextTheme(
            displayLarge: TextStyle(fontFamily: 'Pretendard'),
            displayMedium: TextStyle(fontFamily: 'Pretendard'),
            displaySmall: TextStyle(fontFamily: 'Pretendard'),
            headlineLarge: TextStyle(fontFamily: 'Pretendard'),
            headlineMedium: TextStyle(fontFamily: 'Pretendard'),
            headlineSmall: TextStyle(fontFamily: 'Pretendard'),
            titleLarge: TextStyle(fontFamily: 'Pretendard'),
            titleMedium: TextStyle(fontFamily: 'Pretendard'),
            titleSmall: TextStyle(fontFamily: 'Pretendard'),
            bodyLarge: TextStyle(fontFamily: 'Pretendard'),
            bodyMedium: TextStyle(fontFamily: 'Pretendard'),
            bodySmall: TextStyle(fontFamily: 'Pretendard'),
            labelLarge: TextStyle(fontFamily: 'Pretendard'),
            labelMedium: TextStyle(fontFamily: 'Pretendard'),
            labelSmall: TextStyle(fontFamily: 'Pretendard'),
          ),
        ),
      ),
    ),
  );
}
