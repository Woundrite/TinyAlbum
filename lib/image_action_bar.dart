import 'package:flutter/material.dart';

import 'action_items/favorite.dart';
import 'action_items/delete.dart';
import 'action_items/share.dart';
import 'action_items/moreAction.dart';
import 'action_items/action_item_base.dart'; // 🟢 REQUIRED for Edit button

class ImageActionBar extends StatelessWidget {
  final String imageId;
  final VoidCallback onEdit;

  const ImageActionBar({
    super.key,
    required this.imageId,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.7),
          border: const Border(
            top: BorderSide(color: Colors.white12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Share(imageId: imageId),
            Favorite(imageId: imageId),

            // 🟢 EDIT FEATURE
            ActionItemBase(
              icon: Icons.edit,
              label: "Edit",
              onTap: onEdit,
            ),

            Delete(imageId: imageId),
            MoreAction(imageId: imageId),
          ],
        ),
      ),
    );
  }
}
