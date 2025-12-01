import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseStorageService {
  final _supabase = Supabase.instance.client;

  Future<List<String>> uploadImageAndGetPaths(
    List<File> files,
    String userId,
  ) async {
    List<String> paths = [];

    for (File file in files) {
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';
      final String path = 'images/$userId/$fileName';

      try {
        await _supabase.storage.from('journal-images').upload(path, file);

        paths.add(path);
      } catch (e) {
        print('Error uploading or creating signed URL for $path: $e');
      }
    }

    return paths;
  }

  Future<List<String>> getSignedUrlsFromPaths(List<dynamic> paths) async {
    final storage = _supabase.storage.from('journal-images');
    List<String> signedUrls = [];

    for (var path in paths) {
      try {
        final signedUrl = await storage.createSignedUrl(path, 3600);
        signedUrls.add(signedUrl);
      } catch (e) {
        print('Error creating signed URL for $path: $e');
      }
    }

    return signedUrls;
  }

  Future<void> deleteImages(List<String> paths) async {
    if (paths.isEmpty) return;
    final storage = _supabase.storage.from('journal-images');
    try {
      await storage.remove(paths);
    } catch (e) {
      print('Error deleting images $paths: $e');
    }
  }
}
