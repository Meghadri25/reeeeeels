// lib/widgets/short_card.dart

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class ShortCard extends StatefulWidget {
  final String videoUrl;
  final bool   useNetwork;
  final double height;
  final double width;
  final bool   autoPlay;

  const ShortCard({
    Key? key,
    required this.videoUrl,
    required this.height,
    required this.width,
    this.autoPlay = false,
    this.useNetwork = false,
  }) : super(key: key);

  @override
  ShortCardState createState() => ShortCardState();
}

/// Public state class so other files can reference `ShortCardState` (no leading underscore).
class ShortCardState extends State<ShortCard> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  Uint8List? _thumbnailBytes;

  @override
  void initState() {
    super.initState();

    // 1) Choose between network‐based URL or local asset
    if (widget.useNetwork) {
      _controller = VideoPlayerController.network(widget.videoUrl);
    } else {
      _controller = VideoPlayerController.asset(widget.videoUrl);
    }

    // 2) Initialize controller, then (if requested) auto‐play & generate thumbnail
    _controller!
      ..initialize().then((_) {
        if (!mounted) return;
        setState(() {
          _isInitialized = true;
        });
        _controller!
          ..setLooping(true)
          ..setVolume(0.0);

        if (widget.autoPlay) {
          _controller!.play();
        }

        _generateThumbnail();
      });
  }

  Future<void> _generateThumbnail() async {
    try {
      final data = await VideoThumbnail.thumbnailData(
        video: widget.videoUrl,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 128,
        quality: 25,
      );
      if (data != null && mounted) {
        setState(() {
          _thumbnailBytes = data;
        });
      }
    } catch (e) {
      // ignore errors silently
    }
  }


  void play() {
    if (_isInitialized) _controller?.play();
  }


  void pause() {
    if (_isInitialized) _controller?.pause();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: Card(
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(fit: StackFit.expand, children: [
          // 1) If initialized & autoPlay == true → show looping video
          if (_isInitialized && widget.autoPlay)
            FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _controller!.value.size.width,
                height: _controller!.value.size.height,
                child: VideoPlayer(_controller!),
              ),
            )

          // 2) If initialized & autoPlay == false → show generated thumbnail
          else if (_isInitialized && !widget.autoPlay)
            (_thumbnailBytes != null
                ? Image.memory(
                    _thumbnailBytes!,
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, err, st) =>
                        const Center(child: Icon(Icons.broken_image)),
                  )
                : Container(
                    color: Colors.black12,
                    child: const Center(
                      child: Icon(Icons.image, size: 40, color: Colors.grey),
                    ),
                  ))


          else
            const Center(child: CircularProgressIndicator()),
        ]),
      ),
    );
  }
}
