abstract class DateSorter {
  static List sort({required List data, String key = 'created_at',}) {
    data.sort((a,b) {
      DateTime aDate = DateTime.parse(a['$key']);
      DateTime bDate = DateTime.parse(b['$key']);
      return bDate.compareTo(aDate);
    });
    return data;
  }
}