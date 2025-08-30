import 'package:task_manager/features/task_manager/domain/entities/task.dart';
import 'package:task_manager/features/task_manager/domain/repositories/task_repository.dart';

class AddTask {
  final TaskRepository repository;
  AddTask(this.repository);

  Future<void> call(Task task) => repository.addTask(task);
}
