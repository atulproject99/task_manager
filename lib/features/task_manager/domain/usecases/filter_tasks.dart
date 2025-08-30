import 'package:task_manager/core/constants.dart';
import 'package:task_manager/features/task_manager/domain/entities/task.dart';
import 'package:task_manager/features/task_manager/domain/repositories/task_repository.dart';

class FilterTasks {
  final TaskRepository repository;
  FilterTasks(this.repository);

  Future<List<Task>> call({TaskStatus? status}) =>
      repository.filterTasks(status: status);
}
