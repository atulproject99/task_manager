import 'package:task_manager/core/constants.dart';
import 'package:task_manager/features/task_manager/data/datasources/local_data_source.dart';
import 'package:task_manager/features/task_manager/domain/entities/task.dart';
import 'package:task_manager/features/task_manager/domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final LocalDataSource local;

  TaskRepositoryImpl(this.local);

  @override
  Future<void> addTask(Task task) => local.addTask(task);

  @override
  Future<List<Task>> getTasks() => local.getTasks();

  @override
  Future<void> updateTask(Task task) => local.updateTask(task);

  @override
  Future<void> reorder(int oldIndex, int newIndex) =>
      local.reorder(oldIndex, newIndex);

  @override
  Future<List<Task>> filterTasks({TaskStatus? status}) async {
    final tasks = await local.getTasks();
    if (status == null) return tasks;
    return tasks.where((t) => t.status == status).toList();
  }
}
