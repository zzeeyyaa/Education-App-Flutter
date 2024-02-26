import 'package:education_app/core/common/app/providers/course_of_the_day_notifier.dart';
import 'package:education_app/core/common/app/providers/notifications_notifier.dart';
import 'package:education_app/core/common/app/providers/user_provider.dart';
import 'package:education_app/core/res/fonts.dart';
import 'package:education_app/core/res/my_colors.dart';
import 'package:education_app/core/services/injection_container.dart';
import 'package:education_app/core/services/router.dart';
import 'package:education_app/firebase_options.dart';
import 'package:education_app/src/dashboard/presentation/providers/dashboard_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseUIAuth.configureProviders([EmailAuthProvider()]);
  await init();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CourseOfTheDay()),
        ChangeNotifierProvider(create: (_) => DashboardController()),
        ChangeNotifierProvider(
          create: (_) => NotificationsNotifier(
            sl<SharedPreferences>(),
          ),
        ),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        title: 'Education App - Zia',
        theme: ThemeData(
          useMaterial3: true,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          appBarTheme: const AppBarTheme(color: Colors.transparent),
          fontFamily: Fonts.poppins,
          colorScheme: ColorScheme.fromSwatch(
            accentColor: MyColors.primaryColour,
          ),
        ),
        onGenerateRoute: generateRoute,
      ),
    );
  }
}
