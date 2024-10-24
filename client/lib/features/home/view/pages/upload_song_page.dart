import 'dart:io';

import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/utils.dart';
import 'package:client/core/widgets/custom_field.dart';
import 'package:client/core/widgets/loader.dart';
import 'package:client/features/home/view%20model/home_view_model.dart';
import 'package:client/features/home/view/widgets/audio_wave.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UploadSongPage extends ConsumerStatefulWidget {
  const UploadSongPage({super.key});

  @override
  ConsumerState<UploadSongPage> createState() => _UploadSongPageState();
}

class _UploadSongPageState extends ConsumerState<UploadSongPage> {
  final songNameController = TextEditingController();
  final artistNameController = TextEditingController();

  Color selectedColor = Pallete.cardColor;

  File? selectedImage;
  File? selectedAudio;

  @override
  void dispose() {
    songNameController.dispose();
    artistNameController.dispose();
    super.dispose();
  }

  void selectImage() async {
    final pickedImage = await pickImage();

    if (pickedImage != null) {
      setState(() {
        selectedImage = pickedImage;
      });
    }
  }

  void selectAudio() async {
    final pickedAudio = await pickAudio();

    if (pickedAudio != null) {
      setState(() {
        selectedAudio = pickedAudio;
      });
    }
  }

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final isLoading = ref
        .watch(homeViewModelProvider.select((val) => val?.isLoading == true));
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                if (formKey.currentState!.validate() &&
                    selectedAudio != null &&
                    selectedImage != null) {
                  ref.read(homeViewModelProvider.notifier).uploadSong(
                      selectAudio: selectedAudio!,
                      selectedThumbnail: selectedImage!,
                      songName: songNameController.text,
                      artist: artistNameController.text,
                      selectedColor: selectedColor);
                } else {
                  showSnackBar(context, "Missing Fields");
                }
              },
              icon: const Icon(Icons.check))
        ],
        title: const Text("Upload Songs"),
      ),
      body: isLoading
          ? const Loader()
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          selectImage();
                        },
                        child: selectedImage != null
                            ? SizedBox(
                                height: 150,
                                width: double.infinity,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    selectedImage!,
                                    fit: BoxFit.cover,
                                  ),
                                ))
                            : DottedBorder(
                                strokeCap: StrokeCap.round,
                                borderType: BorderType.RRect,
                                radius: const Radius.circular(10),
                                color: Pallete.borderColor,
                                dashPattern: const [10, 4],
                                child: const SizedBox(
                                  height: 150,
                                  width: double.infinity,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.folder_open,
                                        size: 40,
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        "Select a thumbnail for your song",
                                        style: TextStyle(fontSize: 15),
                                      )
                                    ],
                                  ),
                                )),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      selectedAudio != null
                          ? AudioWave(path: selectedAudio!.path)
                          : CustomField(
                              hintText: "Pick Song",
                              controller: null,
                              readOnly: true,
                              onTap: () => selectAudio(),
                            ),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomField(
                        hintText: "Artist",
                        controller: artistNameController,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomField(
                        hintText: "Song Name",
                        controller: songNameController,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ColorPicker(
                          pickersEnabled: const {ColorPickerType.wheel: true},
                          color: selectedColor,
                          onColorChanged: (color) {
                            setState(() {
                              selectedColor = color;
                            });
                          })
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
