part of 'settings_bloc.dart';

/// Settings events
sealed class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

/// Load settings
class LoadSettings extends SettingsEvent {
  const LoadSettings();
}

/// Change theme mode
class ChangeThemeMode extends SettingsEvent {
  const ChangeThemeMode(this.themeMode);

  final ThemeMode themeMode;

  @override
  List<Object?> get props => [themeMode];
}

/// Change color scheme
class ChangeColorScheme extends SettingsEvent {
  const ChangeColorScheme(this.colorSchemeType);

  final ColorSchemeType colorSchemeType;

  @override
  List<Object?> get props => [colorSchemeType];
}

/// Change language
class ChangeLanguage extends SettingsEvent {
  const ChangeLanguage(this.languageCode);

  final String languageCode;

  @override
  List<Object?> get props => [languageCode];
}

/// Toggle notifications
class ToggleNotifications extends SettingsEvent {
  const ToggleNotifications(this.enabled);

  final bool enabled;

  @override
  List<Object?> get props => [enabled];
}

