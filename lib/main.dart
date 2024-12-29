import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'core/app_export.dart';
import 'providers/user_provider.dart';
import 'services/firebase/auth/auth_provider.dart' as app_auth;
import 'services/firebase/firebase_options.dart';
import 'presentation/profile_screen/provider/profile_provider.dart';
import 'presentation/profile_static_screen/provider/profile_static_provider.dart';
import 'theme/theme_provider.dart' as app_theme;

var globalMessengerKey = GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Set status bar to be visible and transparent
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,  // Changed to edgeToEdge
  );
  
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
    systemNavigationBarColor: Colors.transparent,  // Added for bottom navigation bar
    systemNavigationBarDividerColor: Colors.transparent,  // Added for bottom navigation bar
    systemNavigationBarIconBrightness: Brightness.dark,  // Added for bottom navigation bar
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
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => ProfileStaticProvider()),
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
          child: MultiProvider(
            providers: [
              ChangeNotifierProvider<UserProvider>(
                create: (context) => UserProvider(),
              ),
              ChangeNotifierProvider<app_auth.AuthProvider>(
                create: (context) => app_auth.AuthProvider(),
              ),
            ],
            child: MaterialApp(
              title: 'trackeat',
              debugShowCheckedModeBanner: false,
              theme: theme,
              builder: (context, child) {
                return MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    textScaler: TextScaler.linear(themeProvider.textScaleFactor),
                  ),
                  child: child!,
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
          ),
        );
      },
    );
  }
}