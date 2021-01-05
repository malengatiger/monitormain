import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:monitorlibrary/api/sharedprefs.dart';
import 'package:monitorlibrary/functions.dart';

import '../main.dart';

class NewFCMBloc {
  Future initialize() async {
    pp('$mm initialize ....');
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      if (message != null) {
        // Navigator.pushNamed(context, '/message',
        //     arguments: MessageArguments(message, true));
      }
    });
    pp('$mm set up  FirebaseMessaging.onMessage listener  🐤 🐤 🐤 ....');
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      pp('$mm FirebaseMessaging: onMessage fired!  🐤 🐤 🐤 ${message.toString()}  🐤 🐤 🐤');
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                // TODO add a proper drawable resource to android, for now using
                //      one that already exists in example app.
                icon: 'launch_background',
              ),
            ));
      }
    });

    pp('$mm set up  FirebaseMessaging.onMessageOpenedApp listener  🐤 🐤 🐤 ....');
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      pp('$mm A new onMessageOpenedApp event was published!');
      // Navigator.pushNamed(context, '/message',
      //     arguments: MessageArguments(message, true));
    });
    subscribe();
  }

  Future subscribe() async {
    var user = await Prefs.getUser();
    if (user == null) {
      pp('$mm user is NULL, quitting  ....');
      return null;
    }
    pp('$mm subscribe to organization topics ....');
    if (user != null) {
      pp("$mm subscribeToTopics for Organization: 🍎 ${user.organizationName} 🍎");
      await FirebaseMessaging.instance
          .subscribeToTopic('projects_${user.organizationId}');
      await FirebaseMessaging.instance
          .subscribeToTopic('photos_${user.organizationId}');
      await FirebaseMessaging.instance
          .subscribeToTopic('videos_${user.organizationId}');
      await FirebaseMessaging.instance
          .subscribeToTopic('conditions_${user.organizationId}');
      await FirebaseMessaging.instance
          .subscribeToTopic('messages_${user.organizationId}');
      await FirebaseMessaging.instance
          .subscribeToTopic('users_${user.organizationId}');
      pp("$mm subscribeToTopics: 🍎 subscribed to all 6 organization topics 🍎");
    } else {
      pp("$mm subscribeToTopics:  👿 👿 👿 user not cached on device yet  👿 👿 👿");
    }
    return null;
  }
}

const mm = '🔵 🔵 🔵 🔵 🔵 🔵 NewFCMBloc: ';
