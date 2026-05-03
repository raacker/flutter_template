import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/app/app_bloc_observer.dart';
import 'package:flutter_template/core/auth/auth_repository.dart';
import 'package:flutter_template/features/auth/bloc/auth_bloc.dart';
import 'package:flutter_template/features/auth/view/auth_page.dart';
import 'package:flutter_template/home/home_page.dart';

class App extends StatelessWidget {
  const App({required this.authRepository, super.key});

  final AuthRepository authRepository;

  @override
  Widget build(BuildContext context) {
    Bloc.observer = const AppBlocObserver();

    return RepositoryProvider<AuthRepository>.value(
      value: authRepository,
      child: BlocProvider(
        create: (context) => AuthBloc(authRepository)..add(const AuthStarted()),
        child: MaterialApp(
          title: 'Flutter Template',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          ),
          home: const _AppView(),
        ),
      ),
    );
  }
}

class _AppView extends StatelessWidget {
  const _AppView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return switch (state.status) {
          AuthStatus.unknown => const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
          AuthStatus.authenticated => const HomePage(),
          AuthStatus.unauthenticated || AuthStatus.failure => const AuthPage(),
        };
      },
    );
  }
}
