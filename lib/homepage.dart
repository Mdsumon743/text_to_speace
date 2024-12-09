import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final FlutterTts flutterTts = FlutterTts();
  final TextEditingController textEditingController = TextEditingController();
  Map<String, String> languageMap = {
    'en-US': 'English',
  };
  @override
  void initState() {
    super.initState();
    initTts();
  }

  List<String> languages = [];
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
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
                    child: const Text("save audio"))
              ],
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
