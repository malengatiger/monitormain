import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:monitorlibrary/bloc/theme_bloc.dart';
import 'package:monitorlibrary/functions.dart';
import 'package:monitormain/ui/intro/intro_main.dart';

void main() async {
  runApp(MyApp());
  await Firebase.initializeApp();
  pp(' 💜 💜 💜 Firebase initialized  💜 💜 💜');
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
            home: IntroMain(),
          );
        });
  }
}
