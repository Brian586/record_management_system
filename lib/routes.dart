import 'package:go_router/go_router.dart';
import 'package:record_management_system/auth/login.dart';
import 'package:record_management_system/auth/signup.dart';
import 'package:record_management_system/main.dart';

class CustomRoutes {
  static final GoRouter router =GoRouter(routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const Login(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignUp(),
    )
  ]);
}