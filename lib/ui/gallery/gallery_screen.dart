import 'dart:io';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_viewer/ui/gallery/widgets/thumbnail_widget.dart';

import '../view_photo/view_photo_screen.dart';

class GalleryScreen extends StatefulWidget {
  final String directoryUri;
  const GalleryScreen({super.key, required this.directoryUri});

  @override
  State<StatefulWidget> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> with AutomaticKeepAliveClientMixin {
  static const platform = MethodChannel('photoviewer/channels');
  static const columnCount = 3;
  List<String>? images;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getImages();
    });
  }

  void _getImages() async {
    final resultImages = await platform.invokeMethod<List<dynamic>>(
      'getImages',
      {"directoryUri": widget.directoryUri},
    );
    images = resultImages?.cast<String>();
    setState(() {});
  }

  //TODO: find a way to load and display the thumbnail to speed up rendering
  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (images == null) {
      return Scaffold(appBar: AppBar(title: const Text("Gallery")));
    }
    return Scaffold(
      appBar: AppBar(title: const Text("Gallery")),
      body: GridView.builder(
        cacheExtent: 1000,
        itemCount: images!.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columnCount,
        ),
        itemBuilder: (BuildContext context, int index) {
          return Thumbnail(imageUrl: images![index]);
          // child: Image.asset(
          //   "assets/images/testimage.ARW",
          //   fit: BoxFit.cover,
          //   filterQuality: FilterQuality.low,
          // );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
