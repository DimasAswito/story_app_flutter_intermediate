import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_app_flutter_intermediate/api/api_service.dart';
import 'package:story_app_flutter_intermediate/data/preferences/auth_preferences.dart';
import 'package:story_app_flutter_intermediate/provider/auth_provider.dart';
import 'package:story_app_flutter_intermediate/provider/story_provider.dart';
import 'package:story_app_flutter_intermediate/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();

  runApp(MyApp(sharedPreferences: sharedPreferences));
}

class MyApp extends StatelessWidget {
  final SharedPreferences sharedPreferences;

  const MyApp({super.key, required this.sharedPreferences});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ApiService>(
          create: (_) => ApiService(),
        ),
        ChangeNotifierProvider<AuthProvider>(
          create: (context) => AuthProvider(
            authPreferences: AuthPreferences(sharedPreferences: sharedPreferences),
            apiService: context.read<ApiService>(),
          ),
        ),
        ChangeNotifierProxyProvider<AuthProvider, StoryProvider>(
          create: (context) => StoryProvider(
            apiService: context.read<ApiService>(),
            token: ''
          ),
          update: (context, auth, previous) => StoryProvider(
            apiService: context.read<ApiService>(),
            token: auth.token ?? '',
          ),
        ),
      ],
      child: Builder(
        builder: (context) {
          final router = AppRouter.getRouter(context);
          return MaterialApp.router(
            title: 'Story App',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            routerConfig: router,
          );
        },
      ),
    );
  }
}
