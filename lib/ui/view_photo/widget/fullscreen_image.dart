import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';

class FullScreenImage extends StatefulWidget {
  final Uint8List image;

  const FullScreenImage({
    super.key,
    required this.image,
});

  @override
  State<StatefulWidget> createState() => _FullScreenImageState();
}

class _FullScreenImageState extends State<FullScreenImage> {
  double scaleLevel = 1.0;
  static const double kScaleFactor = 3.0;
  static const double kMaxDoubleTapScaleLevel = 9.0;
  final TransformationController _controller = TransformationController();
  late Offset _doubleTapPosition = Offset.zero;

  void _handleDoubleTapDown(details) {
    _doubleTapPosition = _controller.toScene(details.localPosition);
  }

  void _handleInteractionUpdate(details) {
    // update scaleLevel when user zooms in
    scaleLevel = _controller.value.getMaxScaleOnAxis();
  }

  void _handleDoubleTap() {
    setState(() {
      if (scaleLevel >= kMaxDoubleTapScaleLevel) {
        scaleLevel = 1.0;
      } else {
        scaleLevel = min(scaleLevel * kScaleFactor, kMaxDoubleTapScaleLevel);
      }
      // Scale the image then translate it so that the tapped position is still under the finger
      _controller.value = Matrix4.identity() * scaleLevel;
      if (scaleLevel > 1.0) {
        _controller.value.setTranslationRaw(
          _doubleTapPosition.dx * (1 - scaleLevel),
          _doubleTapPosition.dy * (1 - scaleLevel),
          0.0,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: _handleDoubleTap,
      onDoubleTapDown: _handleDoubleTapDown,
      child: InteractiveViewer(
        maxScale: 100,
        transformationController: _controller,
        onInteractionUpdate: _handleInteractionUpdate,
        child: Center(
          child: Image.memory(
            widget.image,
            filterQuality: FilterQuality
                .none, // Disable any scaling so that we can see the individual pixels
          ),
        ),
      ),
    );
  }
}
