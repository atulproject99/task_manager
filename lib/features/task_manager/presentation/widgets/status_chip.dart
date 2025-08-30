import 'package:flutter/material.dart';
import 'package:task_manager/core/constants.dart';

class StatusChip extends StatelessWidget {
  final TaskStatus status;
  const StatusChip(this.status, {super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: statusColor(status, context).withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: statusColor(status, context)),
      ),
      child: Text(
        status.label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: statusColor(status, context),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
