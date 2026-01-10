import 'package:flutter/material.dart';
import 'action_item_base.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:share_plus/share_plus.dart' as shareFeature;

class Share extends StatelessWidget {
  final String imageId;

  const Share({
    super.key,
    required this.imageId,
  });

  @override
  Widget build(BuildContext context) {
    return ActionItemBase(
      icon: Icons.share,
      label: "Share",
      onTap: () {
        _shareImage(context);
      },
    );
  }

  // -------------------------------
  // Actual share logic
  // -------------------------------
  Future<void> _shareImage(BuildContext context) async {
    final asset = await AssetEntity.fromId(imageId);

    if (asset == null) return;

    final file = await asset.file;

    if (file == null) return;

    await shareFeature.Share.shareXFiles(
      [shareFeature.XFile(file.path)],
    );
  }
}
