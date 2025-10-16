import 'package:flutter/material.dart';

import '../model/exif_data.dart';

class BottomInfoSheet extends StatefulWidget {
  final ExifData imageMetadata;

  const BottomInfoSheet({super.key, required this.imageMetadata});

  @override
  State<StatefulWidget> createState() => _BottomInfoSheetState();
}

class _BottomInfoSheetState extends State<BottomInfoSheet> {
  final controller = DraggableScrollableController();

  final double _initialChildSize = 0.11;
  final double _minChildSize = 0.11;
  final double _maxChildSize = 0.5;

  final Color _backgroundColor = Colors.black;
  int _opacity = 180;

  @override
  void initState() {
    super.initState();
    controller.addListener(_onSheetScrolled);
  }

  void _onSheetScrolled() {
    setState(() {
      _opacity =
          ((controller.size - _minChildSize) /
                  (_maxChildSize - _minChildSize) *
                  180)
              .toInt();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      controller: controller,
      initialChildSize: _initialChildSize,
      minChildSize: _minChildSize,
      maxChildSize: _maxChildSize,
      snap: true,
      builder: (BuildContext context, ScrollController scrollController) {
        return Material(
          color: _backgroundColor.withAlpha(_opacity),
          child: ListView(
            controller: scrollController,
            physics: const ClampingScrollPhysics(),
            padding: EdgeInsets.zero,
            children: [
              IconButton(
                onPressed: () {},
                style: IconButton.styleFrom(
                  splashFactory: NoSplash.splashFactory,
                ),
                iconSize: 28,
                padding: EdgeInsets.zero,
                icon: Icon(Icons.keyboard_arrow_up, color: Colors.white),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Column(
                  spacing: 5,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "IMAGETITLE.jpg",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      widget.imageMetadata.cameraModel,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Row(
                      children: [
                        Text(
                          widget.imageMetadata.toString(),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
