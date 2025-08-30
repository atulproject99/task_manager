import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/core/constants.dart';
import 'package:task_manager/features/task_manager/domain/entities/task.dart';
import 'package:task_manager/features/task_manager/presentation/blocs/task_bloc/task_bloc.dart';
import 'package:task_manager/features/task_manager/presentation/blocs/task_bloc/task_event.dart';

class AddEditTaskScreen extends StatefulWidget {
  final Task? task;
  const AddEditTaskScreen({this.task, super.key});

  @override
  State<AddEditTaskScreen> createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends State<AddEditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleCtrl;
  late TextEditingController _descCtrl;
  late TaskStatus _status;
  DateTime _dueDate = DateTime.now().add(const Duration(days: 1));

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.task?.title ?? '');
    _descCtrl = TextEditingController(text: widget.task?.description ?? '');
    _status = widget.task?.status ?? TaskStatus.todo;
    _dueDate = widget.task?.dueDate ?? _dueDate;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (picked != null) setState(() => _dueDate = picked);
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final id =
        widget.task?.id ?? DateTime.now().millisecondsSinceEpoch.toString();
    final task = Task(
      id: id,
      title: _titleCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      status: _status,
      dueDate: _dueDate,
    );
    final bloc = context.read<TaskBloc>();
    if (widget.task == null) {
      bloc.add(TaskAdded(task));
    } else {
      bloc.add(TaskUpdatedEvt(task));
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat.yMMMd().format(_dueDate);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'Add Task' : 'Edit Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleCtrl,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  if (v == null || v.trim().length < 3) {
                    return 'Title must be at least 3 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _descCtrl,
                minLines: 2,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<TaskStatus>(
                value: _status,
                items: const [
                  DropdownMenuItem(
                    value: TaskStatus.todo,
                    child: Text('To Do'),
                  ),
                  DropdownMenuItem(
                    value: TaskStatus.inProgress,
                    child: Text('In Progress'),
                  ),
                  DropdownMenuItem(value: TaskStatus.done, child: Text('Done')),
                ],
                onChanged: (val) =>
                    setState(() => _status = val ?? TaskStatus.todo),
                decoration: const InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Due Date'),
                subtitle: Text(dateStr),
                trailing: IconButton(
                  icon: const Icon(Icons.date_range),
                  onPressed: _pickDate,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.save),
                label: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
