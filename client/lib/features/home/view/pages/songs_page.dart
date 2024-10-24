import 'package:client/core/providers/current_song_notifier.dart';
import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/widgets/loader.dart';
import 'package:client/features/home/view%20model/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SongsPage extends ConsumerStatefulWidget {
  const SongsPage({super.key});

  @override
  ConsumerState<SongsPage> createState() => _SongsPageState();
}

class _SongsPageState extends ConsumerState<SongsPage> {
  @override
  Widget build(BuildContext context) {
    final recentlyPlayedSongs =
        ref.watch(homeViewModelProvider.notifier).getRecentlyPlayedSongs();
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 280,
            child: GridView.builder(
                shrinkWrap: true,
                itemCount: recentlyPlayedSongs.length,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    childAspectRatio: 3,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    maxCrossAxisExtent: 200),
                itemBuilder: (context, index) {
                  final song = recentlyPlayedSongs[index];
                  return Container(
                    decoration: const BoxDecoration(color: Pallete.cardColor),
                    child: Row(
                      children: [
                        Container(
                          width: 56,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(song.thumbnail_url),
                                  fit: BoxFit.cover),
                              borderRadius: BorderRadius.circular(4)),
                        )
                      ],
                    ),
                  );
                }),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Latest Today",
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.w700),
            ),
          ),
          ref.watch(getAllSongsProvider).when(data: (songs) {
            return SizedBox(
              height: 260,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: songs.length,
                  itemBuilder: (context, index) {
                    final song = songs[index];
                    return Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: GestureDetector(
                        onTap: () {
                          ref
                              .watch(currentSongNotifierProvider.notifier)
                              .updateSong(song);
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 180,
                              width: 180,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7),
                                  image: DecorationImage(
                                      image: NetworkImage(song.thumbnail_url),
                                      fit: BoxFit.cover)),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            SizedBox(
                              width: 180,
                              child: Text(
                                maxLines: 1,
                                song.song_name,
                                style: const TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                            SizedBox(
                              width: 180,
                              child: Text(
                                maxLines: 1,
                                song.artist,
                                style: const TextStyle(
                                    color: Pallete.subtitleText,
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }),
            );
          }, error: (error, stackTrace) {
            return Center(
              child: Text(error.toString()),
            );
          }, loading: () {
            return const Loader();
          }),
        ],
      ),
    );
  }
}
