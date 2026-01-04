/// Application-wide constants
class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'TaskFlow AI';
  static const String appVersion = '1.0.0';
  
  // Storage Keys
  static const String themeKey = 'theme_mode';
  static const String localeKey = 'locale';
  static const String isFirstLaunchKey = 'is_first_launch';
  static const String isDemoModeKey = 'is_demo_mode';
  
  // Hive Box Names
  static const String tasksBoxName = 'tasks';
  static const String userBoxName = 'user';
  static const String settingsBoxName = 'settings';
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
  
  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 12.0;
  static const double smallBorderRadius = 8.0;
  
  // Task Constants
  static const int maxTaskTitleLength = 200;
  static const int maxTaskDescriptionLength = 2000;
  static const int maxSubTasks = 50;
  
  // Pagination
  static const int tasksPerPage = 20;
  
  // AI Assistant
  static const int maxChatHistory = 100;
  static const Duration typingDelay = Duration(milliseconds: 50);
}

