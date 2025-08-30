import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:task_manager/features/task_manager/presentation/blocs/task_bloc/task_bloc.dart';
import 'package:task_manager/features/task_manager/presentation/blocs/task_bloc/task_event.dart';
import 'package:task_manager/features/task_manager/presentation/blocs/task_bloc/task_state.dart';
import 'package:task_manager/features/task_manager/presentation/blocs/theme_cubit.dart';
import 'package:task_manager/features/task_manager/presentation/widgets/empty_view.dart';
import 'package:task_manager/features/task_manager/presentation/widgets/filter_bar.dart';
import 'package:task_manager/features/task_manager/presentation/widgets/task_tile.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Manager'),
        actions: [
          IconButton(
            tooltip: 'Toggle theme',
            onPressed: () => context.read<ThemeCubit>().toggle(),
            icon: const Icon(Icons.brightness_6),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.add),
            tooltip: 'Add',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const FilterBar(),
            const SizedBox(height: 8),
            Expanded(
              child: BlocBuilder<TaskBloc, TaskState>(
                builder: (context, state) {
                  if (state.status == LoadStatus.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state.visible.isEmpty) {
                    return const EmptyView(message: 'No tasks to show');
                  }
                  return ReorderableListView.builder(
                    itemCount: state.visible.length,
                    onReorder: (oldIndex, newIndex) {
                      context.read<TaskBloc>().add(
                        TaskReorderedEvt(oldIndex, newIndex),
                      );
                    },
                    itemBuilder: (context, index) {
                      final task = state.visible[index];
                      return Card(
                        key: ValueKey('${task.id}_card'),
                        child: TaskTile(task: task, onTap: () {}),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.add_task),
        label: const Text('New Task'),
      ),
    );
  }
}
