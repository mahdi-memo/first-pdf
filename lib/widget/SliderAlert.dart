import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:ion/builder/SurahViewBuilder.dart';
import 'package:screen/screen.dart';
import 'package:ion/library/Globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ion/localNotification.dart';
class SliderAlert extends StatefulWidget {
  @override
  _SliderAlertState createState() => _SliderAlertState();
}

class _SliderAlertState extends State<SliderAlert> {
  /// Declare sharedPreferences
  SharedPreferences prefs;

  /// Temp Brightness Level (not save it yet)
  double tempBrightnessLevel;

  setBrightnessLevel(double level) async {
    globals.brightnessLevel = level;
    prefs = await SharedPreferences.getInstance();
    prefs.setDouble(globals.BRIGHTNESS_LEVEL, globals.brightnessLevel);
  }

  @override
  void initState() {
    if (globals.lastViewedPage != null) {
      setState(() {
//        tempBrightnessLevel = globals.brightnessLevel;
        local.setOnNotificationRec(onNotificationRec);
        local.setOnNotificationClick(onNotificationClick);
      });
    }
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
  @override
  Widget build(BuildContext context) {
    return Container(
      child: AlertDialog(
        title: Text("تفعيل الاشعارات ", textDirection: TextDirection.rtl),
        content: Container(
          height: 24,
          child: Row(
            children: <Widget>[
              Icon(
                Icons.access_alarm,
                size: 24,
              ),
           Text(
            "سوف يتم تفعيل الاشعارات يوميا ",
            textDirection: TextDirection.rtl,
          ),

//              Slider(
//                value: tempBrightnessLevel,
//                onChanged: (_brightness) {
//                  setState(() {
//                    tempBrightnessLevel = _brightness;
//                  });
//                  Screen.setBrightness(tempBrightnessLevel);
//                },
//                max: 1,
//                label: "$tempBrightnessLevel",
//                divisions: 10,
//              ),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
              child: Text(
                "الغاء ",
                textDirection: TextDirection.rtl,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          FlatButton(
            child: Text(
              "حفظ",
              textDirection: TextDirection.rtl,
            ),
            onPressed: () async{
               await local.Shownotivcation();
               Navigator.of(context).pop();
              Fluttertoast.showToast(
                  msg: " تم الحفظ بنجاح",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.green,
                  textColor: Colors.white,
                  fontSize: 18.0);
            },
          ),
        ],
      ),
    );
  }
}
