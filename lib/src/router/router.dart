import 'package:auto_route/auto_route.dart';

import 'package:involio/src/pages/login/enter_otp_page/enter_otp_page.dart';
import 'package:involio/src/pages/login/get_started/getting_started_page.dart';
import 'package:involio/src/pages/login/login_page/login_page.dart';
import 'package:involio/src/pages/login/sign_up_page/sign_up_page.dart';
import 'package:involio/src/pages/main/home/comments/comments_page.dart';
import 'package:involio/src/pages/main/main_page.dart';
import 'package:involio/src/pages/main/search/trending_portfolios_page.dart';
import 'package:involio/src/pages/main/search/trending_strategies_page.dart';
import 'package:involio/src/pages/main/search/trending_users_page.dart';
import 'package:involio/src/pages/settings/settings_page.dart';
import 'package:involio/src/pages/splash/splash_page.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(
      path: '/splash',
      page: SplashPage,
      children: [
        RedirectRoute(path: '*', redirectTo: ''),
      ],
    ),
    AutoRoute(
      path: '/get_started',
      page: GetStartedPage,
      children: [
        RedirectRoute(path: '*', redirectTo: ''),
      ],
    ),
    AutoRoute(
      path: '/login',
      page: LoginPage,
      children: [
        RedirectRoute(path: '*', redirectTo: ''),
      ],
    ),
    AutoRoute(
      path: '/signup',
      page: SignUpPage,
      children: [
        RedirectRoute(path: '*', redirectTo: ''),
      ],
    ),
    AutoRoute(
      path: '/enter_otp',
      page: EnterOtpPage,
      children: [
        RedirectRoute(path: '*', redirectTo: ''),
      ],
    ),
    AutoRoute(
      initial: true,
      path: '/home',
      page: MainPage,
      children: [
        RedirectRoute(path: '*', redirectTo: ''),
      ],
    ),
    AutoRoute(
      initial: true,
      path: '/settings',
      page: SettingsPage,
      children: [
        RedirectRoute(path: '*', redirectTo: ''),
      ],
    ),
    AutoRoute(
      initial: true,
      path: '/portfolios',
      page: TrendingPortfoliosPage,
      children: [
        RedirectRoute(path: '*', redirectTo: ''),
      ],
    ),
    AutoRoute(
      initial: true,
      path: '/strategies',
      page: TrendingStrategiesPage,
      children: [
        RedirectRoute(path: '*', redirectTo: ''),
      ],
    ),
    AutoRoute(
      initial: true,
      path: '/users',
      page: TrendingUsersPage,
      children: [
        RedirectRoute(path: '*', redirectTo: ''),
      ],
    ),
    AutoRoute(
      initial: true,
      path: '/comments',
      page: CommentsPage,
      children: [
        RedirectRoute(path: '*', redirectTo: ''),
      ],
    ),
    // redirect all other paths
    RedirectRoute(path: '*', redirectTo: '/get_started'),
    //Home
  ],
)
class $AppRouter {}
