import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'image_viewer.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  List<AssetEntity> images = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    final permission = await PhotoManager.requestPermissionExtend();

    if (permission.isAuth) {
      await PhotoManager.openSetting();
      return;
    }

    final albums = await PhotoManager.getAssetPathList(
      type: RequestType.image,
      onlyAll: true,
    );

    if (albums.isEmpty) {
      setState(() {
        images = [];
        loading = false;
      });
      return;
    }

    final recentAlbum = albums.first;

    final media = await recentAlbum.getAssetListPaged(page: 0, size: 100);

    setState(() {
      images = media;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gallery')),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : images.isEmpty
          ? Center(child: Text('No images found'))
          : GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 6,
                mainAxisSpacing: 6,
              ),
              itemCount: images.length,
              itemBuilder: (context, index) {
                return FutureBuilder<Uint8List?>(
                  future: images[index].thumbnailDataWithOption(
                    const ThumbnailOption(size: ThumbnailSize(200, 200)),
                  ),
                  builder: (context, snapshot) {
                    final bytes = snapshot.data;
                    if (bytes == null) {
                      return Container(color: Colors.grey.shade300);
                    }
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ImageViewer(image: images[index]),
                          ),
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.memory(
                          bytes,
                          fit: BoxFit.cover,
                          gaplessPlayback: true,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
