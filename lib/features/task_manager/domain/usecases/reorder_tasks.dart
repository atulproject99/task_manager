import 'package:task_manager/features/task_manager/domain/repositories/task_repository.dart';

class ReorderTasks {
  final TaskRepository repository;
  ReorderTasks(this.repository);

  Future<void> call(int oldIndex, int newIndex) =>
      repository.reorder(oldIndex, newIndex);
}
