import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import '../../view_photo/view_photo_screen.dart';

class Thumbnail extends StatefulWidget {
  final String imageUrl;
  const Thumbnail({super.key, required this.imageUrl});

  @override
  State<StatefulWidget> createState() => _ThumbnailState();
}

class _ThumbnailState extends State<Thumbnail> {
  static const platform = MethodChannel('photoviewer/channels');
  Uint8List? imageBytes;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getImageBytes();
    });
  }

  void _getImageBytes() async {
    final result = await platform.invokeMethod<Uint8List>('getImageBytes', {
      "imageUri": widget.imageUrl,
    });
    if (mounted) {
      setState(() {
        imageBytes = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (imageBytes == null) {
      return Center(child: CircularProgressIndicator());
    } else {
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ViewPhotoScreen(imageBytes: imageBytes!),
            ),
          );
        },
        child: Image.memory(imageBytes!, fit: BoxFit.cover, cacheWidth: 256),
      );
    }
  }
}
