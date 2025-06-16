import 'package:flutter/material.dart';
import '../../features/main_navigation/presentation/pages/main_navigation_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/onboarding/presentation/pages/splash_page.dart';
import '../../features/explore/presentation/pages/explore_page.dart';
import '../../features/reader/presentation/pages/reader_page.dart';
import '../../features/profile/presentation/pages/organization_profile_page.dart';
import '../../features/profile/presentation/pages/author_profile_page.dart';
import '../../features/library/presentation/pages/library_page.dart';
import '../../features/dashboard/presentation/pages/user_dashboard_page.dart';

class AppRouter {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String main = '/main';
  static const String explore = '/explore';
  static const String reader = '/reader';
  static const String organizationProfile = '/organization-profile';
  static const String authorProfile = '/author-profile';
  static const String library = '/library';
  static const String upload = '/library';
  static const String dashboard = '/dashboard';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(
          builder: (_) => const SplashPage(),
        );
      
      case onboarding:
        return MaterialPageRoute(
          builder: (_) => const OnboardingPage(),
        );
      
      case main:
        return MaterialPageRoute(
          builder: (_) => const MainNavigationPage(),
        );
      
      case explore:
        return MaterialPageRoute(
          builder: (_) => const ExplorePage(),
        );
      
      case reader:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => ReaderPage(
            bookId: args?['bookId'] ?? '',
            bookTitle: args?['bookTitle'] ?? '',
            bookUrl: args?['bookUrl'] ?? '',
          ),
        );
      
      case organizationProfile:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => OrganizationProfilePage(
            organizationId: args?['organizationId'] ?? '',
          ),
        );
      
      case authorProfile:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => AuthorProfilePage(
            authorId: args?['authorId'] ?? '',
          ),
        );
      
      case library:
        return MaterialPageRoute(
          builder: (_) => const LibraryPage(),
        );
      
      case dashboard:
        return MaterialPageRoute(
          builder: (_) => const UserDashboardPage(),
        );
      
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('Page not found'),
            ),
          ),
        );
    }
  }
}
