# Task Manager

A Flutter **Task Manager** app built with **BLoC** state management and **Clean Architecture**.  
It allows you to create, edit, update, filter, and reorder tasks with persistent storage using **SQLite (sqflite)**.

---

## 🏗 Architecture Overview

This project follows **Clean Architecture** with three main layers:

### 1. Presentation Layer
- Contains **UI** (screens & widgets) and **BLoC** for state management.
- `TaskBloc` handles events like `AddTask`, `UpdateTask`, `FilterTask`, `ReorderTask`.
- `ThemeCubit` manages light/dark mode (saved in `SharedPreferences`).

### 2. Domain Layer
- Defines **business logic** and app rules.
- Includes:
  - **Entities** → e.g., `Task`
  - **Repositories (abstract)** → defines contracts
  - **Use Cases** → e.g., `GetTasks`, `AddTask`, `UpdateTask`, `FilterTasks`, `ReorderTasks`

### 3. Data Layer
- Responsible for talking to **local storage (SQLite)**.
- `SqfliteLocalDataSource` manages CRUD operations.
- `TaskRepositoryImpl` implements `TaskRepository` and connects domain ↔ data.

---


---

## ✨ Features

- Add / Edit / Delete tasks  
- Change status (`To Do`, `In Progress`, `Done`)  
- Filter tasks by status  
- Drag-and-drop reorder with persistence  
- Light & Dark theme with saved preference  
- Unit & widget tests included

