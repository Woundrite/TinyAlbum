import 'package:flutter/material.dart';
import '../action_items/action_item_base.dart';
import 'edit_feature_item.dart';

class EditTray extends StatefulWidget {
  final List<EditFeatureItem> features;
  final VoidCallback onCancel;
  final VoidCallback onSave;

  const EditTray({
    super.key,
    required this.features,
    required this.onCancel,
    required this.onSave,
  });

  @override
  State<EditTray> createState() => _EditTrayState();
}

class _EditTrayState extends State<EditTray>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );

    _slide = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: SlideTransition(
        position: _slide,
        child: Material(
          color: Colors.black,
          elevation: 16,
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _EditTopBar(
                  onCancel: widget.onCancel,
                  onSave: widget.onSave,
                ),

                SizedBox(
                  height: 96,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: widget.features.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final feature = widget.features[index];

                      return ActionItemBase(
                        icon: feature.icon,
                        label: feature.label,
                        onTap: feature.onTap,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}





class _EditTopBar extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onSave;

  const _EditTopBar({
    required this.onCancel,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: onCancel,
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: onSave,
            child: const Text(
              "Save",
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }
}

