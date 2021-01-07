class juz{
  int count_2;
  String title_2;
  String index_2;
  int pages_2;
  int pageIndex_2;
  juz({
    this.count_2,
    this.title_2,
    this.index_2,
    this.pages_2,
    this.pageIndex_2,
});
  factory juz.fromJson(Map<String, dynamic> json) {
    return new juz(
      count_2: json['count'] as int,
      title_2: json['title'] as String,
      index_2: json['index'] as String,
      // reversed pages
      pages_2: 1 + int.parse(json['pages']),
      pageIndex_2: int.parse(json['pages']),
    );
  }
}