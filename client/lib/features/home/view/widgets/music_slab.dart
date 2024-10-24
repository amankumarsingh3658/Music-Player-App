import 'package:client/core/providers/current_song_notifier.dart';
import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/utils.dart';
import 'package:client/features/home/view/widgets/music_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MusicSlab extends ConsumerWidget {
  const MusicSlab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSong = ref.watch(currentSongNotifierProvider);
    final songNotifier = ref.read(currentSongNotifierProvider.notifier);
    if (currentSong == null) {
      return const SizedBox();
    }
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryanimation) {
                return const MusicPlayer();
              },
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                final tween =
                    Tween(begin: const Offset(0, 1), end: const Offset(0, 0))
                        .chain(CurveTween(curve: Curves.easeIn));
                final offsetAnimation = animation.drive(tween);

                return SlideTransition(
                  position: offsetAnimation,
                  child: child,
                );
              },
            ));
      },
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: hexToColor(currentSong.hexCode)),
            height: 66,
            width: MediaQuery.of(context).size.width - 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(9.0),
                  child: Row(
                    children: [
                      Hero(
                        tag: 'Music-image',
                        child: Container(
                          width: 48,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              image: DecorationImage(
                                  image:
                                      NetworkImage(currentSong.thumbnail_url),
                                  fit: BoxFit.cover)),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentSong.song_name,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            currentSong.artist,
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Pallete.subtitleText),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          CupertinoIcons.heart,
                          color: Pallete.whiteColor,
                        )),
                    IconButton(
                        onPressed: () {
                          songNotifier.playPause();
                        },
                        icon: Icon(
                          songNotifier.isPlaying
                              ? CupertinoIcons.pause_fill
                              : CupertinoIcons.play_fill,
                          color: Pallete.whiteColor,
                        )),
                  ],
                )
              ],
            ),
          ),
          StreamBuilder(
              stream: songNotifier.audioPlayer?.positionStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox();
                }
                final position = snapshot.data;
                final duration = songNotifier.audioPlayer!.duration;
                double sliderValue = 0;
                if (position != null && duration != null) {
                  sliderValue =
                      position.inMilliseconds / duration.inMilliseconds;
                }
                return Positioned(
                    left: 8,
                    bottom: 0,
                    child: Container(
                      height: 2,
                      width: sliderValue *
                          (MediaQuery.of(context).size.width - 32),
                      decoration:
                          const BoxDecoration(color: Pallete.whiteColor),
                    ));
              }),
          Positioned(
              left: 8,
              bottom: 0,
              child: Container(
                height: 2,
                width: MediaQuery.of(context).size.width - 32,
                decoration: BoxDecoration(
                    color: Pallete.inactiveSeekColor,
                    borderRadius: BorderRadius.circular(7)),
              ))
        ],
      ),
    );
  }
}
