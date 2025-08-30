import 'package:flutter/material.dart';
import 'package:task_manager/core/app_colors.dart';

enum TaskStatus { todo, inProgress, done }

extension TaskStatusLabel on TaskStatus {
  String get label {
    switch (this) {
      case TaskStatus.todo:
        return 'To Do';
      case TaskStatus.inProgress:
        return 'In Progress';
      case TaskStatus.done:
        return 'Done';
    }
  }
}

Color statusColor(TaskStatus status, BuildContext context) {
  switch (status) {
    case TaskStatus.todo:
      return AppColors.darkSkyBlue;
    case TaskStatus.inProgress:
      return AppColors.purple;
    case TaskStatus.done:
      return AppColors.green;
  }
}
