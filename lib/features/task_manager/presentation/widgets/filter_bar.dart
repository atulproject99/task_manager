import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/constants.dart';
import 'package:task_manager/features/task_manager/presentation/blocs/task_bloc/task_bloc.dart';
import 'package:task_manager/features/task_manager/presentation/blocs/task_bloc/task_event.dart';

class FilterBar extends StatelessWidget {
  const FilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    final selected = context.select<TaskBloc, TaskStatus?>(
      (b) => b.state.filter,
    );
    FilterChip chip(TaskStatus? status, String label) => FilterChip(
      label: Text(label),
      selected: selected == status,
      onSelected: (_) => context.read<TaskBloc>().add(TaskFilteredEvt(status)),
    );

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        chip(null, 'All'),
        chip(TaskStatus.todo, TaskStatus.todo.label),
        chip(TaskStatus.inProgress, TaskStatus.inProgress.label),
        chip(TaskStatus.done, TaskStatus.done.label),
      ],
    );
  }
}
