import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';

Future<FlutterLocalNotificationsPlugin> initNotfication() async {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
// Streams are created so that app can respond to notification-related events since the plugin is initialised in the `main` function
  /*BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
      BehaviorSubject<ReceivedNotification>();*/
  BehaviorSubject<String> selectNotificationSubject = BehaviorSubject<String>();
  /*NotificationAppLaunchDetails notificationAppLaunchDetails;
  notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();*/

  // Note: permissions aren't requested here just to demonstrate that can be done later using the `requestPermissions()` method
  // of the `IOSFlutterLocalNotificationsPlugin` class

// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');

/*var initializationSettingsIOS = IOSInitializationSettings(
    onDidReceiveLocalNotification: onDidReceiveLocalNotification);*/

var initializationSettings = InitializationSettings(
    initializationSettingsAndroid, null);

await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    selectNotificationSubject.add(payload);
  });
  return flutterLocalNotificationsPlugin;
}

NotificationDetails platformSpecific(String channelID,String channelName,String channelDescription){
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
    '$channelID', '$channelName', '$channelDescription',
    importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
  //var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  return NotificationDetails(
    androidPlatformChannelSpecifics, null);
}