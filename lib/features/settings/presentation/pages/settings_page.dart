import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/enums.dart';
import '../../../../core/theme/color_schemes.dart';
import '../bloc/settings_bloc.dart';

/// Settings page
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
        appBar: AppBar(
          title: Text(l10n.settings),
        ),
        body: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            return ListView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        children: [
          _SettingsSection(
            title: l10n.appearance,
            children: [
              ListTile(
                leading: const Icon(Icons.brightness_6),
                title: Text(l10n.theme),
                subtitle: Text(_getThemeModeText(state.themeMode, l10n)),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(l10n.selectTheme),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: ThemeMode.values.map((mode) {
                          return ListTile(
                            title: Text(_getThemeModeText(mode, l10n)),
                            trailing: state.themeMode == mode
                                ? const Icon(Icons.check)
                                : null,
                            onTap: () {
                              context.read<SettingsBloc>().add(ChangeThemeMode(mode));
                              Navigator.pop(context);
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.palette),
                title: Text(l10n.colorScheme),
                subtitle: Text(_getColorSchemeText(state.colorSchemeType, l10n)),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(l10n.selectColorScheme),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: ColorSchemeType.values.map((scheme) {
                          return ListTile(
                            title: Text(_getColorSchemeText(scheme, l10n)),
                            trailing: state.colorSchemeType == scheme
                                ? const Icon(Icons.check)
                                : null,
                            onTap: () {
                              context.read<SettingsBloc>().add(
                                    ChangeColorScheme(scheme),
                                  );
                              Navigator.pop(context);
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: AppConstants.defaultPadding),
          _SettingsSection(
            title: l10n.notifications,
            children: [
              ListTile(
                leading: const Icon(Icons.notifications),
                title: Text(l10n.pushNotifications),
                trailing: Switch(
                  value: state.notificationsEnabled,
                  onChanged: (value) {
                    context.read<SettingsBloc>().add(ToggleNotifications(value));
                  },
                ),
              ),
              ListTile(
                leading: const Icon(Icons.alarm),
                title: Text(l10n.reminders),
                trailing: Switch(
                  value: state.notificationsEnabled,
                  onChanged: (value) {
                    context.read<SettingsBloc>().add(ToggleNotifications(value));
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.defaultPadding),
          _SettingsSection(
            title: l10n.general,
            children: [
              ListTile(
                leading: const Icon(Icons.language),
                title: Text(l10n.language),
                subtitle: Text(_getLanguageText(state.languageCode, l10n)),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(l10n.selectLanguage),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          {'code': 'en', 'name': l10n.english},
                          {'code': 'ru', 'name': l10n.russian},
                          {'code': 'es', 'name': l10n.spanish},
                        ].map((lang) {
                          return ListTile(
                            title: Text(lang['name']!),
                            trailing: state.languageCode == lang['code']
                                ? const Icon(Icons.check)
                                : null,
                                           onTap: () {
                                             context.read<SettingsBloc>().add(
                                                   ChangeLanguage(lang['code']!),
                                                 );
                                             Navigator.pop(context);
                                           },
                          );
                        }).toList(),
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.backup),
                title: Text(l10n.backupSync),
                subtitle: Text(l10n.backupSync),
                onTap: () {
                  // TODO: Show backup settings
                },
              ),
              ListTile(
                leading: const Icon(Icons.help_outline),
                title: Text(l10n.helpSupport),
                onTap: () {
                  // TODO: Show help
                },
              ),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: Text(l10n.about),
                subtitle: Text('${l10n.version} 1.0.0'),
                onTap: () {
                  showAboutDialog(
                    context: context,
                    applicationName: l10n.appName,
                    applicationVersion: '1.0.0',
                    applicationIcon: const Icon(
                      Icons.check_circle_outline,
                      size: 48,
                      color: AppColors.primary,
                    ),
                  );
                },
              ),
            ],
          ),
        ],
            );
          },
        ),
    );
  }

  String _getThemeModeText(ThemeMode mode, AppLocalizations l10n) {
    switch (mode) {
      case ThemeMode.light:
        return l10n.light;
      case ThemeMode.dark:
        return l10n.dark;
      case ThemeMode.system:
        return l10n.system;
    }
  }

  String _getColorSchemeText(ColorSchemeType type, AppLocalizations l10n) {
    switch (type) {
      case ColorSchemeType.professional:
        return l10n.professional;
      case ColorSchemeType.creative:
        return l10n.creative;
      case ColorSchemeType.calm:
        return l10n.calm;
    }
  }

  String _getLanguageText(String code, AppLocalizations l10n) {
    switch (code) {
      case 'en':
        return l10n.english;
      case 'ru':
        return l10n.russian;
      case 'es':
        return l10n.spanish;
      default:
        return l10n.english;
    }
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        Card(
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }
}

