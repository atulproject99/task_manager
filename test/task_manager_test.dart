import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:task_manager/core/constants.dart';
import 'package:task_manager/features/task_manager/data/datasources/local_data_source.dart';
import 'package:task_manager/features/task_manager/data/repositories/task_repository_impl.dart';
import 'package:task_manager/features/task_manager/domain/entities/task.dart';

void main() {
  late TaskRepositoryImpl repo;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() {
    repo = TaskRepositoryImpl(SqfliteLocalDataSource());
  });

  test('Add and fetch task', () async {
    final task = Task(
      id: 't100',
      title: 'Unit Test Task',
      description: 'Testing SQLite insert',
      status: TaskStatus.todo,
      dueDate: DateTime.now(),
    );

    await repo.addTask(task);

    final tasks = await repo.getTasks();
    expect(tasks.any((t) => t.id == 't100'), true);
  });

  test('Update task', () async {
    final task = Task(
      id: 't101',
      title: 'Update Test',
      description: 'Before update',
      status: TaskStatus.todo,
      dueDate: DateTime.now(),
    );

    await repo.addTask(task);

    final updated = task.copyWith(
      description: 'After update',
      status: TaskStatus.done,
    );

    await repo.updateTask(updated);

    final tasks = await repo.getTasks();
    final fetched = tasks.firstWhere((t) => t.id == 't101');
    expect(fetched.description, 'After update');
    expect(fetched.status, TaskStatus.done);
  });

  test('Filter tasks by status', () async {
    final task = Task(
      id: 't102',
      title: 'Filter Test',
      description: 'Testing filter',
      status: TaskStatus.inProgress,
      dueDate: DateTime.now(),
    );

    await repo.addTask(task);

    final filtered = await repo.filterTasks(status: TaskStatus.inProgress);
    expect(filtered.any((t) => t.id == 't102'), true);
  });
}
