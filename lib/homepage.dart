import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:just_audio/just_audio.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final FlutterTts flutterTts = FlutterTts();
  List<FileSystemEntity> _musicFiles = [];
  final audioPlayer = AudioPlayer();
  final TextEditingController textEditingController = TextEditingController();
  Map<String, String> languageMap = {
    'en-US': 'English',
  };
  @override
  void initState() {
    super.initState();
    initTts();
    _checkPermissions();
  }

  Future<void> playAudio(String filePath) async {
    try {
      await audioPlayer.setUrl(filePath);
      await audioPlayer.play();
    } catch (e) {
      debugPrint('Error playing audio: $e');
    }
  }

  List<String> languages = [];

  bool _isLoading = false;

  String? selectedLanguage;
  double pitch = 1.0;
  double speachRate = 0.0;
  double volume = 0.5;

  Future<void> initTts() async {
    List<dynamic> avalaible = await flutterTts.getLanguages;
    languages = avalaible
        .where(
          (language) => languageMap.keys.contains(language),
        )
        .map(
          (language) => language as String,
        )
        .toList();
    setState(() {});
  }

  Future<void> speak(String text) async {
    await flutterTts.setLanguage(selectedLanguage ?? "en-US");
    await flutterTts.setPitch(pitch);
    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(speachRate);
    await flutterTts.speak(text);
  }

  Future<void> save(String text) async {
    await flutterTts.setLanguage(selectedLanguage ?? "en-US");
    await flutterTts.setPitch(pitch);
    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(speachRate);
    String timespam = DateTime.now().microsecondsSinceEpoch.toString();
    await flutterTts.synthesizeToFile(text, 'audio_bite$timespam.mp3');
  }

  Future<void> stop() async {
    flutterTts.stop();
  }

  Future<void> puase() async {
    flutterTts.pause();
  }

  Future<void> _checkPermissions() async {
    PermissionStatus status = await Permission.manageExternalStorage.request();
    if (status.isGranted) {
      _loadMusicFiles();
    } else {
      debugPrint('Permission Denied');
    }
  }

  Future<void> _loadMusicFiles() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final musicDir = Directory('/storage/emulated/0/Music');

      if (await musicDir.exists()) {
        final List<FileSystemEntity> files = musicDir.listSync();
        setState(() {
          _musicFiles =
              files.where((file) => file.path.endsWith('.mp3')).toList();
        });
      } else {
        debugPrint('Directory does not exist');
      }
    } catch (e) {
      debugPrint('Error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: () async {
            return setState(() {
              initState();
            });
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  TextField(
                    maxLines: null,
                    minLines: 3,
                    controller: textEditingController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder()),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () {
                            setState(() {
                              speak(textEditingController.text);
                            });
                          },
                          icon: const Icon(
                            Icons.play_arrow,
                            color: Colors.greenAccent,
                          )),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              puase();
                            });
                          },
                          icon: const Icon(
                            Icons.pause,
                            color: Colors.amber,
                          )),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              stop();
                            });
                          },
                          icon: const Icon(
                            Icons.stop,
                            color: Colors.red,
                          ))
                    ],
                  ),
                  const Text('Volume '),
                  Slider(
                    value: volume,
                    onChanged: (value) {
                      setState(() {
                        volume = value;
                      });
                    },
                  ),
                  const Text('Pitch '),
                  Slider(
                    value: pitch,
                    onChanged: (value) {
                      setState(() {
                        pitch = value;
                      });
                    },
                  ),
                  const Text('Speach Rate '),
                  Slider(
                    value: speachRate,
                    onChanged: (value) {
                      setState(() {
                        speachRate = value;
                      });
                    },
                  ),
                  ElevatedButton(
                      onPressed: () {
                        save(textEditingController.text);
                      },
                      child: const Text("save audio")),
                  const SizedBox(
                    height: 20,
                  ),
                  _isLoading
                      ? const CircularProgressIndicator()
                      : _musicFiles.isEmpty
                          ? const Text('No MP3 files found')
                          : ListView.builder(
                              shrinkWrap: true,
                              primary: false,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _musicFiles.length,
                              itemBuilder: (context, index) {
                                String filePath = _musicFiles[index].path;
                                String fileName = filePath.split('/').last;
                                return ListTile(
                                  title: Text(fileName),
                                  onTap: () {
                                    playAudio(filePath);
                                  },
                                );
                              },
                            ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    textEditingController.dispose();
  }
}
