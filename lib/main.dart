import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/app_export.dart';
import 'providers/user_provider.dart';
import 'providers/social_profile_provider.dart';
import 'providers/social_awards_provider.dart';
import 'services/firebase/auth/auth_provider.dart' as app_auth;
import 'services/firebase/firebase_options.dart';
import 'presentation/profile_screen/provider/profile_provider.dart';
import 'presentation/profile_static_screen/provider/profile_static_provider.dart';
import 'theme/provider/theme_provider.dart' as app_theme;
import 'package:shared_preferences/shared_preferences.dart';
import 'providers/profile_picture_provider.dart';
import 'providers/user_info_provider.dart';
import 'presentation/alkis/leaderboard_screen/provider/leaderboard_provider.dart';
import 'presentation/alkis/notifications/provider/notifications_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

var globalMessengerKey = GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
    systemNavigationBarColor: Colors.white,
    systemNavigationBarDividerColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));

  await Future.wait([
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]),
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge),
    PrefUtils().init()
  ]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => app_theme.ThemeProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => app_auth.AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ProfileProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ProfileStaticProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ProfilePictureProvider(prefs),
        ),
        ChangeNotifierProvider(
          create: (_) => UserInfoProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => LeaderboardProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => NotificationsProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => SocialProfileProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => SocialAwardsProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<app_theme.ThemeProvider>(
      builder: (context, themeProvider, _) {
        return ColorFiltered(
          colorFilter: themeProvider.invertColors
              ? const ColorFilter.matrix([
                  -1, 0, 0, 0, 255,
                  0, -1, 0, 0, 255,
                  0, 0, -1, 0, 255,
                  0, 0, 0, 1, 0,
                ])
              : const ColorFilter.matrix([
                  1, 0, 0, 0, 0,
                  0, 1, 0, 0, 0,
                  0, 0, 1, 0, 0,
                  0, 0, 0, 1, 0,
                ]),
          child: MaterialApp(
            title: 'trackeat',
            debugShowCheckedModeBanner: false,
            builder: (context, child) {
              ScreenUtil.init(
                context,
                designSize: const Size(375, 812),
                minTextAdapt: true,
                splitScreenMode: true,
              );
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: TextScaler.linear(themeProvider.textScaleFactor),
                ),
                child: child!,
              );
            },
            navigatorKey: NavigatorService.navigatorKey,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate
            ],
            supportedLocales: const [Locale('en', '')],
            initialRoute: AppRoutes.initialRoute,
            routes: AppRoutes.routes,
          ),
        );
      },
    );
  }
}
