import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class ShortCard extends StatefulWidget {
  final Map<String, String> short;
  final double h;
  final double w;
  final bool autoPlay;

  const ShortCard({
    super.key,
    required this.short,
    required this.h,
    required this.w,
    this.autoPlay = false,
  });

  @override
  State<ShortCard> createState() => _ShortCardState();
}

class _ShortCardState extends State<ShortCard> {
  Uint8List? _thumbnailBytes;
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.short['videoUrl']!)
      ..initialize().then((_) {
        setState(() {
          _isInitialized = true;
        });
        _controller.setLooping(true);
        _controller.setVolume(0.0);
        _controller.play();
        _generateThumbnail();
      });
  }

  Future<void> _generateThumbnail() async {
    try {
      final uint8list = await VideoThumbnail.thumbnailData(
        video: widget.short['videoUrl']!,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 128, // thumbnail width
        quality: 25,
      );
      if (uint8list != null && mounted) {
        setState(() {
          _thumbnailBytes = uint8list;
        });
      }
    } catch (e) {
      // handle error silently or print
      // print('Thumbnail generation error: $e');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.h,
      width: widget.w,
      child: Card(
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(16),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (_isInitialized && widget.autoPlay)
              FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _controller.value.size.width,
                  height: _controller.value.size.height,
                  child: VideoPlayer(_controller),
                ),
              )
            else if (_isInitialized && !widget.autoPlay)
              (_thumbnailBytes != null
                  ? Image.memory(
                      _thumbnailBytes!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Center(child: Icon(Icons.broken_image)),
                    )
                  : Container(
                      color: Colors.black12, // Or any placeholder color/image
                      child: const Center(
                        child: Icon(Icons.image, size: 40, color: Colors.grey),
                      ),
                    ))
            else
              const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
