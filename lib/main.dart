import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:trackeat/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trackeat/trackeat-ai/nutrition_analysis.dart';
import 'package:trackeat/firebase/firestore_logger.dart';

import 'app_theme.dart';
import 'app_utils.dart';
import 'create_account_screen/create_account_screen.dart';
import 'routes/app_routes.dart';

var globalMessengerKey = GlobalKey<ScaffoldMessengerState>();
// A global variable to store the list of available cameras
// List<CameraDescription> cameras = [];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Firebase first
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

    // Fetch the available cameras
    //cameras = await availableCameras();

    // Then run other tasks
    await Future.wait([
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]),
      PrefUtils().init(),
      //analyzeImage('assets/images/Chicken-Alfredo-V3.jpg'),
      //logToFirestore(), // Call Firestore logging here only after Firebase is initialized
    ]);
  } catch (e) {
    print('Error during initialization: $e');
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return ChangeNotifierProvider<ThemeProvider>(
          create: (context) => ThemeProvider(),
          child: Consumer<ThemeProvider>(
            builder: (context, provider, child) {
              return MaterialApp(
                title: 'trackeat_createaccountflow',
                debugShowCheckedModeBanner: false,
                theme: theme,
                builder: (context, child) {
                  return MediaQuery(
                    data: MediaQuery.of(context).copyWith(
                      textScaler: TextScaler.linear(1.0),
                    ),
                    child: child!,
                  );
                },
                navigatorKey: NavigatorService.navigatorKey,
                localizationsDelegates: [
                  AppLocalizationDelegate(),
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: [Locale('en', '')],
                initialRoute: AppRoutes.initialRoute,
                routes: AppRoutes.routes,
              );
            },
          ),
        );
      },
    );
  }
}