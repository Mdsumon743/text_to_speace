import 'package:flutter/material.dart';
import 'package:text_to_speace/homepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Text to Speace',
      theme: ThemeData(),
      debugShowCheckedModeBanner: false,
      home: const Homepage(),
    );
  }
}

// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:just_audio/just_audio.dart';

// void main() => runApp(const MyApp());

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       home: MusicPlayerScreen(),
//     );
//   }
// }

// class MusicPlayerScreen extends StatefulWidget {
//   const MusicPlayerScreen({super.key});

//   @override
//   // ignore: library_private_types_in_public_api
//   _MusicPlayerScreenState createState() => _MusicPlayerScreenState();
// }

// class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
//   List<FileSystemEntity> _musicFiles = [];
//   final AudioPlayer _audioPlayer = AudioPlayer();
//   bool _isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     _checkPermissions();
//   }

//   Future<void> _checkPermissions() async {
//     PermissionStatus status = await Permission.manageExternalStorage.request();
//     if (status.isGranted) {
//       _loadMusicFiles();
//     } else {
//       print('Permission Denied');
//     }
//   }

//   Future<void> _loadMusicFiles() async {
//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       // For Android 10 and above, use external storage path
//       final musicDir = Directory(
//           '/storage/emulated/0/Music'); // Update with your correct path

//       // Check if the directory exists
//       if (await musicDir.exists()) {
//         // Fetch all MP3 files in the directory
//         final List<FileSystemEntity> files = musicDir.listSync();
//         setState(() {
//           _musicFiles =
//               files.where((file) => file.path.endsWith('.mp3')).toList();
//         });
//       } else {
//         print('Directory does not exist');
//       }
//     } catch (e) {
//       print('Error: $e');
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   Future<void> _playAudio(String filePath) async {
//     try {
//       await _audioPlayer.setUrl(filePath);
//       _audioPlayer.play();
//     } catch (e) {
//       print('Error playing audio: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Music Player'),
//       ),
//       body: Center(
//         child: _isLoading
//             ? const CircularProgressIndicator()
//             : _musicFiles.isEmpty
//                 ? const Text('No MP3 files found')
//                 : ListView.builder(
//                     itemCount: _musicFiles.length,
//                     itemBuilder: (context, index) {
//                       String filePath = _musicFiles[index].path;
//                       String fileName = filePath.split('/').last;
//                       return ListTile(
//                         title: Text(fileName),
//                         onTap: () {
//                           _playAudio(filePath);
//                         },
//                       );
//                     },
//                   ),
//       ),
//     );
//   }
// }
