part of 'settings_bloc.dart';

/// Settings state
class SettingsState extends Equatable {
  const SettingsState({
    this.themeMode = ThemeMode.system,
    this.colorSchemeType = ColorSchemeType.professional,
    this.languageCode = 'en',
    this.notificationsEnabled = true,
  });

  final ThemeMode themeMode;
  final ColorSchemeType colorSchemeType;
  final String languageCode;
  final bool notificationsEnabled;

  SettingsState copyWith({
    ThemeMode? themeMode,
    ColorSchemeType? colorSchemeType,
    String? languageCode,
    bool? notificationsEnabled,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      colorSchemeType: colorSchemeType ?? this.colorSchemeType,
      languageCode: languageCode ?? this.languageCode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }

  @override
  List<Object?> get props => [
        themeMode,
        colorSchemeType,
        languageCode,
        notificationsEnabled,
      ];
}

