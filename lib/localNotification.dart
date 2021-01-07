import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io' show Platform;
import 'package:rxdart/subjects.dart';
class localNotification{
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  var initializ;
  BehaviorSubject<ReceiveNotification> get did=>
  BehaviorSubject<ReceiveNotification>();
  localNotification.init(){
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    if(Platform.isIOS){
      reqestios();
    }
    init();
  }
  init(){
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var android = AndroidInitializationSettings('hatah');
    var ios = IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
     onDidReceiveLocalNotification:(id,title,body,payload) async{
        ReceiveNotification notification = ReceiveNotification(
            id,
            title,
            body,
            payload);
        did.add(notification);

    }
    );
     initializ = InitializationSettings(android, ios);
   // flutterLocalNotificationsPlugin.initialize(initializ,onSelectNotification: onSelected);
  }

  reqestios(){
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>().requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
  setOnNotificationRec(Function onNotificationRec){
    did.listen((notification) {

    });

  }
setOnNotificationClick(Function onNotificationClick) async{
    await flutterLocalNotificationsPlugin.initialize(
        initializ,
        onSelectNotification:(String payload)async{
      onNotificationClick(payload);
    });
  }
Future<void> Shownotivcation() async{
    var sechualdNotificaionTimer = DateTime.now().add(Duration(seconds: 5));
    var time = Time(20,59,0);
    var android = AndroidNotificationDetails('Channe ID',
        'Channel title',
        'channel body',
        importance: Importance.Max,
        priority: Priority.High,
        playSound: true,
        timeoutAfter: 5000,
        enableLights: true
    );
    var ios = IOSNotificationDetails();
    var platform = NotificationDetails(android, ios);
    // flutterLocalNotificationsPlugin.showDailyAtTime(0, 'title ${time.hour}-${time.minute}-${time.second}', 'body',time, platform, payload: 'hay you ');
   // flutterLocalNotificationsPlugin.show(0,'انه وقت اكمال القراءة', 'حتى لا يهجر', platform, payload: 'hay you ');
   // flutterLocalNotificationsPlugin.periodicallyShow(0,'حتى لا يهجر ', 'حان وقت إكمال القراءة ',RepeatInterval.Hourly, platform, payload: 'مرحبا بك  ');
    int minutesIncrement = 1;
    var dateTimeNow = DateTime.now().toLocal();

    for(int i=1;i<=30;i++){
      var scheduledNotificationDateTime = dateTimeNow.add(new Duration(minutes: minutesIncrement));
      await flutterLocalNotificationsPlugin.schedule(
          i,
          '  حتى لا يهجر ',
          ' جزء رقم:$i ',
          scheduledNotificationDateTime,
          platform);
      minutesIncrement= minutesIncrement+15;
    }


}
}
localNotification local = localNotification.init();

class ReceiveNotification{
  final int id;
  final String titel;
  final String body;
  final String payload;
  ReceiveNotification(
      @required this.id,
      @required this.titel,
      @required this.body,
      @required this.payload
      );

}