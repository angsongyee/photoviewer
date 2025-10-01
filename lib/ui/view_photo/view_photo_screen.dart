import 'package:flutter/material.dart';
import 'model/exif_data.dart';
import 'package:photo_viewer/ui/view_photo/widget/fullscreen_image.dart';
import 'package:photo_viewer/ui/view_photo/widget/bottom_info_sheet.dart';

class ViewPhotoScreen extends StatefulWidget {
  final String imagePath;

  const ViewPhotoScreen({super.key, required this.imagePath});

  @override
  State<StatefulWidget> createState() => _ViewPhotoScreenState();
}

class _ViewPhotoScreenState extends State<ViewPhotoScreen> {
  ExifData? imageMetadata;

  @override
  void initState() {
    super.initState();
    _loadImageMetadata();
  }

  void _loadImageMetadata() async {
    var imageData = await DefaultAssetBundle.of(
      context,
    ).load("assets/images/testimage.JPG");
    List<int> imageBytes = imageData.buffer.asUint8List() as List<int>;
    imageMetadata = await ExifData.fromBytes(imageBytes);
    print(imageMetadata);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FullScreen(image: AssetImage(widget.imagePath)),
        if (imageMetadata != null)
          BottomInfoSheet(imageMetadata: imageMetadata!)
      ],
    );
  }
}
