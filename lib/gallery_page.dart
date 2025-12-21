import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:photo_manager/photo_manager.dart';
import 'image_viewer.dart';
import 'sort_option.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> with WidgetsBindingObserver {
  List<AssetEntity> images = [];
  bool loading = true;
  SortOption sort = SortOption.recent;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadImages();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadImages();
    }
  }

  Future<void> _loadImages() async {
    setState(() => loading = true);

    final permission = await PhotoManager.requestPermissionExtend();

    if (permission.isAuth) {
      setState(() => loading = false);
      return;
    }

    final paths = await PhotoManager.getAssetPathList(
      type: RequestType.image,
      filterOption: FilterOptionGroup(
        orders: [
          const OrderOption(type: OrderOptionType.createDate, asc: false),
        ],
      ),
    );
    if (paths.isEmpty) {
      setState(() => loading = false);
      return;
    }

    // Pick the first album that actually has images
    AssetPathEntity? target;

    for (final path in paths) {
      final count = await path.assetCountAsync;
      if (count > 0) {
        target = path;
        break;
      }
    }

    if (target == null) {
      setState(() => loading = false);
      return;
    }

    final media = await target.getAssetListPaged(page: 0, size: 200);

    setState(() {
      images = _sort(media);
      loading = false;
    });
  }

  int _rowSpanForIndex(int index) {
    // Creates visual rhythm: tall tile every 6 items
    if (index % 6 == 0) return 2;
    return 1;
  }

  List<AssetEntity> _sort(List<AssetEntity> media) {
    final sorted = List<AssetEntity>.from(media);

    switch (sort) {
      case SortOption.recent:
        sorted.sort((a, b) => b.createDateTime.compareTo(a.createDateTime));
        return sorted;
      case SortOption.size:
        // AssetEntity.size is a Size (dimensions), so sort by pixel area.
        int area(AssetEntity e) => e.size.width.toInt() * e.size.height.toInt();
        sorted.sort((a, b) => area(b).compareTo(area(a)));
        return sorted;
      case SortOption.oldest:
        sorted.sort((a, b) => a.createDateTime.compareTo(b.createDateTime));
        return sorted;
      default:
        return sorted;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gallery'),
        actions: [
          PopupMenuButton<SortOption>(
            icon: const Icon(Icons.sort),
            onSelected: (value) {
              setState(() {
                sort = value;
                images = _sort(images);
              });
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: SortOption.recent,
                child: Text('Recently added'),
              ),
              PopupMenuItem(
                value: SortOption.oldest,
                child: Text('Oldest first'),
              ),
              PopupMenuItem(value: SortOption.size, child: Text('File size')),
            ],
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : images.isEmpty
          ? const Center(child: Text('No images found.'))
          : Padding(
              padding: const EdgeInsets.fromLTRB(6, 6, 6, 0),
              child: MasonryGridView.count(
                crossAxisCount:
                    MediaQuery.of(context).orientation == Orientation.portrait
                    ? 3
                    : 5,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                itemCount: images.length,
                itemBuilder: (context, index) {
                  return _GalleryTile(asset: images[index]);
                },
              ),
            ),
    );
  }
}

class _GalleryTile extends StatelessWidget {
  final AssetEntity asset;

  const _GalleryTile({required this.asset});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: FutureBuilder<Uint8List?>(
        future: asset.thumbnailDataWithSize(const ThumbnailSize(400, 400)),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Container(
              color: Colors.black12,
              child: const Center(child: Icon(Icons.image, size: 32)),
            );
          }

          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ImageViewer(image: asset)),
              );
            },
            child: Image.memory(
              snapshot.data!,
              fit: BoxFit.cover,
              gaplessPlayback: true,
            ),
          );
        },
      ),
    );
  }
}
