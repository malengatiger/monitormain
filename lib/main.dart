import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:monitorlibrary/bloc/fcm_bloc.dart';
import 'package:monitorlibrary/bloc/theme_bloc.dart';
import 'package:monitorlibrary/functions.dart';
import 'package:monitormain/ui/intro/intro_main.dart';

const m = '💜 💜 💜 💜 💜 💜 ';
const z = '💜 💜 💜 ';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  /// Create an Android Notification Channel.
  ///
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  // await flutterLocalNotificationsPlugin
  //     .resolvePlatformSpecificImplementation<
  //         AndroidFlutterLocalNotificationsPlugin>()
  //     ?.createNotificationChannel(channel);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  pp('$z app main: $m Firebase initialized !! $z');
  await DotEnv.load(fileName: ".env");
  runApp(MyApp());

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
        stream: themeBloc.newThemeStream,
        builder: (context, snapshot) {
          var index = snapshot.data;
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Organization Boss',
            theme: ThemeUtil.getTheme(themeIndex: index),
            // home: StaggeredTest(),
            home: IntroMain(),
            // home: TestOwzo(),
          );
        });
  }
}
