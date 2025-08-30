import 'package:equatable/equatable.dart';
import 'package:task_manager/core/constants.dart';
import 'package:task_manager/features/task_manager/domain/entities/task.dart';

enum LoadStatus { initial, loading, success, failure }

class TaskState extends Equatable {
  final LoadStatus status;
  final List<Task> all;
  final List<Task> visible;
  final TaskStatus? filter;
  final String? error;

  const TaskState({
    this.status = LoadStatus.initial,
    this.all = const [],
    this.visible = const [],
    this.filter,
    this.error,
  });

  TaskState copyWith({
    LoadStatus? status,
    List<Task>? all,
    List<Task>? visible,
    TaskStatus? filter,
    String? error,
  }) {
    return TaskState(
      status: status ?? this.status,
      all: all ?? this.all,
      visible: visible ?? this.visible,
      filter: filter ?? this.filter,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, all, visible, filter, error];
}
