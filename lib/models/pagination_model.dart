class PaginationModel {
  int page;
  int lastPage;
  int perPage;
  bool isNext;
  bool isPrev;
  Function fetch;

  PaginationModel(
      {this.perPage = 10,
      this.page = 1,
      required this.lastPage,
      required this.fetch,
      this.isNext = false,
      this.isPrev = false});
}
