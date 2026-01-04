import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/route_names.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/error_widget.dart';
import '../bloc/task_bloc.dart';
import '../widgets/task_card.dart';
import '../widgets/voice_input_button.dart';
import '../widgets/focus_mode_widget.dart';
import '../../../../core/utils/enums.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../data/services/export_service.dart';
import '../../data/services/import_service.dart';
import '../../data/models/task_model.dart';
import '../../domain/entities/task.dart';
import 'task_details_page.dart';
import '../../../../features/auth/presentation/bloc/auth_bloc.dart' as auth;
import '../../../../injection.dart' as di;
import 'package:confetti/confetti.dart';

/// Tasks list page
class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final _searchController = TextEditingController();
  TaskStatus? _statusFilter;
  TaskPriority? _priorityFilter;
  TaskCategory? _categoryFilter;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.tasks),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
          PopupMenuButton(
            itemBuilder: (context) => <PopupMenuEntry<String>>[
              PopupMenuItem(
                value: 'export_csv',
                child: Row(
                  children: [
                    const Icon(Icons.file_download),
                    const SizedBox(width: 8),
                    Text(l10n.exportCSV),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'export_json',
                child: Row(
                  children: [
                    const Icon(Icons.file_download),
                    const SizedBox(width: 8),
                    Text(l10n.exportJSON),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'export_pdf',
                child: Row(
                  children: [
                    const Icon(Icons.picture_as_pdf),
                    const SizedBox(width: 8),
                    Text(l10n.exportPDF),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem(
                value: 'import_csv',
                child: Row(
                  children: [
                    const Icon(Icons.file_upload),
                    const SizedBox(width: 8),
                    Text(l10n.importCSV),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'import_json',
                child: Row(
                  children: [
                    const Icon(Icons.file_upload),
                    const SizedBox(width: 8),
                    Text(l10n.importJSON),
                  ],
                ),
              ),
            ],
            onSelected: (value) async {
              final tasks = context.read<TaskBloc>().state.filteredTasks;
              
              switch (value) {
                case 'export_csv':
                  await ExportService().exportToCSV(tasks);
                  break;
                case 'export_json':
                  await ExportService().exportToJSON(tasks);
                  break;
                case 'export_pdf':
                  await ExportService().exportToPDF(tasks);
                  break;
                case 'import_csv':
                  try {
                    final importService = ImportService();
                    final importedTasks = await importService.importFromCSV();
                    for (final task in importedTasks) {
                      context.read<TaskBloc>().add(CreateTask(task));
                    }
                    if (mounted) {
                      final l10n = AppLocalizations.of(context)!;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.importedTasks(importedTasks.length))),
                      );
                    }
                  } catch (e) {
                    if (mounted) {
                      final l10n = AppLocalizations.of(context)!;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${l10n.importFailed}: $e'),
                          backgroundColor: Theme.of(context).colorScheme.error,
                        ),
                      );
                    }
                  }
                  break;
                case 'import_json':
                  try {
                    final importService = ImportService();
                    final importedTasks = await importService.importFromJSON();
                    for (final task in importedTasks) {
                      context.read<TaskBloc>().add(CreateTask(task));
                    }
                    if (mounted) {
                      final l10n = AppLocalizations.of(context)!;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.importedTasks(importedTasks.length))),
                      );
                    }
                  } catch (e) {
                    if (mounted) {
                      final l10n = AppLocalizations.of(context)!;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${l10n.importFailed}: $e'),
                          backgroundColor: Theme.of(context).colorScheme.error,
                        ),
                      );
                    }
                  }
                  break;
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Only show FocusModeWidget if we have tasks loaded
          BlocBuilder<TaskBloc, TaskState>(
            builder: (context, state) {
              if (state.status == TaskStatusEnum.loaded) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppConstants.defaultPadding,
                    AppConstants.defaultPadding,
                    AppConstants.defaultPadding,
                    0,
                  ),
                  child: FocusModeWidget(),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          Padding(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: l10n.searchTasks,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          context.read<TaskBloc>().add(const SearchTasks(''));
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                context.read<TaskBloc>().add(SearchTasks(value));
              },
            ),
          ),
          Expanded(
            child: BlocConsumer<TaskBloc, TaskState>(
              listener: (context, state) {
                if (state.errorMessage != null && mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.errorMessage!),
                      backgroundColor: Theme.of(context).colorScheme.error,
                    ),
                  );
                }
              },
              builder: (context, state) {
                // Handle loading state
                if (state.status == TaskStatusEnum.loading) {
                  return const LoadingWidget();
                }

                // Handle error state
                if (state.status == TaskStatusEnum.error) {
                  return ErrorDisplayWidget(
                    message: state.errorMessage ?? 'Failed to load tasks',
                    onRetry: () {
                      context.read<TaskBloc>().add(const LoadTasks());
                    },
                  );
                }

                // Safely get tasks
                final tasks = state.filteredTasks;
                
                // If tasks is null or not initialized, show loading
                if (tasks.isEmpty && state.status != TaskStatusEnum.loaded) {
                  return const LoadingWidget();
                }

                if (tasks.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.task_alt,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: AppConstants.defaultPadding),
                        Text(
                          'No tasks found',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Create your first task to get started',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<TaskBloc>().add(const LoadTasks());
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(AppConstants.defaultPadding),
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return TaskCard(
                        task: task,
                        onTap: () {
                          context.read<TaskBloc>().add(LoadTaskById(task.id));
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BlocProvider.value(
                                value: context.read<TaskBloc>(),
                                child: BlocProvider(
                                  create: (_) => di.getIt<auth.AuthBloc>()..add(const auth.CheckAuthStatus()),
                                  child: const TaskDetailsPage(),
                                ),
                              ),
                              settings: RouteSettings(arguments: task.id),
                            ),
                          );
                        },
                        onComplete: () {
                          _handleTaskComplete(context, task);
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          VoiceInputButton(
            onResult: (text) {
              if (text.isNotEmpty) {
                _createTaskFromVoice(text);
              }
            },
            onListening: (isListening) {
              if (isListening && mounted) {
                final l10n = AppLocalizations.of(context)!;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.listening)),
                );
              }
            },
          ),
          const SizedBox(height: 8),
          FloatingActionButton.extended(
            onPressed: () {
              _showCreateTaskDialog(context);
            },
            icon: const Icon(Icons.add),
            label: Text(l10n.newTask),
          ),
        ],
      ),
    );
  }

  void _handleTaskComplete(BuildContext context, dynamic task) {
    String? taskId;
    if (task is TaskModel) {
      taskId = task.id;
    } else if (task is Task) {
      taskId = task.id;
    } else {
      return;
    }
    
    if (taskId == null) return;
    context.read<TaskBloc>().add(CompleteTask(taskId));
    
    // Show confetti animation
    final confettiController = ConfettiController(duration: const Duration(seconds: 1));
    confettiController.play();
    
    Overlay.of(context).insert(
      OverlayEntry(
        builder: (_) => Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: confettiController,
            blastDirection: 3.14 / 2,
            emissionFrequency: 0.05,
            numberOfParticles: 20,
            gravity: 0.3,
          ),
        ),
      ),
    );
    
    Future.delayed(const Duration(seconds: 1), () {
      confettiController.dispose();
    });
    
    // Reload tasks
    context.read<TaskBloc>().add(const LoadTasks());
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Tasks'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _FilterSection(
                title: 'Status',
                options: TaskStatus.values,
                selected: _statusFilter,
                onChanged: (value) {
                  setState(() {
                    _statusFilter = value as TaskStatus?;
                  });
                },
              ),
              const Divider(),
              _FilterSection(
                title: 'Priority',
                options: TaskPriority.values,
                selected: _priorityFilter,
                onChanged: (value) {
                  setState(() {
                    _priorityFilter = value as TaskPriority?;
                  });
                },
              ),
              const Divider(),
              _FilterSection(
                title: 'Category',
                options: TaskCategory.values,
                selected: _categoryFilter,
                onChanged: (value) {
                  setState(() {
                    _categoryFilter = value as TaskCategory?;
                  });
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _statusFilter = null;
                _priorityFilter = null;
                _categoryFilter = null;
              });
              context.read<TaskBloc>().add(const ClearFilters());
              Navigator.pop(context);
            },
            child: const Text('Clear'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<TaskBloc>().add(FilterTasks(
                    status: _statusFilter,
                    priority: _priorityFilter,
                    category: _categoryFilter,
                  ));
              Navigator.pop(context);
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  void _createTaskFromVoice(String text) {
    if (text.trim().isEmpty) return;
    
    final task = TaskModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: text.trim(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    context.read<TaskBloc>().add(CreateTask(task));
    if (mounted) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.taskCreatedFromVoice)),
      );
    }
  }

  void _showCreateTaskDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.createTask),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: l10n.title,
                  hintText: l10n.enterTaskTitle,
                ),
                autofocus: true,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: l10n.description,
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.pleaseEnterTaskTitle)),
                );
                return;
              }
              final task = TaskModel(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                title: titleController.text.trim(),
                description: descriptionController.text.trim().isEmpty
                    ? null
                    : descriptionController.text.trim(),
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              );
              context.read<TaskBloc>().add(CreateTask(task));
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
            child: Text(l10n.create),
          ),
        ],
      ),
    );
  }
}

class _FilterSection<T> extends StatelessWidget {
  const _FilterSection({
    required this.title,
    required this.options,
    this.selected,
    required this.onChanged,
  });

  final String title;
  final List<T> options;
  final T? selected;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        ...options.map((option) {
          return RadioListTile<T>(
            title: Text(option.toString().split('.').last.capitalize),
            value: option,
            groupValue: selected,
            onChanged: (value) => onChanged(value),
          );
        }),
      ],
    );
  }
}

