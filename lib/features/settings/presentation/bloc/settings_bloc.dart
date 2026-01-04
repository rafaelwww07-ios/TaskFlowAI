import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/theme/color_schemes.dart';

part 'settings_event.dart';
part 'settings_state.dart';

/// Settings BLoC
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(const SettingsState()) {
    on<LoadSettings>(_onLoadSettings);
    on<ChangeThemeMode>(_onChangeThemeMode);
    on<ChangeColorScheme>(_onChangeColorScheme);
    on<ChangeLanguage>(_onChangeLanguage);
    on<ToggleNotifications>(_onToggleNotifications);
  }

  Future<void> _onLoadSettings(
    LoadSettings event,
    Emitter<SettingsState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Get device locale as default
    final deviceLocale = PlatformDispatcher.instance.locale;
    String defaultLanguage = 'en';
    if (deviceLocale.languageCode == 'ru') {
      defaultLanguage = 'ru';
    } else if (deviceLocale.languageCode == 'es') {
      defaultLanguage = 'es';
    }
    
    final themeModeIndex = prefs.getInt('theme_mode');
    final colorSchemeIndex = prefs.getInt('color_scheme');
    final languageCode = prefs.getString('language') ?? defaultLanguage;
    final notificationsEnabled = prefs.getBool('notifications') ?? true;

    emit(state.copyWith(
      themeMode: themeModeIndex != null 
          ? ThemeMode.values[themeModeIndex] 
          : ThemeMode.system,
      colorSchemeType: colorSchemeIndex != null
          ? ColorSchemeType.values[colorSchemeIndex]
          : ColorSchemeType.professional,
      languageCode: languageCode,
      notificationsEnabled: notificationsEnabled,
    ));
  }

  Future<void> _onChangeThemeMode(
    ChangeThemeMode event,
    Emitter<SettingsState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('theme_mode', event.themeMode.index);
    
    emit(state.copyWith(themeMode: event.themeMode));
  }

  Future<void> _onChangeColorScheme(
    ChangeColorScheme event,
    Emitter<SettingsState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('color_scheme', event.colorSchemeType.index);
    
    emit(state.copyWith(colorSchemeType: event.colorSchemeType));
  }

  Future<void> _onChangeLanguage(
    ChangeLanguage event,
    Emitter<SettingsState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', event.languageCode);
    
    emit(state.copyWith(languageCode: event.languageCode));
    
    // Note: Tasks will be reloaded with new language when TaskBloc.loadTasks is called
    // This happens automatically when user navigates or when app restarts
  }

  Future<void> _onToggleNotifications(
    ToggleNotifications event,
    Emitter<SettingsState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications', event.enabled);
    
    emit(state.copyWith(notificationsEnabled: event.enabled));
  }
}

