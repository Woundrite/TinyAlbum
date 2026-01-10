import 'package:flutter/material.dart';
import 'action_item_base.dart';
import 'package:gallery/metaData.dart';
import 'package:photo_manager/photo_manager.dart';


class Delete extends StatelessWidget {
  final String imageId;

  const Delete({
    super.key,
    required this.imageId,
  });

  @override
  Widget build(BuildContext context) {
    return ActionItemBase(
      icon: Icons.delete,
      label: "Delete",
      onTap: () {
        _showDeleteConfirmation(context);
      },
    );
  }

  // -------------------------------
  // First confirmation bottom sheet
  // -------------------------------
  void _showDeleteConfirmation(BuildContext context) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return _DeleteSheet(
          title: "Delete this image?",
          confirmText: "Delete",
          onConfirm: () {
            Navigator.pop(context); // close first sheet

            final isFavorite =
            ImgMetaData.instance.isFavorite(imageId);

            if (isFavorite) {
              _showFavoriteWarning(context);
            } else {
              _deleteImage(context);
            }
          },
        );
      },
    );
  }

  // --------------------------------
  // Second confirmation (favorite)
  // --------------------------------
  void _showFavoriteWarning(BuildContext context) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return _DeleteSheet(
          title: "This image is marked as favorite.\nDelete anyway?",
          confirmText: "Delete anyway",
          onConfirm: () {
            Navigator.pop(context);
            _deleteImage(context);
          },
        );
      },
    );
  }

  // -------------------------------
  // Actual delete (placeholder)
  // -------------------------------
  Future<void> _deleteImage(BuildContext context) async {
    final result = await PhotoManager.editor.deleteWithIds(
      [imageId],
    );

    if (result.isNotEmpty) {
      Navigator.pop(context); // close image viewer
    }
  }
}






class _DeleteSheet extends StatelessWidget {
  final String title;
  final String confirmText;
  final VoidCallback onConfirm;

  const _DeleteSheet({
    required this.title,
    required this.confirmText,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: onConfirm,
                  child: Text(
                    confirmText,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

