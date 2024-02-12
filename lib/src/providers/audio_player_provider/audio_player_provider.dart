import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:perfect_volume_control/perfect_volume_control.dart';

class AudioPlayerProvider extends ChangeNotifier {
  final player = AudioPlayer();

  void playSound(String sound) async {
    PerfectVolumeControl.setVolume(1);
    await player.play(AssetSource('$sound.mp3'));
    player.setReleaseMode(ReleaseMode.loop);

    notifyListeners();
  }

  void stopSound() async {
    await player.stop();

    notifyListeners();
  }
}
