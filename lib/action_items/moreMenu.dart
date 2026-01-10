import 'package:flutter/material.dart';
import 'more_items/moreItem.dart';
import 'more_items/editWithAI.dart';
import 'more_items/details.dart';

class MoreMenu extends StatefulWidget {
  final String imageId;
  final VoidCallback onClose;

  const MoreMenu({
    super.key,
    required this.imageId,
    required this.onClose,
  });

  @override
  State<MoreMenu> createState() => _MoreMenuState();
}

class _MoreMenuState extends State<MoreMenu>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _opacity;

  late final List<MoreItem> _items;

  @override
  void initState() {
    super.initState();

    _items = [
      editWithAI(imageId: widget.imageId),
      detailsMoreItem(
        context: context,
        imageId: widget.imageId,
      ),
    ];

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
      reverseDuration: const Duration(milliseconds: 180),
    );

    _scale = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
      reverseCurve: Curves.easeIn,
    );

    _opacity = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
    );

    _controller.forward();
  }

  Future<void> _close() async {
    await _controller.reverse();
    widget.onClose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 120,
      right: 16,
      child: FadeTransition(
        opacity: _opacity,
        child: ScaleTransition(
          alignment: Alignment.bottomRight,
          scale: _scale,
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 220,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 12,
                    color: Colors.black26,
                  )
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  _items.length * 2 - 1,
                      (index) {
                    if (index.isOdd) {
                      return const Divider( // 🟢 FIXED
                        height: 1,
                        thickness: 1,
                        indent: 16,
                        endIndent: 16,
                        color: Colors.black26,
                      );
                    }

                    return _MoreMenuItem(
                      item: _items[index ~/ 2],
                      closeMenu: _close, // 🟢 PASS CLOSE HANDLER
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// PRIVATE UI WIDGET (file-only)
class _MoreMenuItem extends StatelessWidget {
  final MoreItem item;
  final VoidCallback closeMenu;

  const _MoreMenuItem({
    required this.item,
    required this.closeMenu, // 🟢 FIXED
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        item.onTap(); // 🟢 FIXED
        closeMenu();  // 🟢 ALWAYS CLOSE AFTER ACTION
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            item.title,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
