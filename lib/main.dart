import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/theme/app_theme.dart';
import 'package:task_manager/features/task_manager/data/datasources/local_data_source.dart';
import 'package:task_manager/features/task_manager/data/repositories/task_repository_impl.dart';
import 'package:task_manager/features/task_manager/domain/usecases/add_task.dart';
import 'package:task_manager/features/task_manager/domain/usecases/filter_tasks.dart';
import 'package:task_manager/features/task_manager/domain/usecases/get_tasks.dart';
import 'package:task_manager/features/task_manager/domain/usecases/reorder_tasks.dart';
import 'package:task_manager/features/task_manager/domain/usecases/update_task.dart';
import 'package:task_manager/features/task_manager/presentation/blocs/task_bloc/task_bloc.dart';
import 'package:task_manager/features/task_manager/presentation/blocs/task_bloc/task_event.dart';
import 'package:task_manager/features/task_manager/presentation/blocs/theme_cubit.dart';
import 'package:task_manager/features/task_manager/presentation/screens/task_list_screen.dart';

void main() {
  final local = SqfliteLocalDataSource();
  final repo = TaskRepositoryImpl(local);

  runApp(MyApp(repo: repo));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.repo});
  final TaskRepositoryImpl repo;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(
          create: (_) => TaskBloc(
            getTasks: GetTasks(repo),
            addTask: AddTask(repo),
            updateTask: UpdateTask(repo),
            filterTasks: FilterTasks(repo),
            reorderTasks: ReorderTasks(repo),
          )..add(TaskStarted()),
        ),
      ],
      child: BlocBuilder<ThemeCubit, bool>(
        builder: (context, isDarkMode) {
          return MaterialApp(
            title: 'Task Manager demo',
            debugShowCheckedModeBanner: false,
            themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            home: const TaskListScreen(),
          );
        },
      ),
    );
  }
}
