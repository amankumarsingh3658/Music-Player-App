import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:client/core/theme/app_pallete.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AudioWave extends StatefulWidget {
  final String path;
  const AudioWave({super.key, required this.path});

  @override
  State<AudioWave> createState() => _AudioWaveState();
}

class _AudioWaveState extends State<AudioWave> {
  final playerController = PlayerController();

  @override
  void initState() {
    initAudioPlayer();
    super.initState();
  }

  Future<void> playAndPause() async {
    if (!playerController.playerState.isPlaying) {
      await playerController.startPlayer(finishMode: FinishMode.stop);
    } else if (!playerController.playerState.isPaused) {
      await playerController.pausePlayer();
    }
    setState(() {});
  }

  void initAudioPlayer() async {
    await playerController.preparePlayer(path: widget.path);
  }

  @override
  void dispose() {
    playerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(onPressed: (){
          playAndPause();
        }, icon: playerController.playerState.isPlaying? const Icon(CupertinoIcons.pause_solid):const Icon(CupertinoIcons.play_arrow_solid)),
        Expanded(
          child: AudioFileWaveforms(
              playerWaveStyle: const PlayerWaveStyle(
                fixedWaveColor: Pallete.borderColor,
                liveWaveColor: Pallete.gradient2,
                spacing: 7,
                showSeekLine: false,
              ),
              waveformType: WaveformType.long,
              size: const Size(double.infinity, 50),
              playerController: playerController),
        ),
      ],
    );
  }
}
