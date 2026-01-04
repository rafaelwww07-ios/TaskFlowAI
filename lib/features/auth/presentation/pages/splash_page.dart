import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../bloc/auth_bloc.dart';

/// Splash screen
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      context.read<AuthBloc>().add(const CheckAuthStatus());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (!mounted) return;
        if (state.status == AuthStatus.authenticated) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            RouteNames.dashboard,
            (route) => false,
          );
        } else if (state.status == AuthStatus.unauthenticated) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            RouteNames.login,
            (route) => false,
          );
        }
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.primaryGradient,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle_outline,
                  size: 80,
                  color: Colors.white,
                )
                    .animate()
                    .fadeIn(duration: 500.ms)
                    .scale(delay: 300.ms, duration: 500.ms),
                const SizedBox(height: 24),
                Text(
                  'TaskFlow AI',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                )
                    .animate()
                    .fadeIn(delay: 500.ms, duration: 500.ms)
                    .slideY(begin: 0.3, end: 0),
                const SizedBox(height: 8),
                Text(
                  'Intelligent Task Management',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white70,
                      ),
                )
                    .animate()
                    .fadeIn(delay: 700.ms, duration: 500.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

