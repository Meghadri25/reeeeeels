
import 'dart:async';
import 'package:flutter/material.dart';
import '../widgets/short_card.dart';
import '../shorts.dart';

class ShortsFeedPage extends StatefulWidget {
  final int initialIndex;

  const ShortsFeedPage({
    Key? key,
    required this.initialIndex,
  }) : super(key: key);

  @override
  State<ShortsFeedPage> createState() => _ShortsFeedPageState();
}

class _ShortsFeedPageState extends State<ShortsFeedPage> {
  late final PageController _pageController;
  late int _currentIndex;

  /// One GlobalKey per ShortCard so we can call pause()/play() on it.
  final List<GlobalKey<ShortCardState>> _shortKeys = [];

  @override
  void initState() {
    super.initState();

    // 1) Initialize current index and PageController
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);

    // 2) Build one GlobalKey for each entry in shorts[]
    for (int i = 0; i < shorts.length; i++) {
      _shortKeys.add(GlobalKey<ShortCardState>());
    }

    // 3) After a slight delay (post‐build), start playing the initial short if possible
    Timer(const Duration(milliseconds: 200), () {
      final initialState = _shortKeys[_currentIndex].currentState;
      if (initialState != null) {
        initialState.play();
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int newIndex) {
    // Called after the page has changed and the ShortCard for newIndex is built
    final oldState = _shortKeys[_currentIndex].currentState;
    final newState = _shortKeys[newIndex].currentState;

    if (oldState != null) {
      oldState.pause();
    }
    if (newState != null) {
      newState.play();
    }

    setState(() {
      _currentIndex = newIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size viewport = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        onPageChanged: _onPageChanged,
        itemCount: shorts.length,
        itemBuilder: (context, index) {
          final videoUrl = shorts[index]['videoUrl']!;
          final title    = shorts[index]['title'] ?? "";

          return Stack(
            fit: StackFit.expand,
            children: [
              // Fullscreen ShortCard
              ShortCard(
                key: _shortKeys[index],
                videoUrl: videoUrl,
                height: viewport.height,
                width: viewport.width,
                useNetwork: false,
                autoPlay: false, // initial play is triggered via Timer/onPageChanged
              ),

              // Example overlay (caption + icons) at bottom
              Positioned(
                bottom: 60,
                left: 16,
                right: 16,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Left: user handle + caption
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "@username",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),

                    // Right: icons + avatar
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.favorite_border,
                          color: Colors.white,
                          size: 32,
                        ),
                        const SizedBox(height: 24),
                        const Icon(
                          Icons.comment,
                          color: Colors.white,
                          size: 32,
                        ),
                        const SizedBox(height: 24),
                        const Icon(
                          Icons.share,
                          color: Colors.white,
                          size: 32,
                        ),
                        const SizedBox(height: 24),
                        const CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(
                            "https://www.example.com/user_avatar.jpg",
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
