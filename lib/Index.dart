import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:ion/library/Globals.dart' as globals;
import 'package:ion/localNotification.dart';
import 'package:ion/widget/SliderAlert.dart';
import 'package:rxdart/subjects.dart';
import 'package:screen/screen.dart';
import 'dart:io' show Platform;
import 'entity/Surah.dart';
import 'builder/SurahListBuilder.dart';
import 'builder/SurahViewBuilder.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'juzindex.dart';
class Index extends StatefulWidget {

  @override
  _IndexState createState() => _IndexState();

}

class _IndexState extends State<Index> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  var initializ;
  BehaviorSubject<ReceiveNotification> get did=>
      BehaviorSubject<ReceiveNotification>();
  /// Used for Bottom Navigation
  int _selectedIndex = 0;

  /// Get Screen Brightness
  void getScreenBrightness() async {
    globals.brightnessLevel = await Screen.brightness;
  }

  /// Navigation event handler
  _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;


    });

    /// Go to Bookmarked page
    if (index == 0) {
      setState(() {
        /// in case Bookmarked page is null (Bookmarked page initialized in splash screen)
        if (globals.bookmarkedPage == null) {
          globals.bookmarkedPage = globals.DEFAULT_BOOKMARKED_PAGE;
        }
      });
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) =>
                  SurahViewBuilder(pages: globals.bookmarkedPage - 1)),
          (Route<dynamic> route) => false);

      /// Continue reading
    } else if (index == 1) {
     // _Shownotivcation();
      if (globals.lastViewedPage != null) {
        /// Push to Quran view ([int pages] represent surah page(reversed index))
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    SurahViewBuilder(pages: globals.lastViewedPage - 1)));
      }

      /// Customize Screen Brightness
    } else if (index == 2) {
//      if (globals.bookmarkedPage != null) {
        //_Shownotivcation();
//        String payload='';
//        onNotificationClick(payload);
//      }
//      if (globals.brightnessLevel == null) {
//        getScreenBrightness();
//      }
     showDialog(context: this.context, builder: (context) => SliderAlert());
    }
    else if (index == 3) {
      _Shownotivcation();
      Navigator.push(context, MaterialPageRoute(builder: (context) => juzIndex()));


    }
  }

  void redirectToLastVisitedSurahView() {
    print("redirectTo:${globals.lastViewedPage}");
    if (globals.lastViewedPage != null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) =>
                  SurahViewBuilder(pages: globals.lastViewedPage)),
          (Route<dynamic> route) => false);
    }
  }

  @override
  void initState() {
    /// set saved Brightness level
    Screen.setBrightness(globals.brightnessLevel);
    Screen.keepOn(true);
    if(Platform.isIOS){
      reqestios();
      }
      init();
    super.initState();

  }
  onNotificationRec(ReceiveNotification notification){
    print('Not Rec: ${notification.id}');

  }
  onNotificationClick(String payload){
    if (globals.lastViewedPage != null) {
      /// Push to Quran view ([int pages] represent surah page(reversed index))
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  SurahViewBuilder(pages: globals.lastViewedPage - 1)));
    }
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
Future onSelected(String paylod) async{
    if(paylod != null){
      debugPrint("Notivcation " + paylod);
    }
}
  Future _Shownotivcation() async{
    var sechualdNotificaionTimer = DateTime.now().add(Duration(seconds: 5));
    var time = Time(14,27,0);
    var android = AndroidNotificationDetails('Channe ID1',
        'Channel title1',
        'channel body1',
         importance: Importance.Max,
         priority: Priority.High,
         playSound: true,
         timeoutAfter: 5000,
         enableLights: true
    );

    var ios = IOSNotificationDetails();
    var platform = NotificationDetails(android, ios);
   // flutterLocalNotificationsPlugin.showDailyAtTime(0, 'title ${time.hour}-${time.minute}-${time.second}', 'body',time, platform, payload: 'hay you ');
    //flutterLocalNotificationsPlugin.schedule(0, 'title', 'body', sechualdNotificaionTimer, platform);
     flutterLocalNotificationsPlugin.show(0,'حتى لا يهجر ', 'يجب تفعيل العلامة لحفظ القراءة', platform, payload: 'hay you ');
//    int minutesIncrement = 1;
//    var dateTimeNow = DateTime.now().toLocal();
//
//    for(int i=1;i<=5;i++){
//      var scheduledNotificationDateTime = dateTimeNow.add(new Duration(minutes: minutesIncrement));
//      await flutterLocalNotificationsPlugin.schedule(
//          i,
//          '  حتى لا يهجر ',
//          ' جزء رقم:$i ',
//          scheduledNotificationDateTime,
//          platform);
//      minutesIncrement= minutesIncrement+5;
//    }
    // Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) =>
    //             SurahViewBuilder(pages: globals.lastViewedPage - 1)));
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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        primaryColor: Colors.lightBlue,
        backgroundColor: Colors.white,
      ),
      home: Scaffold(
        appBar: AppBar(
          /*leading: IconButton(
            icon: Icon(
              Icons.tune,
              color: Colors.white,
            ),
            onPressed: (){
              showDialog(context: this.context,
                  builder:(context)=>SliderAlert());
            },
          ),*/
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                  padding: const EdgeInsets.all(8.0), child: Text(' المحتويات  ')),
              Icon(
                Icons.home,
                color: Colors.black,
              ),
            ],
          ),
        ),
        body: Container(
          child: Directionality(
            textDirection: TextDirection.rtl,

            /// Use future builder and DefaultAssetBundle to load the local JSON file
            child: new FutureBuilder(
                future: DefaultAssetBundle.of(context)
                    .loadString('assets/json/surah.json'),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Surah> surahList = parseJson(snapshot.data.toString());
                    return surahList.isNotEmpty
                        ? new SurahListBuilder(surah: surahList)
                        : new Center(child: new CircularProgressIndicator());
                  } else {
                    return new Center(child: new CircularProgressIndicator());
                  }
                }),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.book),
              title: Text('الإنتقال إلى العلامة'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.format_indent_decrease),
              title: Text('مواصلة القراءة'),
            ),
              BottomNavigationBarItem(
              icon: Icon(Icons.access_alarm),
              title: Text('تفعيل تنبيه الرسائل'),
           ),
            BottomNavigationBarItem(
              icon: Icon(Icons.ac_unit),
              title: Text('الاجزاء'),
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.grey[600],
          selectedFontSize: 9,
          onTap: (index) => _onItemTapped(index),
        ),
      ),
    );
  }

  List<Surah> parseJson(String response) {
    if (response == null) {
      return [];
    }
    final parsed =
        json.decode(response.toString()).cast<Map<String, dynamic>>();
    return parsed.map<Surah>((json) => new Surah.fromJson(json)).toList();
  }
}
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
