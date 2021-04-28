class PaginationModel {
  int page;
  int lastPage;
  int perPage;
  int totalEntries;
  bool isNext;
  bool isPrev;
  Function fetch;

  PaginationModel({
    this.perPage = 10,
    this.page = 1,
    this.totalEntries = 0,
    required this.lastPage,
    required this.fetch,
    this.isNext = false,
    this.isPrev = false,
  });
}
