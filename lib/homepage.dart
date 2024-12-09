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

  List<String> languages = [];
  String? selectedLanguage;
  double pitch = 1.0;
  double speachRate = 1.0;
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

  @override
  void initState() {
    super.initState();
    initTts();
  }

  @override
  void dispose() {
    super.dispose();
    textEditingController.dispose();
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
  Future<void>stop()async{
    flutterTts.stop();
  }
   Future<void>puase()async{
    flutterTts.pause();
  }



  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
