import 'package:flutter/material.dart';
import '../entity/Surah.dart';
import 'juz.dart';
import 'juzViewBuilder.dart';

class juzListBuilder extends StatefulWidget {
  final List<juz> surah;

  juzListBuilder({Key key, this.surah}) : super(key: key);

  @override
  _juzListBuilderState createState() => _juzListBuilderState();
}

class _juzListBuilderState extends State<juzListBuilder> {
  TextEditingController editingController = TextEditingController();

  List<juz> surah = List<juz>();

  void initSurahListView() {
    if (surah.isNotEmpty) {
      surah.clear();
    }
    surah.addAll(widget.surah);
  }

  void filterSearchResults(String query) {
    /// Fill surah list if empty
    initSurahListView();

    /// SearchList contains every surah
    List<juz> searchList = List<juz>();
    searchList.addAll(surah);

    /// Contains matching surah(s)
    List<juz> listData = List<juz>();
    if (query.isNotEmpty) {
      /// Loop all surah(s)
      searchList.forEach((item) {
        /// Filter by (titleAr:exact,title:partial,pageIndex)
        if (
            item.title_2.toLowerCase().contains(query.toLowerCase()) ||
            item.pageIndex_2.toString().contains(query)) {
          listData.add(item);
        }
      });

      /// Fill surah List with searched surah(s)
      setState(() {
        surah.clear();
        surah.addAll(listData);
      });
      return;

      /// Show all surah list
    } else {
      setState(() {
        surah.clear();
        surah.addAll(widget.surah);
      });
    }
  }

  @override
  void initState() {
    /// Init listView with all surah(s)
    initSurahListView();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          /// Search field
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              cursorColor: Colors.lightBlue,
              onChanged: (value) {
                filterSearchResults(value);
                print(value);
              },
              controller: editingController,
              decoration: InputDecoration(
                  labelText: "البحث عن سورة جزء",
                  // hintText: "البحث",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)))),
            ),
          ),

          /// ListView represent all/searched surah(s)
          Expanded(
            child: ListView.builder(
              itemCount: surah.length,
              itemExtent: 80,
              itemBuilder: (BuildContext context, int index) => ListTile(
                  title: Text(surah[index].title_2),
                  leading: Image(
                      image:
                      AssetImage("assets/images/hatah.png"),
                      width: 30,
                      height: 30),
                  trailing: Text("${surah[index].pageIndex_2}"),
                  onTap: () {
                    /// Push to Quran view ([int pages] represent surah page(reversed index))
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                               juzViewBuilder(pages: surah[index].pages_2)));
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
