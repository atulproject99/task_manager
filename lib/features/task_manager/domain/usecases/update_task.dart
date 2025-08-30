import 'package:task_manager/features/task_manager/domain/entities/task.dart';
import 'package:task_manager/features/task_manager/domain/repositories/task_repository.dart';

class UpdateTask {
  final TaskRepository repository;
  UpdateTask(this.repository);

  Future<void> call(Task task) => repository.updateTask(task);
}
