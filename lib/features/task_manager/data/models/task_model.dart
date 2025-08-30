import 'package:task_manager/core/constants.dart';
import 'package:task_manager/features/task_manager/domain/entities/task.dart';

class TaskModel extends Task {
  const TaskModel({
    required super.id,
    required super.title,
    required super.description,
    required super.status,
    required super.dueDate,
  });

  factory TaskModel.fromEntity(Task task) => TaskModel(
    id: task.id,
    title: task.title,
    description: task.description,
    status: task.status,
    dueDate: task.dueDate,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'status': status.name,
    'dueDate': dueDate.toIso8601String(),
  };

  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
    id: json['id'] as String,
    title: json['title'] as String,
    description: json['description'] as String,
    status: TaskStatus.values.firstWhere(
      (e) => e.name == (json['status'] as String),
    ),
    dueDate: DateTime.parse(json['dueDate'] as String),
  );
}
