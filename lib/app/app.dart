import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/platform/platform_bridge.dart';
import 'providers.dart';
import 'router.dart';
import 'theme/app_theme.dart';

class DigitalBalanceApp extends ConsumerStatefulWidget {
  const DigitalBalanceApp({super.key});

  @override
  ConsumerState<DigitalBalanceApp> createState() => _DigitalBalanceAppState();
}

class _DigitalBalanceAppState extends ConsumerState<DigitalBalanceApp> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      try {
        final settingsRepo = ref.read(settingsRepositoryProvider);
        final goal = await settingsRepo.getDailyGoalMinutes();
        final enforced = await settingsRepo.isDailyTargetRestrictionEnabled();
        final bridge = PlatformBridge();
        await bridge.setDailyTargetEnforcement(
          enabled: enforced,
          targetMinutes: goal,
        );
        final bio = await settingsRepo.isBiometricOverrideEnabled();
        await bridge.setBiometricOverride(enabled: bio);
        final restrictionRepo = ref.read(restrictionRepositoryProvider);
        await restrictionRepo.syncActiveRulesToPlatform();
      } catch (_) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeControllerProvider);
    final locale = ref.watch(localeControllerProvider);

    return MaterialApp.router(
      title: 'Digital Balance',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      locale: locale,
      supportedLocales: const [Locale('en', ''), Locale('bn', '')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: router,
      builder: (context, child) {
        final brightness = Theme.of(context).brightness;
        final isDark = brightness == Brightness.dark;
        final overlayStyle = SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
          statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        );
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: overlayStyle,
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
