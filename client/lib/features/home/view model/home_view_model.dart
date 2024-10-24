// ignore_for_file: functional_ref
import 'dart:io';

import 'package:client/core/providers/current_user_notifier.dart';
import 'package:client/core/utils.dart';
import 'package:client/features/home/model/song_model.dart';
import 'package:client/features/home/repositories/home_local_repository.dart';
import 'package:client/features/home/repositories/home_repository.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'home_view_model.g.dart';

@riverpod
Future<List<SongModel>> getAllSongs(GetAllSongsRef ref) async {
  final token = ref.watch(currentUserNotifierProvider)!.token;
  final res = await ref.watch(homeRepositoryProvider).getAllSongs(token: token);

  return res.fold((failure) => throw failure.message, (success) => success);
}

@riverpod
class HomeViewModel extends _$HomeViewModel {

  late final HomeRepository _homeRepository;
  final HomeLocalRepository _homeLocalRepository = HomeLocalRepository();
  @override
  AsyncValue? build() {
    _homeRepository = ref.watch(homeRepositoryProvider);
    return null;
  }

  Future<void> uploadSong({
    required File selectAudio,
    required File selectedThumbnail,
    required String songName,
    required String artist,
    required Color selectedColor,
  }) async {
    state = const AsyncValue.loading();

    final res = await _homeRepository.uploadSong(
        selectedAudio: selectAudio,
        selectedThumbnail: selectedThumbnail,
        songName: songName,
        artist: artist,
        hexCode: rgbToHex(selectedColor),
        token: ref.read(currentUserNotifierProvider)!.token);

    res.fold((error) => state = AsyncValue.error(error, StackTrace.current),
        (success) => state = AsyncValue.data(success));
  }

  List<SongModel> getRecentlyPlayedSongs(){
    return _homeLocalRepository.loadSongs();
  }
}
