// lib/homepage.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'widgets/short_card.dart';
import 'shorts.dart';
import 'screens/shorts_feed_page.dart';

class Home_Page extends StatelessWidget {
  const Home_Page({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth  = MediaQuery.of(context).size.width;
    final bool   isTablet     = screenWidth > 600;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 10),
          children: [
            // Search Field
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
              child: Container(
                height: isTablet ? screenHeight * 0.1 : screenHeight * 0.08,
                padding: EdgeInsets.only(
                  top: isTablet ? screenHeight * 0.04 : screenHeight * 0.02,
                ),
                child: TextField(
                  decoration: InputDecoration(
                    filled: true,
                    prefixIcon: const Icon(Icons.search),
                    hintText: 'Search',
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // Top Picks Header
            Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
              child: Text(
                'Top Picks',
                style: GoogleFonts.montserrat(
                  fontSize: isTablet ? 24 : 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            // Top Picks Content
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.02),
              child: Row(
                children: [
                  // index = 0
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ShortsFeedPage(initialIndex: 0),
                        ),
                      );
                    },
                    child: ShortCard(
                      videoUrl: shorts[0]['videoUrl']!,
                      height: screenHeight * 0.4,
                      width:  screenWidth  * 0.48,
                      useNetwork: false,
                      autoPlay: true,
                    ),
                  ),

                  Column(
                    children: [
                      // index = 1
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ShortsFeedPage(initialIndex: 1),
                            ),
                          );
                        },
                        child: ShortCard(
                          videoUrl: shorts[1]['videoUrl']!,
                          height: screenHeight * 0.2,
                          width:  screenWidth  * 0.48,
                          useNetwork: false,
                          autoPlay: true,
                        ),
                      ),

                      // index = 2
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ShortsFeedPage(initialIndex: 2),
                            ),
                          );
                        },
                        child: ShortCard(
                          videoUrl: shorts[2]['videoUrl']!,
                          height: screenHeight * 0.2,
                          width:  screenWidth  * 0.48,
                          useNetwork: false,
                          autoPlay: true,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Dive In Header
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Dive in',
                style: GoogleFonts.montserrat(
                  fontSize: isTablet ? 24 : 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            // Dive In Horizontal List
            SizedBox(
              height: screenHeight * 0.2,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 10,
                itemBuilder: (context, index) {
                  // For this example we’ll always show shorts[0]. If you want
                  // a real “dive in” list, replace index logic accordingly.
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ShortsFeedPage(initialIndex: 0),
                        ),
                      );
                    },
                    child: ShortCard(
                      videoUrl: shorts[0]['videoUrl']!,
                      height: screenHeight * 0.15,
                      width: isTablet ? screenWidth * 0.25 : screenWidth * 0.375,
                      useNetwork: false,
                      autoPlay: false,
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // Discover Header
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Discover',
                style: GoogleFonts.montserrat(
                  fontSize: isTablet ? 24 : 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            // Discover Grid (2 columns)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
              child: Column(
                children: [
                  for (int i = 0; i < 3; i++)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            // Replace “0” with whatever index you want to open
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ShortsFeedPage(initialIndex: 0),
                              ),
                            );
                          },
                          child: ShortCard(
                            videoUrl: shorts[0]['videoUrl']!,
                            height: screenHeight * 0.2,
                            width:  screenWidth  * 0.48,
                            useNetwork: false,
                            autoPlay: false,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            // Replace “0” with whatever index you want
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ShortsFeedPage(initialIndex: 0),
                              ),
                            );
                          },
                          child: ShortCard(
                            videoUrl: shorts[0]['videoUrl']!,
                            height: screenHeight * 0.2,
                            width:  screenWidth  * 0.48,
                            useNetwork: false,
                            autoPlay: false,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
