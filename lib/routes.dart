import 'package:go_router/go_router.dart';
import 'package:record_management_system/auth/login.dart';
import 'package:record_management_system/auth/signup.dart';
import 'package:record_management_system/main.dart';
import 'package:record_management_system/pages/home.dart';

class CustomRoutes {
  static final GoRouter router = GoRouter(routes: [
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
    ),
    GoRoute(
        path: '/home/:userid/:currentpage',
        builder: (context, state) => HomePage(
              userid: state.pathParameters["userid"]!,
              currentpage: state.pathParameters["currentpage"]!,
            )),
  ]);
}
