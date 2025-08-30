import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/core/constants.dart';
import 'package:task_manager/features/task_manager/domain/entities/task.dart';
import 'package:task_manager/features/task_manager/presentation/blocs/task_bloc/task_bloc.dart';
import 'package:task_manager/features/task_manager/presentation/blocs/task_bloc/task_event.dart';
import 'package:task_manager/features/task_manager/presentation/widgets/status_chip.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;
  const TaskTile({required this.task, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat.yMMMd().format(task.dueDate);
    return Dismissible(
      key: ValueKey(task.id),
      background: Container(
        color: Colors.green,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: const Icon(Icons.check, color: Colors.white),
      ),
      secondaryBackground: Container(
        color: Colors.orange,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: const Icon(Icons.timelapse, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        final bloc = context.read<TaskBloc>();
        if (direction == DismissDirection.startToEnd) {
          bloc.add(TaskStatusChanged(task.id, TaskStatus.done));
        } else {
          bloc.add(TaskStatusChanged(task.id, TaskStatus.inProgress));
        }
        return false;
      },
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        onTap: onTap,
        leading: Icon(Icons.task_alt, color: statusColor(task.status, context)),
        title: Text(task.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              task.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                StatusChip(task.status),
                const SizedBox(width: 8),
                Text('Due: $dateStr'),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton<TaskStatus>(
          onSelected: (st) {
            context.read<TaskBloc>().add(TaskStatusChanged(task.id, st));
          },
          itemBuilder: (context) => [
            const PopupMenuItem(value: TaskStatus.todo, child: Text('To Do')),
            const PopupMenuItem(
              value: TaskStatus.inProgress,
              child: Text('In Progress'),
            ),
            const PopupMenuItem(value: TaskStatus.done, child: Text('Done')),
          ],
          icon: const Icon(Icons.more_vert),
        ),
      ),
    );
  }
}
