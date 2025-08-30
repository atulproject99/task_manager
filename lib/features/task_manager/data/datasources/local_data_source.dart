import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:task_manager/core/constants.dart';
import 'package:task_manager/features/task_manager/domain/entities/task.dart';

abstract class LocalDataSource {
  Future<List<Task>> getTasks();
  Future<void> addTask(Task task);
  Future<void> updateTask(Task task);
  Future<void> reorder(int oldIndex, int newIndex);
}

class SqfliteLocalDataSource implements LocalDataSource {
  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'tasks.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE tasks(
          id TEXT PRIMARY KEY,
          title TEXT,
          description TEXT,
          status TEXT,
          dueDate TEXT
        )
        ''');
      },
    );
  }

  @override
  Future<List<Task>> getTasks() async {
    final db = await database;
    final maps = await db.query('tasks');
    return List.generate(maps.length, (i) {
      return Task(
        id: maps[i]['id'] as String,
        title: maps[i]['title'] as String,
        description: maps[i]['description'] as String,
        status: TaskStatus.values.firstWhere(
          (e) => e.name == (maps[i]['status'] as String),
        ),
        dueDate: DateTime.parse(maps[i]['dueDate'] as String),
      );
    });
  }

  @override
  Future<void> addTask(Task task) async {
    final db = await database;
    await db.insert('tasks', {
      'id': task.id,
      'title': task.title,
      'description': task.description,
      'status': task.status.name,
      'dueDate': task.dueDate.toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<void> updateTask(Task task) async {
    final db = await database;
    await db.update(
      'tasks',
      {
        'title': task.title,
        'description': task.description,
        'status': task.status.name,
        'dueDate': task.dueDate.toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  @override
  Future<void> reorder(int oldIndex, int newIndex) async {
    final db = await database;
    final tasks = await db.query('tasks', orderBy: 'position ASC');

    if (oldIndex < 0 || oldIndex >= tasks.length) return;
    if (newIndex > tasks.length) newIndex = tasks.length;
    if (newIndex > oldIndex) newIndex -= 1;

    final movedTask = tasks.removeAt(oldIndex);
    tasks.insert(newIndex, movedTask);

    final batch = db.batch();
    for (int i = 0; i < tasks.length; i++) {
      batch.update(
        'tasks',
        {'position': i},
        where: 'id = ?',
        whereArgs: [tasks[i]['id']],
      );
    }
    await batch.commit(noResult: true);
  }
}
