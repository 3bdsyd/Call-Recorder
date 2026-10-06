import 'dart:io';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../../core/format.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key, required this.path, required this.title});
  final String path;
  final String title;

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  final _player = AudioPlayer();
  String? _error;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    try {
      if (!File(widget.path).existsSync()) {
        setState(() => _error = 'الملف غير موجود على الجهاز');
        return;
      }
      await _player.setFilePath(widget.path);
      setState(() => _ready = true);
    } catch (e) {
      setState(() => _error = 'تعذّر فتح الملف: $e');
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title, overflow: TextOverflow.ellipsis)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: _error != null
            ? Center(child: Text(_error!))
            : !_ready
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.graphic_eq, size: 72),
                      const SizedBox(height: 24),
                      StreamBuilder<Duration>(
                        stream: _player.positionStream,
                        builder: (context, posSnap) {
                          final pos = posSnap.data ?? Duration.zero;
                          final total = _player.duration ?? Duration.zero;
                          final max = total.inMilliseconds.toDouble().clamp(1, double.infinity).toDouble();
                          return Column(
                            children: [
                              Slider(
                                value: pos.inMilliseconds.toDouble().clamp(0, max).toDouble(),
                                max: max,
                                onChanged: (v) => _player.seek(Duration(milliseconds: v.toInt())),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(Fmt.duration(pos.inMilliseconds)),
                                  Text(Fmt.duration(total.inMilliseconds)),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      StreamBuilder<PlayerState>(
                        stream: _player.playerStateStream,
                        builder: (context, snap) {
                          final playing = snap.data?.playing ?? false;
                          final completed = snap.data?.processingState == ProcessingState.completed;
                          return IconButton.filled(
                            iconSize: 56,
                            icon: Icon(playing ? Icons.pause : Icons.play_arrow),
                            onPressed: () {
                              if (completed) {
                                _player.seek(Duration.zero);
                                _player.play();
                              } else if (playing) {
                                _player.pause();
                              } else {
                                _player.play();
                              }
                            },
                          );
                        },
                      ),
                    ],
                  ),
      ),
    );
  }
}
