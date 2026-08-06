import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class SoundEngine {
  
  static final SoundEngine instance = SoundEngine._internal();

  SoundEngine._internal();

  bool _isSoundEnabled = true;
  bool get isSoundEnabled => _isSoundEnabled;

  
  final List<AudioPlayer> _players = List.generate(
    5,
    (_) => AudioPlayer()..setReleaseMode(ReleaseMode.stop),
  );
  int _currentPlayerIndex = 0;

  final AudioPlayer _terminalPlayer = AudioPlayer()
    ..setReleaseMode(ReleaseMode.stop);
  final AudioPlayer _ambientPadPlayer = AudioPlayer()
    ..setReleaseMode(ReleaseMode.loop);
  final AudioPlayer _electricHumPlayer = AudioPlayer()
    ..setReleaseMode(ReleaseMode.loop);
  bool _isAmbientPlaying = false;

  Future<void> initialize() async {
    
    
    await Future.wait([
      AudioCache.instance.load('audio/hover.wav'),
      AudioCache.instance.load('audio/click.wav'),
      AudioCache.instance.load('audio/type.wav'),
      AudioCache.instance.load('audio/enter.wav'),
      AudioCache.instance.load('audio/success.wav'),
      AudioCache.instance.load('audio/whoosh.wav'),
      AudioCache.instance.load('audio/ambient_pad.wav'),
      AudioCache.instance.load('audio/electric_hum.wav'),
    ]);
  }

  void toggleSound() {
    _isSoundEnabled = !_isSoundEnabled;
    if (_isSoundEnabled) {
      if (!_isAmbientPlaying) startAmbientLoops();
    } else {
      stopAmbientLoops();
    }
  }

  void setSoundEnabled(bool enabled) {
    if (_isSoundEnabled == enabled) return;
    _isSoundEnabled = enabled;
    if (enabled) {
      startAmbientLoops();
    } else {
      stopAmbientLoops();
    }
  }

  Future<void> startAmbientLoops() async {
    if (!_isSoundEnabled || _isAmbientPlaying) return;
    try {
      _isAmbientPlaying = true;
      await _ambientPadPlayer.setVolume(0.08); 
      await _ambientPadPlayer.play(AssetSource('audio/ambient_pad.wav'));

      await _electricHumPlayer.setVolume(0.03); 
      await _electricHumPlayer.play(AssetSource('audio/electric_hum.wav'));
    } catch (e) {
      debugPrint("Error starting ambient loops: $e");
    }
  }

  Future<void> stopAmbientLoops() async {
    _isAmbientPlaying = false;
    try {
      await _ambientPadPlayer.stop();
      await _electricHumPlayer.stop();
    } catch (e) {
      debugPrint("Error stopping ambient loops: $e");
    }
  }

  Future<void> _play(String assetPath, {double volume = 0.15}) async {
    if (!_isSoundEnabled) return;

    try {
      final player = _players[_currentPlayerIndex];
      _currentPlayerIndex = (_currentPlayerIndex + 1) % _players.length;

      await player.setVolume(volume);
      await player.play(AssetSource(assetPath));
    } catch (e) {
      debugPrint("Error playing sound $assetPath: $e");
    }
  }

  void playHover() => _play('audio/hover.wav', volume: 0.10);
  void playClick() => _play('audio/click.wav', volume: 0.20);
  void playSuccess() => _play('audio/success.wav', volume: 0.15);
  void playWhoosh() => _play('audio/whoosh.wav', volume: 0.15);

  void playTerminalType() async {
    if (!_isSoundEnabled) return;
    try {
      await _terminalPlayer.setVolume(0.12);
      await _terminalPlayer.play(AssetSource('audio/type.wav'));
    } catch (e) {
      debugPrint("Error playing terminal type: $e");
    }
  }

  void playTerminalEnter() => _play('audio/enter.wav', volume: 0.20);
}
