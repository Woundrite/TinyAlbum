import 'package:flutter/material.dart';
import 'action_item_base.dart';
import 'moreMenu.dart';

class MoreAction extends StatelessWidget {
  final String imageId;

  const MoreAction({
    super.key,
    required this.imageId,
  });

  @override
  Widget build(BuildContext context) {
    return ActionItemBase(
      icon: Icons.more_vert,
      label: "More",
      onTap: () {
        _openMenu(context);
      },
    );
  }

  void _openMenu(BuildContext context) {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (_) => Stack(
        children: [
          // FULL-SCREEN DISMISS BARRIER
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                entry.remove(); // ✅ closes on any outside tap
              },
            ),
          ),

          // ACTUAL POPUP
          MoreMenu(
            imageId: imageId,
            onClose: () {
              entry.remove(); // ✅ closes on item tap
            },
          ),
        ],
      ),
    );

    overlay.insert(entry);
  }

}
