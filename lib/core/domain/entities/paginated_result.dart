class PaginatedResult<T> {
  final List<T> items;
  final int page;
  final int pageSize;
  final int totalItems;
  final int totalPages;

  const PaginatedResult({
    required this.items,
    required this.page,
    required this.pageSize,
    required this.totalItems,
    required this.totalPages,
  });

  bool get hasReachedMax => page >= totalPages;
}
