import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'model/exif_data.dart';
import 'package:photo_viewer/ui/view_photo/widget/fullscreen_image.dart';
import 'package:photo_viewer/ui/view_photo/widget/bottom_info_sheet.dart';

class ViewPhotoScreen extends StatefulWidget {
  final Uint8List imageBytes;
  const ViewPhotoScreen({super.key, required this.imageBytes});

  @override
  State<StatefulWidget> createState() => _ViewPhotoScreenState();
}

class _ViewPhotoScreenState extends State<ViewPhotoScreen> {
  ExifData? imageMetadata;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadImageMetadata();
    });

  }

  void _loadImageMetadata() async {
    final result =  await ExifData.fromBytes(widget.imageBytes);
    if (mounted) {
      setState(() {
        imageMetadata = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FullScreenImage(image: widget.imageBytes),
        if (imageMetadata != null)
          BottomInfoSheet(imageMetadata: imageMetadata!),
      ],
    );
  }
}
