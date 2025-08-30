import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/features/task_manager/domain/entities/task.dart';
import 'package:task_manager/features/task_manager/domain/usecases/add_task.dart';
import 'package:task_manager/features/task_manager/domain/usecases/filter_tasks.dart';
import 'package:task_manager/features/task_manager/domain/usecases/get_tasks.dart';
import 'package:task_manager/features/task_manager/domain/usecases/reorder_tasks.dart';
import 'package:task_manager/features/task_manager/domain/usecases/update_task.dart';
import 'package:task_manager/features/task_manager/presentation/blocs/task_bloc/task_event.dart';
import 'package:task_manager/features/task_manager/presentation/blocs/task_bloc/task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final GetTasks getTasks;
  final AddTask addTask;
  final UpdateTask updateTask;
  final FilterTasks filterTasks;
  final ReorderTasks reorderTasks;

  TaskBloc({
    required this.getTasks,
    required this.addTask,
    required this.updateTask,
    required this.filterTasks,
    required this.reorderTasks,
  }) : super(const TaskState()) {
    on<TaskStarted>(_onStarted);
    on<TaskAdded>(_onAdded);
    on<TaskUpdatedEvt>(_onUpdated);
    on<TaskStatusChanged>(_onStatusChanged);
    on<TaskFilteredEvt>(_onFiltered);
    on<TaskReorderedEvt>(_onReordered);
  }

  Future<void> _onStarted(TaskStarted event, Emitter<TaskState> emit) async {
    emit(state.copyWith(status: LoadStatus.loading));
    try {
      final tasks = await getTasks();
      emit(
        state.copyWith(status: LoadStatus.success, all: tasks, visible: tasks),
      );
    } catch (e) {
      emit(state.copyWith(status: LoadStatus.failure, error: e.toString()));
    }
  }

  Future<void> _onAdded(TaskAdded event, Emitter<TaskState> emit) async {
    await addTask(event.task);
    add(TaskFilteredEvt(state.filter));
  }

  Future<void> _onUpdated(TaskUpdatedEvt event, Emitter<TaskState> emit) async {
    await updateTask(event.task);
    add(TaskFilteredEvt(state.filter));
  }

  Future<void> _onStatusChanged(
    TaskStatusChanged event,
    Emitter<TaskState> emit,
  ) async {
    final tasks = List<Task>.from(state.all);
    final idx = tasks.indexWhere((t) => t.id == event.id);
    if (idx != -1) {
      final updated = tasks[idx].copyWith(status: event.status);
      await updateTask(updated);
      add(TaskFilteredEvt(state.filter));
    }
  }

  Future<void> _onFiltered(
    TaskFilteredEvt event,
    Emitter<TaskState> emit,
  ) async {
    emit(state.copyWith(status: LoadStatus.loading));
    try {
      final all = await getTasks();
      final filtered = event.filter == null
          ? all
          : (await filterTasks(status: event.filter));
      emit(
        state.copyWith(
          status: LoadStatus.success,
          all: all,
          visible: filtered,
          filter: event.filter,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: LoadStatus.failure, error: e.toString()));
    }
  }

  Future<void> _onReordered(
    TaskReorderedEvt event,
    Emitter<TaskState> emit,
  ) async {
    await reorderTasks(event.oldIndex, event.newIndex);
    add(TaskFilteredEvt(state.filter));
  }
}
