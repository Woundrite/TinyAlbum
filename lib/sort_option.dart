enum SortOption { recent, oldest, size }

extension SortOptionLabel on SortOption {
  String get label {
    switch (this) {
      case SortOption.recent:
        return 'Recently Added';
      case SortOption.oldest:
        return 'Oldest First';
      case SortOption.size:
        return 'By Size';
    }
  }
}
