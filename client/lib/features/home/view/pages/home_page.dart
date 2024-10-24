import 'package:client/core/theme/app_pallete.dart';
import 'package:client/features/home/view/pages/library_page.dart';
import 'package:client/features/home/view/pages/songs_page.dart';
import 'package:client/features/home/view/widgets/music_slab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int selectedIndex = 0;

  final List<Widget> pages = [const SongsPage(), const LibraryPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (value) {
            selectedIndex = value;
            setState(() {});
          },
          items: [
            BottomNavigationBarItem(
                label: 'Home',
                icon: Image.asset(
                  selectedIndex == 0
                      ? 'assets/images/home_filled.png'
                      : 'assets/images/home_unfilled.png',
                  color: selectedIndex == 0
                      ? Pallete.whiteColor
                      : Pallete.inactiveBottomBarItemColor,
                )),
            BottomNavigationBarItem(
                label: 'Library',
                icon: Image.asset(
                  'assets/images/library.png',
                  color: selectedIndex == 1
                      ? Pallete.whiteColor
                      : Pallete.inactiveBottomBarItemColor,
                )),
          ]),
      body: Stack(
        children: [
          pages[selectedIndex],
          const Positioned(
            bottom: 0,
            child: MusicSlab()),
        ],
      ),
    );
  }
}
