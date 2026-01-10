import 'package:flutter/material.dart';
import 'action_item_base.dart';
import 'package:gallery/metaData.dart';

class Favorite extends StatefulWidget {
  final String imageId;

  const Favorite({
    super.key,
    required this.imageId,
  });

  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  @override
  Widget build(BuildContext context) {
    final imageLabels = ImgMetaData.instance;
    final isFavorite =
    imageLabels.isFavorite(widget.imageId);

    return ActionItemBase(
      icon: isFavorite
          ? Icons.favorite
          : Icons.favorite_border,
      label: "Favorite",
      onTap: () {
        setState(() {
          imageLabels.toggleFavorite(widget.imageId);
        });
      },
    );
  }
}

