import 'dart:io';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class DetailsUI extends StatefulWidget {
  final String imageId;

  const DetailsUI({
    super.key,
    required this.imageId,
  });

  @override
  State<DetailsUI> createState() => _DetailsSheetState();
}

class _DetailsSheetState extends State<DetailsUI> {
  AssetEntity? _asset;
  File? _file;

  @override
  void initState() {
    super.initState();
    _loadDetails();
  }

  /// Loads asset metadata and file reference
  Future<void> _loadDetails() async {
    final asset = await AssetEntity.fromId(widget.imageId);
    final file = await asset?.file;

    if (!mounted) return;

    setState(() {
      _asset = asset;
      _file = file;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_asset == null) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ───────────────────────────────

            SizedBox(
              height: 48, // keeps consistent height
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Close button (left)
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Close"),
                  ),

                  // Title (right)
                  const Text(
                    "Details",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),




            const SizedBox(height: 8),

            // ── Details rows ─────────────────────────
            _detailRow("Name", _asset!.title ?? "-"),

            _detailRow(
              "Time",
              _formatDateTime(_asset!.createDateTime),
            ),

            _detailRow(
              "Dimensions",
              "${_asset!.width} × ${_asset!.height} Pixels",
            ),

            _detailRow(
              "Size",
              _file != null
                  ? "${(_file!.lengthSync() / (1024 * 1024)).toStringAsFixed(1)} MB"
                  : "-",
            ),

            _detailRow(
              "Path",
              _file?.path ?? "-",
            ),
          ],
        ),
      ),
    );
  }

  /// Single reusable row for metadata
  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Divider(height: 24),
        ],
      ),
    );
  }

  /// Formats DateTime similar to gallery apps
  String _formatDateTime(DateTime dateTime) {
    final date =
        "${dateTime.day.toString().padLeft(2, '0')}/"
        "${dateTime.month.toString().padLeft(2, '0')}/"
        "${dateTime.year.toString().substring(2)}";

    final hour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? "pm" : "am";

    return "$date $hour:$minute $period";
  }
}
