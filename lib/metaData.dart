import 'package:flutter/foundation.dart';

/// This class owns all image-related labels (like favorite).
/// UI widgets should NEVER store this state themselves.
class ImgMetaData {
  /// Singleton instance
  static final ImgMetaData instance = ImgMetaData._internal();

  ImgMetaData._internal();

  /// Stores favorite state for each image
  /// Key   → AssetEntity.id
  /// Value → true (favorite) / false (not favorite)
  final Map<String, bool> _favoriteMap = {};

  /// Returns whether an image is marked as favorite
  bool isFavorite(String imageId) {
    return _favoriteMap[imageId] ?? false;
  }

  /// Toggles favorite state for an image
  void toggleFavorite(String imageId) {
    final current = _favoriteMap[imageId] ?? false;
    _favoriteMap[imageId] = !current;
  }
}
