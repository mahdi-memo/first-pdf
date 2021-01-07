import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:screen/screen.dart';
import 'package:ion/library/Globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';

import 'Index.dart';
import 'juz/juz.dart';
import 'juz/juzListBuilder.dart';
import 'juz/juzViewBuilder.dart';
class juzIndex extends StatefulWidget {

  @override
  _juzIndexState createState() => _juzIndexState();

}
class _juzIndexState extends State<juzIndex> {
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
                  juzViewBuilder(pages: globals.bookmarkedPage - 1)),
              (Route<dynamic> route) => false);

      /// Continue reading
    } else if (index == 1) {
      // _Shownotivcation();
      setState(() {
        globals.bookmarkedPage = globals.currentPage;
        print("toSave: ${globals.bookmarkedPage}");
      });
      if (globals.bookmarkedPage != null) {
        setBookmark(globals.bookmarkedPage);
      }

      /// Customize Screen Brightness
    } else if (index == 2) {
      //showDialog(context: this.context, builder: (context) => SliderAlert());
      Navigator.push(context, MaterialPageRoute(builder: (context) => Index()));
    }
  }

  void redirectToLastVisitedSurahView() {
    print("redirectTo:${globals.lastViewedPage}");
    if (globals.lastViewedPage != null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) =>
                  juzViewBuilder(pages: globals.lastViewedPage)),
              (Route<dynamic> route) => false);
    }
  }

  @override
  void initState() {
    /// set saved Brightness level
    super.initState();

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
                  padding: const EdgeInsets.all(8.0), child: Text(' الاجزاء  ')),
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
                    .loadString('assets/json/jsonjuz.json'),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<juz> surahList = parseJson(snapshot.data.toString());
                    return surahList.isNotEmpty
                        ? new juzListBuilder(surah: surahList)
                        : new Center(child: new CircularProgressIndicator());
                  } else {
                    return new Center(child: new CircularProgressIndicator());
                  }
                }),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.book),
              title: Text('الإنتقال إلى العلامة'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark),
              title: Text('حفظ العلامة'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('المحتويات'),
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.grey[600],
          selectedFontSize: 12,
          onTap: (index) => _onItemTapped(index),
        ),
      ),
    );
  }

  List<juz> parseJson(String response) {
    if (response == null) {
      return [];
    }
    final parsed =
    json.decode(response.toString()).cast<Map<String, dynamic>>();
    return parsed.map<juz>((json) => new juz.fromJson(json)).toList();
  }

  void setBookmark(int _page) async {
    var prefs = await SharedPreferences.getInstance();
    if (_page != null && !_page.isNaN) {
      await prefs.setInt(globals.BOOKMARKED_PAGE, _page);
    }
  }
}
