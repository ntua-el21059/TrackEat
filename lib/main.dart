import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/app_export.dart';
import 'providers/user_provider.dart';
import 'services/firebase/auth/auth_provider.dart' as app_auth;
import 'services/firebase/firebase_options.dart';
import 'presentation/profile_screen/provider/profile_provider.dart';
import 'presentation/profile_static_screen/provider/profile_static_provider.dart';
import 'theme/theme_provider.dart' as app_theme;
import 'package:shared_preferences/shared_preferences.dart';
import 'providers/profile_picture_provider.dart';
import 'providers/user_info_provider.dart';

var globalMessengerKey = GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Set status bar to be visible and transparent
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom],
  );
  
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarDividerColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));
  
  await Future.wait([
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]),
    PrefUtils().init()
  ]);
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<app_theme.ThemeProvider>(
          create: (_) => app_theme.ThemeProvider(),
        ),
        ChangeNotifierProvider<app_auth.AuthProvider>(
          create: (context) => app_auth.AuthProvider(),
        ),
        ChangeNotifierProvider<UserProvider>(
          create: (context) => UserProvider(),
        ),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => ProfileStaticProvider()),
        ChangeNotifierProvider(
          create: (_) => ProfilePictureProvider(prefs),
        ),
        ChangeNotifierProvider(
          create: (_) => UserInfoProvider(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<app_theme.ThemeProvider>(
      builder: (context, themeProvider, _) {
        return ColorFiltered(
          colorFilter: ColorFilter.matrix(
            themeProvider.invertColors ? 
            [
              -1, 0, 0, 0, 255,
              0, -1, 0, 0, 255,
              0, 0, -1, 0, 255,
              0, 0, 0, 1, 0,
            ] : 
            [
              1, 0, 0, 0, 0,
              0, 1, 0, 0, 0,
              0, 0, 1, 0, 0,
              0, 0, 0, 1, 0,
            ],
          ),
          child: MaterialApp(
            title: 'trackeat',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              appBarTheme: AppBarTheme(
                systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
                  statusBarColor: Colors.transparent,
                  systemNavigationBarColor: Colors.transparent,
                  systemNavigationBarDividerColor: Colors.transparent,
                ),
              ),
            ),
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: TextScaler.linear(themeProvider.textScaleFactor),
                ),
                child: AnnotatedRegion<SystemUiOverlayStyle>(
                  value: SystemUiOverlayStyle.dark.copyWith(
                    statusBarColor: Colors.transparent,
                    systemNavigationBarColor: Colors.transparent,
                    systemNavigationBarDividerColor: Colors.transparent,
                  ),
                  child: child!,
                ),
              );
            },
            navigatorKey: NavigatorService.navigatorKey,
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate
            ],
            supportedLocales: [Locale('en', '')],
            initialRoute: AppRoutes.initialRoute,
            routes: AppRoutes.routes,
          ),
        );
      },
    );
  }
}