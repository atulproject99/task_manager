import 'package:equatable/equatable.dart';
import 'package:task_manager/core/constants.dart';
import 'package:task_manager/features/task_manager/domain/entities/task.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();
  @override
  List<Object?> get props => [];
}

class TaskStarted extends TaskEvent {}

class TaskAdded extends TaskEvent {
  final Task task;
  const TaskAdded(this.task);
  @override
  List<Object?> get props => [task];
}

class TaskUpdatedEvt extends TaskEvent {
  final Task task;
  const TaskUpdatedEvt(this.task);
  @override
  List<Object?> get props => [task];
}

class TaskStatusChanged extends TaskEvent {
  final String id;
  final TaskStatus status;
  const TaskStatusChanged(this.id, this.status);
  @override
  List<Object?> get props => [id, status];
}

class TaskFilteredEvt extends TaskEvent {
  final TaskStatus? filter;
  const TaskFilteredEvt(this.filter);
  @override
  List<Object?> get props => [filter];
}

class TaskReorderedEvt extends TaskEvent {
  final int oldIndex;
  final int newIndex;
  const TaskReorderedEvt(this.oldIndex, this.newIndex);
  @override
  List<Object?> get props => [oldIndex, newIndex];
}
