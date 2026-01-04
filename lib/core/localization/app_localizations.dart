import 'package:flutter/material.dart';

/// Simple localization class
class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'appName': 'TaskFlow AI',
      'dashboard': 'Dashboard',
      'tasks': 'Tasks',
      'calendar': 'Calendar',
      'analytics': 'Analytics',
      'settings': 'Settings',
      'createTask': 'Create Task',
      'editTask': 'Edit Task',
      'deleteTask': 'Delete Task',
      'completeTask': 'Complete Task',
      'taskTitle': 'Task Title',
      'taskDescription': 'Task Description',
      'save': 'Save',
      'cancel': 'Cancel',
      'search': 'Search',
      'filter': 'Filter',
      'noTasks': 'No tasks found',
      'loading': 'Loading...',
      'error': 'Error',
      'retry': 'Retry',
      'appearance': 'Appearance',
      'theme': 'Theme',
      'light': 'Light',
      'dark': 'Dark',
      'system': 'System',
      'colorScheme': 'Color Scheme',
      'professional': 'Professional',
      'creative': 'Creative',
      'calm': 'Calm',
      'notifications': 'Notifications',
      'pushNotifications': 'Push Notifications',
      'reminders': 'Reminders',
      'general': 'General',
      'language': 'Language',
      'english': 'English',
      'russian': 'Russian',
      'spanish': 'Spanish',
      'backupSync': 'Backup & Sync',
      'helpSupport': 'Help & Support',
      'about': 'About',
      'version': 'Version',
      'newTask': 'New Task',
      'selectTheme': 'Select Theme',
      'selectColorScheme': 'Select Color Scheme',
      'selectLanguage': 'Select Language',
      'title': 'Title',
      'description': 'Description',
      'priority': 'Priority',
      'status': 'Status',
      'category': 'Category',
      'dueDate': 'Due Date',
      'tags': 'Tags',
      'comments': 'Comments',
      'addComment': 'Add Comment',
      'edit': 'Edit',
      'delete': 'Delete',
      'complete': 'Complete',
      'pending': 'Pending',
      'inProgress': 'In Progress',
      'completed': 'Completed',
      'cancelled': 'Cancelled',
      'high': 'High',
      'medium': 'Medium',
      'low': 'Low',
      'none': 'None',
      'today': 'Today',
      'upcoming': 'Upcoming',
      'overdue': 'Overdue',
      'completed': 'Completed',
      'allTasks': 'All Tasks',
      'quickStats': 'Quick Stats',
      'exportCSV': 'Export CSV',
      'exportJSON': 'Export JSON',
      'exportPDF': 'Export PDF',
      'importCSV': 'Import CSV',
      'importJSON': 'Import JSON',
      'newTask': 'New Task',
      'taskCreatedFromVoice': 'Task created from voice!',
      'listening': 'Listening...',
      'importedTasks': 'Imported {count} tasks',
      'importFailed': 'Import failed',
      'pleaseEnterTaskTitle': 'Please enter a task title',
      'titleCannotBeEmpty': 'Title cannot be empty',
      'noTasksFound': 'No tasks found',
      'searchTasks': 'Search tasks...',
      'create': 'Create',
      'enterTaskTitle': 'Enter task title',
      'personal': 'Personal',
      'work': 'Work',
      'shopping': 'Shopping',
      'health': 'Health',
      'finance': 'Finance',
      'travel': 'Travel',
      'education': 'Education',
      'other': 'Other',
      'welcomeBack': 'Welcome back!',
      'createAccount': 'Create your account',
      'email': 'Email',
      'password': 'Password',
      'pleaseEnterEmail': 'Please enter your email',
      'pleaseEnterValidEmail': 'Please enter a valid email',
      'pleaseEnterPassword': 'Please enter your password',
      'passwordMustBeAtLeast': 'Password must be at least 6 characters',
      'forgotPassword': 'Forgot Password?',
      'signIn': 'Sign In',
      'signUp': 'Sign Up',
      'dontHaveAccount': "Don't have an account? Sign Up",
      'alreadyHaveAccount': 'Already have an account? Sign In',
      'or': 'OR',
      'continueAsGuest': 'Continue as Guest (Demo)',
      'authenticationFailed': 'Authentication failed',
    },
    'ru': {
      'appName': 'TaskFlow AI',
      'dashboard': 'Панель управления',
      'tasks': 'Задачи',
      'calendar': 'Календарь',
      'analytics': 'Аналитика',
      'settings': 'Настройки',
      'createTask': 'Создать задачу',
      'editTask': 'Редактировать задачу',
      'deleteTask': 'Удалить задачу',
      'completeTask': 'Завершить задачу',
      'taskTitle': 'Название задачи',
      'taskDescription': 'Описание задачи',
      'save': 'Сохранить',
      'cancel': 'Отмена',
      'search': 'Поиск',
      'filter': 'Фильтр',
      'noTasks': 'Задачи не найдены',
      'loading': 'Загрузка...',
      'error': 'Ошибка',
      'retry': 'Повторить',
      'appearance': 'Внешний вид',
      'theme': 'Тема',
      'light': 'Светлая',
      'dark': 'Темная',
      'system': 'Системная',
      'colorScheme': 'Цветовая схема',
      'professional': 'Профессиональная',
      'creative': 'Креативная',
      'calm': 'Спокойная',
      'notifications': 'Уведомления',
      'pushNotifications': 'Push-уведомления',
      'reminders': 'Напоминания',
      'general': 'Основные',
      'language': 'Язык',
      'english': 'Английский',
      'russian': 'Русский',
      'spanish': 'Испанский',
      'backupSync': 'Резервное копирование и синхронизация',
      'helpSupport': 'Помощь и поддержка',
      'about': 'О приложении',
      'version': 'Версия',
      'newTask': 'Новая задача',
      'selectTheme': 'Выбрать тему',
      'selectColorScheme': 'Выбрать цветовую схему',
      'selectLanguage': 'Выбрать язык',
      'title': 'Название',
      'description': 'Описание',
      'priority': 'Приоритет',
      'status': 'Статус',
      'category': 'Категория',
      'dueDate': 'Срок выполнения',
      'tags': 'Теги',
      'comments': 'Комментарии',
      'addComment': 'Добавить комментарий',
      'edit': 'Редактировать',
      'delete': 'Удалить',
      'complete': 'Завершить',
      'pending': 'В ожидании',
      'inProgress': 'В процессе',
      'completed': 'Завершено',
      'cancelled': 'Отменено',
      'high': 'Высокий',
      'medium': 'Средний',
      'low': 'Низкий',
      'none': 'Нет',
      'today': 'Сегодня',
      'upcoming': 'Предстоящие',
      'overdue': 'Просроченные',
      'completed': 'Завершено',
      'allTasks': 'Все задачи',
      'quickStats': 'Быстрая статистика',
      'exportCSV': 'Экспорт CSV',
      'exportJSON': 'Экспорт JSON',
      'exportPDF': 'Экспорт PDF',
      'importCSV': 'Импорт CSV',
      'importJSON': 'Импорт JSON',
      'newTask': 'Новая задача',
      'taskCreatedFromVoice': 'Задача создана из голосового ввода!',
      'listening': 'Слушаю...',
      'importedTasks': 'Импортировано {count} задач',
      'importFailed': 'Ошибка импорта',
      'pleaseEnterTaskTitle': 'Пожалуйста, введите название задачи',
      'titleCannotBeEmpty': 'Название не может быть пустым',
      'noTasksFound': 'Задачи не найдены',
      'searchTasks': 'Поиск задач...',
      'create': 'Создать',
      'enterTaskTitle': 'Введите название задачи',
      'personal': 'Личное',
      'work': 'Работа',
      'shopping': 'Покупки',
      'health': 'Здоровье',
      'finance': 'Финансы',
      'travel': 'Путешествия',
      'education': 'Образование',
      'other': 'Другое',
      'welcomeBack': 'С возвращением!',
      'createAccount': 'Создайте свой аккаунт',
      'email': 'Электронная почта',
      'password': 'Пароль',
      'pleaseEnterEmail': 'Пожалуйста, введите вашу электронную почту',
      'pleaseEnterValidEmail': 'Пожалуйста, введите действительный email',
      'pleaseEnterPassword': 'Пожалуйста, введите ваш пароль',
      'passwordMustBeAtLeast': 'Пароль должен содержать не менее 6 символов',
      'forgotPassword': 'Забыли пароль?',
      'signIn': 'Войти',
      'signUp': 'Зарегистрироваться',
      'dontHaveAccount': 'Нет аккаунта? Зарегистрируйтесь',
      'alreadyHaveAccount': 'Уже есть аккаунт? Войдите',
      'or': 'ИЛИ',
      'continueAsGuest': 'Продолжить как гость (Демо)',
      'authenticationFailed': 'Ошибка аутентификации',
    },
    'es': {
      'appName': 'TaskFlow AI',
      'dashboard': 'Panel de control',
      'tasks': 'Tareas',
      'calendar': 'Calendario',
      'analytics': 'Analítica',
      'settings': 'Configuración',
      'createTask': 'Crear tarea',
      'editTask': 'Editar tarea',
      'deleteTask': 'Eliminar tarea',
      'completeTask': 'Completar tarea',
      'taskTitle': 'Título de la tarea',
      'taskDescription': 'Descripción de la tarea',
      'save': 'Guardar',
      'cancel': 'Cancelar',
      'search': 'Buscar',
      'filter': 'Filtro',
      'noTasks': 'No se encontraron tareas',
      'loading': 'Cargando...',
      'error': 'Error',
      'retry': 'Reintentar',
      'appearance': 'Apariencia',
      'theme': 'Tema',
      'light': 'Claro',
      'dark': 'Oscuro',
      'system': 'Sistema',
      'colorScheme': 'Esquema de colores',
      'professional': 'Profesional',
      'creative': 'Creativo',
      'calm': 'Tranquilo',
      'notifications': 'Notificaciones',
      'pushNotifications': 'Notificaciones push',
      'reminders': 'Recordatorios',
      'general': 'General',
      'language': 'Idioma',
      'english': 'Inglés',
      'russian': 'Ruso',
      'spanish': 'Español',
      'backupSync': 'Respaldo y sincronización',
      'helpSupport': 'Ayuda y soporte',
      'about': 'Acerca de',
      'version': 'Versión',
      'newTask': 'Nueva tarea',
      'selectTheme': 'Seleccionar tema',
      'selectColorScheme': 'Seleccionar esquema de colores',
      'selectLanguage': 'Seleccionar idioma',
      'title': 'Título',
      'description': 'Descripción',
      'priority': 'Prioridad',
      'status': 'Estado',
      'category': 'Categoría',
      'dueDate': 'Fecha de vencimiento',
      'tags': 'Etiquetas',
      'comments': 'Comentarios',
      'addComment': 'Agregar comentario',
      'edit': 'Editar',
      'delete': 'Eliminar',
      'complete': 'Completar',
      'pending': 'Pendiente',
      'inProgress': 'En progreso',
      'completed': 'Completado',
      'cancelled': 'Cancelado',
      'high': 'Alto',
      'medium': 'Medio',
      'low': 'Bajo',
      'none': 'Ninguno',
      'today': 'Hoy',
      'upcoming': 'Próximas',
      'overdue': 'Vencidas',
      'completed': 'Completado',
      'allTasks': 'Todas las tareas',
      'quickStats': 'Estadísticas rápidas',
      'exportCSV': 'Exportar CSV',
      'exportJSON': 'Exportar JSON',
      'exportPDF': 'Exportar PDF',
      'importCSV': 'Importar CSV',
      'importJSON': 'Importar JSON',
      'newTask': 'Nueva tarea',
      'taskCreatedFromVoice': '¡Tarea creada desde voz!',
      'listening': 'Escuchando...',
      'importedTasks': 'Importadas {count} tareas',
      'importFailed': 'Error al importar',
      'pleaseEnterTaskTitle': 'Por favor ingrese un título de tarea',
      'titleCannotBeEmpty': 'El título no puede estar vacío',
      'noTasksFound': 'No se encontraron tareas',
      'searchTasks': 'Buscar tareas...',
      'create': 'Crear',
      'enterTaskTitle': 'Ingrese el título de la tarea',
      'personal': 'Personal',
      'work': 'Trabajo',
      'shopping': 'Compras',
      'health': 'Salud',
      'finance': 'Finanzas',
      'travel': 'Viajes',
      'education': 'Educación',
      'other': 'Otro',
      'welcomeBack': '¡Bienvenido de nuevo!',
      'createAccount': 'Crea tu cuenta',
      'email': 'Correo electrónico',
      'password': 'Contraseña',
      'pleaseEnterEmail': 'Por favor ingrese su correo electrónico',
      'pleaseEnterValidEmail': 'Por favor ingrese un correo electrónico válido',
      'pleaseEnterPassword': 'Por favor ingrese su contraseña',
      'passwordMustBeAtLeast': 'La contraseña debe tener al menos 6 caracteres',
      'forgotPassword': '¿Olvidaste tu contraseña?',
      'signIn': 'Iniciar sesión',
      'signUp': 'Registrarse',
      'dontHaveAccount': '¿No tienes una cuenta? Regístrate',
      'alreadyHaveAccount': '¿Ya tienes una cuenta? Inicia sesión',
      'or': 'O',
      'continueAsGuest': 'Continuar como invitado (Demo)',
      'authenticationFailed': 'Error de autenticación',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ??
        _localizedValues['en']?[key] ??
        key;
  }

  // Getters for common strings
  String get appName => translate('appName');
  String get dashboard => translate('dashboard');
  String get tasks => translate('tasks');
  String get calendar => translate('calendar');
  String get analytics => translate('analytics');
  String get settings => translate('settings');
  String get createTask => translate('createTask');
  String get editTask => translate('editTask');
  String get deleteTask => translate('deleteTask');
  String get completeTask => translate('completeTask');
  String get taskTitle => translate('taskTitle');
  String get taskDescription => translate('taskDescription');
  String get save => translate('save');
  String get cancel => translate('cancel');
  String get search => translate('search');
  String get filter => translate('filter');
  String get noTasks => translate('noTasks');
  String get loading => translate('loading');
  String get error => translate('error');
  String get retry => translate('retry');
  String get appearance => translate('appearance');
  String get theme => translate('theme');
  String get light => translate('light');
  String get dark => translate('dark');
  String get system => translate('system');
  String get colorScheme => translate('colorScheme');
  String get professional => translate('professional');
  String get creative => translate('creative');
  String get calm => translate('calm');
  String get notifications => translate('notifications');
  String get pushNotifications => translate('pushNotifications');
  String get reminders => translate('reminders');
  String get general => translate('general');
  String get language => translate('language');
  String get english => translate('english');
  String get russian => translate('russian');
  String get spanish => translate('spanish');
  String get backupSync => translate('backupSync');
  String get helpSupport => translate('helpSupport');
  String get about => translate('about');
  String get version => translate('version');
  String get newTask => translate('newTask');
  String get selectTheme => translate('selectTheme');
  String get selectColorScheme => translate('selectColorScheme');
  String get selectLanguage => translate('selectLanguage');
  String get title => translate('title');
  String get description => translate('description');
  String get priority => translate('priority');
  String get status => translate('status');
  String get category => translate('category');
  String get dueDate => translate('dueDate');
  String get tags => translate('tags');
  String get comments => translate('comments');
  String get addComment => translate('addComment');
  String get edit => translate('edit');
  String get delete => translate('delete');
  String get complete => translate('complete');
  String get pending => translate('pending');
  String get inProgress => translate('inProgress');
  String get completed => translate('completed');
  String get cancelled => translate('cancelled');
  String get high => translate('high');
  String get medium => translate('medium');
  String get low => translate('low');
  String get none => translate('none');
  String get today => translate('today');
  String get upcoming => translate('upcoming');
  String get overdue => translate('overdue');
  String get allTasks => translate('allTasks');
  String get quickStats => translate('quickStats');
  String get exportCSV => translate('exportCSV');
  String get exportJSON => translate('exportJSON');
  String get exportPDF => translate('exportPDF');
  String get importCSV => translate('importCSV');
  String get importJSON => translate('importJSON');
  String get taskCreatedFromVoice => translate('taskCreatedFromVoice');
  String get listening => translate('listening');
  String importedTasks(int count) => translate('importedTasks').replaceAll('{count}', count.toString());
  String get importFailed => translate('importFailed');
  String get pleaseEnterTaskTitle => translate('pleaseEnterTaskTitle');
  String get titleCannotBeEmpty => translate('titleCannotBeEmpty');
  String get noTasksFound => translate('noTasksFound');
  String get searchTasks => translate('searchTasks');
  String get create => translate('create');
  String get enterTaskTitle => translate('enterTaskTitle');
  String get personal => translate('personal');
  String get work => translate('work');
  String get shopping => translate('shopping');
  String get health => translate('health');
  String get finance => translate('finance');
  String get travel => translate('travel');
  String get education => translate('education');
  String get other => translate('other');
  String get welcomeBack => translate('welcomeBack');
  String get createAccount => translate('createAccount');
  String get email => translate('email');
  String get password => translate('password');
  String get pleaseEnterEmail => translate('pleaseEnterEmail');
  String get pleaseEnterValidEmail => translate('pleaseEnterValidEmail');
  String get pleaseEnterPassword => translate('pleaseEnterPassword');
  String get passwordMustBeAtLeast => translate('passwordMustBeAtLeast');
  String get forgotPassword => translate('forgotPassword');
  String get signIn => translate('signIn');
  String get signUp => translate('signUp');
  String get dontHaveAccount => translate('dontHaveAccount');
  String get alreadyHaveAccount => translate('alreadyHaveAccount');
  String get or => translate('or');
  String get continueAsGuest => translate('continueAsGuest');
  String get authenticationFailed => translate('authenticationFailed');
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ru', 'es'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

