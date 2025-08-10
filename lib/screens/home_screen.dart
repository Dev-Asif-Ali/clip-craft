import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../services/ffmpeg_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? selectedVideo;
  String? outputVideo;
  bool isProcessing = false;

  final ffmpegService = FFmpegService();

  Future<void> pickVideo() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.video);
    if (result != null) {
      setState(() => selectedVideo = result.files.single.path);
    }
  }

  Future<void> trimSelectedVideo() async {
    if (selectedVideo == null) return;

    setState(() => isProcessing = true);

    final dir = await getApplicationDocumentsDirectory();
    outputVideo = '${dir.path}/trimmed_video.mp4';

    await ffmpegService.trimVideo(selectedVideo!, outputVideo!, '00:00:05', '00:00:10');

    setState(() => isProcessing = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Video trimmed! Saved at $outputVideo")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Video Editor")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: pickVideo,
              child: const Text("Pick Video"),
            ),
            if (selectedVideo != null) ...[
              Text("Selected: $selectedVideo"),
              ElevatedButton(
                onPressed: trimSelectedVideo,
                child: isProcessing ? const CircularProgressIndicator() : const Text("Trim Video"),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
