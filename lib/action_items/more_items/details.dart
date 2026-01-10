import 'package:flutter/material.dart';
import 'moreItem.dart';
import 'detailsUI.dart';

MoreItem detailsMoreItem({
  required BuildContext context,
  required String imageId,
}) {
  return MoreItem(
    title: "Details",
    onTap: () {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        transitionAnimationController: AnimationController(
          vsync: Navigator.of(context),
          duration: const Duration(milliseconds: 380),
          reverseDuration: const Duration(milliseconds: 300),
        ),
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        builder: (_) {
          return DetailsUI(imageId: imageId);
        },
      );
    },
  );
}