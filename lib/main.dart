import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'features/onboarding/presentation/pages/splash_page.dart';

void main() {
  runApp(
    const ProviderScope(
      child: BoiThekeApp(),
    ),
  );
}

class BoiThekeApp extends StatelessWidget {
  const BoiThekeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'BoiTheke',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          home: const SplashPage(),
          onGenerateRoute: AppRouter.generateRoute,
        );
      },
    );
  }
}
