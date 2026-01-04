import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../../../../core/utils/enums.dart';
import '../../../../core/utils/result.dart';

part 'task_event.dart';
part 'task_state.dart';

/// BLoC for managing task state
class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskBloc({required TaskRepository repository})
      : _repository = repository,
        super(const TaskState()) {
    on<LoadTasks>(_onLoadTasks);
    on<LoadTaskById>(_onLoadTaskById);
    on<CreateTask>(_onCreateTask);
    on<UpdateTask>(_onUpdateTask);
    on<DeleteTask>(_onDeleteTask);
    on<CompleteTask>(_onCompleteTask);
    on<FilterTasks>(_onFilterTasks);
    on<SearchTasks>(_onSearchTasks);
    on<ClearFilters>(_onClearFilters);
  }

  final TaskRepository _repository;

  Future<void> _onLoadTasks(LoadTasks event, Emitter<TaskState> emit) async {
    emit(state.copyWith(status: TaskStatusEnum.loading));
    
    // Get current language from SharedPreferences to reload tasks with correct language
    String? languageCode;
    try {
      final prefs = await SharedPreferences.getInstance();
      languageCode = prefs.getString('language');
      if (languageCode != null && languageCode.isEmpty) {
        languageCode = null; // Treat empty as system default
      }
    } catch (e) {
      // Ignore, will use default
    }
    
    final result = await _repository.getTasks(
      status: state.statusFilter,
      priority: state.priorityFilter,
      category: state.categoryFilter,
      startDate: state.startDate,
      endDate: state.endDate,
      searchQuery: state.searchQuery,
      languageCode: languageCode,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: TaskStatusEnum.error,
        errorMessage: failure.message ?? 'Failed to load tasks',
      )),
      (tasks) {
        // Apply filters and search
        var filteredTasks = tasks.where((task) {
          if (state.statusFilter != null && task.status != state.statusFilter) {
            return false;
          }
          if (state.priorityFilter != null && task.priority != state.priorityFilter) {
            return false;
          }
          if (state.categoryFilter != null && task.category != state.categoryFilter) {
            return false;
          }
          if (state.startDate != null && task.dueDate != null &&
              task.dueDate!.isBefore(state.startDate!)) {
            return false;
          }
          if (state.endDate != null && task.dueDate != null &&
              task.dueDate!.isAfter(state.endDate!)) {
            return false;
          }
          if (state.searchQuery != null && state.searchQuery!.isNotEmpty) {
            final query = state.searchQuery!.toLowerCase();
            if (!task.title.toLowerCase().contains(query) &&
                (task.description?.toLowerCase().contains(query) != true)) {
              return false;
            }
          }
          return true;
        }).toList();

        emit(state.copyWith(
          status: TaskStatusEnum.loaded,
          tasks: tasks,
          filteredTasks: filteredTasks,
        ));
      },
    );
  }

  Future<void> _onLoadTaskById(
    LoadTaskById event,
    Emitter<TaskState> emit,
  ) async {
    emit(state.copyWith(selectedTaskStatus: TaskStatusEnum.loading));
    
    final result = await _repository.getTaskById(event.id);
    
    result.fold(
      (failure) => emit(state.copyWith(
        selectedTaskStatus: TaskStatusEnum.error,
        errorMessage: failure.message ?? 'Failed to load task',
      )),
      (task) => emit(state.copyWith(
        selectedTask: task,
        selectedTaskStatus: TaskStatusEnum.loaded,
      )),
    );
  }

  Future<void> _onCreateTask(
    CreateTask event,
    Emitter<TaskState> emit,
  ) async {
    emit(state.copyWith(status: TaskStatusEnum.loading));
    
    final result = await _repository.createTask(event.task);
    
    result.fold(
      (failure) => emit(state.copyWith(
        status: TaskStatusEnum.error,
        errorMessage: failure.message ?? 'Failed to create task',
      )),
      (task) {
        final updatedTasks = <Task>[task, ...state.tasks];
        emit(state.copyWith(
          status: TaskStatusEnum.loaded,
          tasks: updatedTasks,
          filteredTasks: updatedTasks,
        ));
        add(const LoadTasks());
      },
    );
  }

  Future<void> _onUpdateTask(
    UpdateTask event,
    Emitter<TaskState> emit,
  ) async {
    emit(state.copyWith(status: TaskStatusEnum.loading));
    
    final result = await _repository.updateTask(event.task);
    
    result.fold(
      (failure) => emit(state.copyWith(
        status: TaskStatusEnum.error,
        errorMessage: failure.message ?? 'Failed to update task',
      )),
      (updatedTask) {
        final updatedTasks = <Task>[
          for (final t in state.tasks)
            if (t.id == updatedTask.id) updatedTask else t
        ];
        
        emit(state.copyWith(
          status: TaskStatusEnum.loaded,
          tasks: updatedTasks,
          filteredTasks: updatedTasks,
          selectedTask: state.selectedTask?.id == updatedTask.id 
              ? updatedTask 
              : state.selectedTask,
        ));
      },
    );
  }

  Future<void> _onDeleteTask(
    DeleteTask event,
    Emitter<TaskState> emit,
  ) async {
    emit(state.copyWith(status: TaskStatusEnum.loading));
    
    final result = await _repository.deleteTask(event.id);
    
    result.fold(
      (failure) => emit(state.copyWith(
        status: TaskStatusEnum.error,
        errorMessage: failure.message ?? 'Failed to delete task',
      )),
      (_) {
        final updatedTasks = state.tasks.where((t) => t.id != event.id).toList();
        emit(state.copyWith(
          status: TaskStatusEnum.loaded,
          tasks: updatedTasks,
          filteredTasks: updatedTasks,
          selectedTask: state.selectedTask?.id == event.id 
              ? null 
              : state.selectedTask,
        ));
      },
    );
  }

  Future<void> _onCompleteTask(
    CompleteTask event,
    Emitter<TaskState> emit,
  ) async {
    emit(state.copyWith(status: TaskStatusEnum.loading));
    
    final result = await _repository.completeTask(event.id);
    
    result.fold(
      (failure) => emit(state.copyWith(
        status: TaskStatusEnum.error,
        errorMessage: failure.message ?? 'Failed to complete task',
      )),
      (completedTask) {
        final updatedTasks = <Task>[
          for (final t in state.tasks)
            if (t.id == completedTask.id) completedTask else t
        ];
        
        emit(state.copyWith(
          status: TaskStatusEnum.loaded,
          tasks: updatedTasks,
          filteredTasks: updatedTasks,
        ));
        add(const LoadTasks());
      },
    );
  }

  Future<void> _onFilterTasks(
    FilterTasks event,
    Emitter<TaskState> emit,
  ) async {
    emit(state.copyWith(
      statusFilter: event.status,
      priorityFilter: event.priority,
      categoryFilter: event.category,
      startDate: event.startDate,
      endDate: event.endDate,
    ));
    
    add(const LoadTasks());
  }

  Future<void> _onSearchTasks(
    SearchTasks event,
    Emitter<TaskState> emit,
  ) async {
    emit(state.copyWith(searchQuery: event.query));
    
    if (event.query.isEmpty) {
      emit(state.copyWith(filteredTasks: state.tasks));
    } else {
      final result = await _repository.searchTasks(event.query);
      result.fold(
        (failure) {
          emit(state.copyWith(
            status: TaskStatusEnum.error,
            errorMessage: failure.message,
          ));
        },
        (tasks) {
          emit(state.copyWith(
            filteredTasks: tasks,
            status: TaskStatusEnum.loaded,
          ));
        },
      );
    }
  }

  Future<void> _onClearFilters(
    ClearFilters event,
    Emitter<TaskState> emit,
  ) async {
    emit(state.copyWith(
      statusFilter: null,
      priorityFilter: null,
      categoryFilter: null,
      startDate: null,
      endDate: null,
      searchQuery: null,
      filteredTasks: state.tasks,
    ));
  }
}

