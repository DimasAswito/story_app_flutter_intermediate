import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:story_app_flutter_intermediate/pages/auth/login_page.dart';
import 'package:story_app_flutter_intermediate/pages/auth/register_page.dart';
import 'package:story_app_flutter_intermediate/pages/story/add_story_page.dart';
import 'package:story_app_flutter_intermediate/pages/story/detail_story_page.dart';
import 'package:story_app_flutter_intermediate/pages/story/list_story_page.dart';
import 'package:story_app_flutter_intermediate/provider/auth_provider.dart';

class AppRouter {
  static GoRouter getRouter(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return GoRouter(
      refreshListenable: authProvider,
      initialLocation: '/',
      redirect: (context, state) {
        final isLoggedIn = authProvider.isLoggedIn;
        final isGoingToLogin = state.matchedLocation == '/login';
        final isGoingToRegister = state.matchedLocation == '/register';

        if (!isLoggedIn && !isGoingToLogin && !isGoingToRegister) {
          return '/login';
        }

        if (isLoggedIn && (isGoingToLogin || isGoingToRegister)) {
          return '/';
        }

        return null;
      },
      routes: [
        GoRoute(path: '/', builder: (context, state) => const ListStoryPage()),
        GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
        GoRoute(
          path: '/register',
          builder: (context, state) => const RegisterPage(),
        ),
        GoRoute(
          path: '/story/:id',
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            return DetailStoryPage(id: id);
          },
        ),
        GoRoute(
          path: '/add',
          builder: (context, state) => const AddStoryPage(),
        ),
      ],
    );
  }
}
