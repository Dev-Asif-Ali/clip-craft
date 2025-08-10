import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';

class FFmpegService {
  Future<void> trimVideo(String inputPath, String outputPath, String start, String end) async {
    String command = '-i "$inputPath" -ss $start -to $end -c copy "$outputPath"';
    await FFmpegKit.execute(command);
  }
}
