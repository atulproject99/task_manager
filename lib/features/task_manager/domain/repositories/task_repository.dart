import 'package:task_manager/core/constants.dart';
import 'package:task_manager/features/task_manager/domain/entities/task.dart';

abstract class TaskRepository {
  Future<List<Task>> getTasks();
  Future<void> addTask(Task task);
  Future<void> updateTask(Task task);
  Future<void> reorder(int oldIndex, int newIndex);
  Future<List<Task>> filterTasks({TaskStatus? status});
}
