import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

import 'image_action_bar.dart';
import 'edit/edit_tray.dart';
import 'edit/edit_feature_item.dart';
import 'edit/saveUI.dart';

import 'edit/subfeatures/crop.dart';
import 'edit/tools/crop_tool.dart';

import 'edit/subfeatures/rotate.dart';
import 'edit/tools/rotate_tool.dart';

import 'edit/subfeatures/flip_horizontal.dart';
import 'edit/subfeatures/flip_vertical.dart';
import 'edit/tools/flip_tool.dart';

import 'edit/undo_redo_bar.dart';

import 'edit/text/text_controller.dart';
import 'edit/text/text_editor.dart';

import 'edit/doodle/doodle_controller.dart';
import 'edit/doodle/doodle_editor.dart';

// 🟢 UNIFIED ADJUST SYSTEM
import 'edit/adjust/adjust_controller.dart';
import 'edit/adjust/adjust_editor.dart';
import 'edit/adjust/adjust_feature.dart';

class ImageViewer extends StatefulWidget {
  final AssetEntity image;

  const ImageViewer({super.key, required this.image});

  @override
  State<ImageViewer> createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  // -------- MODES --------
  bool _isEditing = false;
  bool _isCropping = false;
  bool _isTextEditing = false;
  bool _isDoodling = false;

  // -------- IMAGE --------
  Uint8List? _editingBytes;

  // -------- UNDO / REDO --------
  final List<Uint8List> _undoStack = [];
  final List<Uint8List> _redoStack = [];

  // -------- TEXT --------
  final TextController _textController = TextController();

  // -------- DOODLE --------
  final DoodleController _doodleController = DoodleController();

  // -------- ADJUST --------
  final AdjustController _adjustController = AdjustController();
  AdjustFeature? _activeAdjust;

  bool get _isToolActive =>
      _isTextEditing || _isDoodling || _activeAdjust != null;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<File?>(
        future: widget.image.file,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          _editingBytes ??= snapshot.data!.readAsBytesSync();

          return Stack(
            children: [
              // ================= IMAGE =================
              Center(
                child: AnimatedScale(
                  scale: _isEditing ? 0.85 : 1.0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                  child: _isCropping
                      ? CropEditor(
                    imageBytes: _editingBytes!,
                    onCropped: (bytes) {
                      _applyEdit(bytes);
                      setState(() => _isCropping = false);
                    },
                  )
                      : InteractiveViewer(
                    child: Image.memory(_editingBytes!),
                  ),
                ),
              ),

              // ================= CLOSE =================
              Positioned(
                top: 40,
                left: 20,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),

              // ================= UNDO / REDO =================
              if (_isEditing && !_isToolActive)
                UndoRedoBar(
                  canUndo: _undoStack.isNotEmpty,
                  canRedo: _redoStack.isNotEmpty,
                  onUndo: _undo,
                  onRedo: _redo,
                ),

              // ================= ACTION BAR =================
              if (!_isEditing)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: ImageActionBar(
                    imageId: widget.image.id,
                    onEdit: () => setState(() => _isEditing = true),
                  ),
                ),

              // ================= EDIT TRAY =================
              if (_isEditing && !_isToolActive)
                EditTray(
                  features: [
                    cropEditFeature(
                      onActivate: () => setState(() => _isCropping = true),
                    ),
                    rotateEditFeature(onRotate: _rotateImage),
                    flipHorizontalEditFeature(onFlip: _flipHorizontal),
                    flipVerticalEditFeature(onFlip: _flipVertical),

                    EditFeatureItem(
                      icon: Icons.text_fields,
                      label: "Text",
                      onTap: () {
                        setState(() => _isTextEditing = true);
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _textController.initialize(
                            MediaQuery.of(context).size,
                          );
                        });
                      },
                    ),

                    EditFeatureItem(
                      icon: Icons.brush,
                      label: "Doodle",
                      onTap: () => setState(() => _isDoodling = true),
                    ),

                    // 🟢 UNIFIED ADJUST (Exposure example)
                    ...adjustFeatures.map((feature) {
                      return EditFeatureItem(
                        icon: feature.icon,
                        label: feature.label,
                        onTap: () {
                          _adjustController.reset();
                          setState(() => _activeAdjust = feature);
                        },
                      );
                    }).toList(),

                  ],
                  onCancel: _exitEditMode,
                  onSave: _saveEdits,
                ),

              // ================= TEXT =================
              if (_isTextEditing)
                TextEditor(
                  controller: _textController,
                  baseImage: _editingBytes!,
                  onBack: () => setState(() => _isTextEditing = false),
                  onDone: (bytes) {
                    _applyEdit(bytes);
                    setState(() => _isTextEditing = false);
                  },
                ),


              // ================= DOODLE =================
              if (_isDoodling)
                DoodleEditor(
                  controller: _doodleController,
                  baseImage: _editingBytes!,
                  onBack: () => setState(() => _isDoodling = false),
                  onDone: (bytes) {
                    _applyEdit(bytes);
                    setState(() => _isDoodling = false);
                  },
                ),


              // ================= ADJUST =================
              if (_activeAdjust != null)
                AdjustEditor(
                  baseImage: _editingBytes!,
                  feature: _activeAdjust!,
                  controller: _adjustController,
                  onBack: () {
                    setState(() => _activeAdjust = null); // 🔥 FIX
                  },
                  onDone: (bytes) {
                    _applyEdit(bytes);
                    setState(() => _activeAdjust = null);
                  },
                ),


            ],
          );
        },
      ),
    );
  }

  // ================= HELPERS =================

  void _applyEdit(Uint8List newBytes) {
    _undoStack.add(_editingBytes!);
    _redoStack.clear();
    setState(() => _editingBytes = newBytes);
  }

  void _undo() {
    if (_undoStack.isEmpty) return;
    _redoStack.add(_editingBytes!);
    setState(() => _editingBytes = _undoStack.removeLast());
  }

  void _redo() {
    if (_redoStack.isEmpty) return;
    _undoStack.add(_editingBytes!);
    setState(() => _editingBytes = _redoStack.removeLast());
  }

  void _rotateImage() => _applyEdit(rotate90(_editingBytes!));
  void _flipHorizontal() => _applyEdit(flipHorizontal(_editingBytes!));
  void _flipVertical() => _applyEdit(flipVertical(_editingBytes!));

  Future<void> _saveEdits() async {
    final action = await showSaveSheet(context);
    if (action == null) return;

    final name = widget.image.title ??
        "edited_${DateTime.now().millisecondsSinceEpoch}.jpg";

    await PhotoManager.editor.saveImage(
      _editingBytes!,
      filename: action == SaveAction.replace ? name : "edited_$name",
    );

    if (action == SaveAction.replace) {
      await PhotoManager.editor.deleteWithIds([widget.image.id]);
    }

    _exitEditMode();
    Navigator.pop(context);
  }

  void _exitEditMode() {
    setState(() {
      _editingBytes = null;
      _undoStack.clear();
      _redoStack.clear();
      _isEditing = false;
      _isCropping = false;
      _isTextEditing = false;
      _isDoodling = false;
      _activeAdjust = null;
    });
  }
}








// class ImageViewer extends StatelessWidget {
//   final AssetEntity image;
//
//   const ImageViewer({super.key, required this.image});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: FutureBuilder(
//         future: image.file,
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return const Center(child: CircularProgressIndicator());
//           }
//
//           return Stack(
//             children: [
//               Center(
//                 child: InteractiveViewer(child: Image.file(snapshot.data!)),
//               ),
//               Positioned(
//                 top: 40,
//                 left: 20,
//                 child: IconButton(
//                   icon: const Icon(Icons.close, color: Colors.white),
//                   onPressed: () => Navigator.pop(context),
//                 ),
//               ),
//               Positioned(
//                 left: 0,
//                 right: 0,
//                 bottom: 0,
//                 child: ImageActionBar(
//                     imageId: image.id,
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }
