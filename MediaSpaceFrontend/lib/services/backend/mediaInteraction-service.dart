import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

class MediaInteractionService {
  final String baseUrl = "http://192.168.192.1:8085/mediainteraction";

  Future<void> addVideo(int spaceId, File videoFile) async {
    final request = http.MultipartRequest('POST', Uri.parse('$baseUrl/video/$spaceId'));
    request.files.add(http.MultipartFile(
      'file',
      videoFile.readAsBytes().asStream(),
      videoFile.lengthSync(),
      filename: videoFile.path.split("/").last,
    )
    );

    final response = await request.send();

    if (response.statusCode == 201) {
      print("Video uploaded successfully.");
    } else {
      print("Failed to upload video.");
    }
  }

  Future<void> addComment(Map<String, dynamic> comment) async {
    final response = await http.post(
      Uri.parse('$baseUrl/comment'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(comment),
    );

    if (response.statusCode == 201) {
      print("Comment added successfully.");
    } else {
      print("Failed to add comment.");
    }
  }
  Future<List<dynamic>> getCommentsForVideo(int videoId) async {
    final response = await http.get(Uri.parse('$baseUrl/video/$videoId/comments'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print("Failed to fetch comments.");
      return [];
    }
  }

  Future<void> likeVideo(int videoId, int userId) async {
    final response = await http.post(Uri.parse('$baseUrl/video/$videoId/like'), body: {'userId': '$userId'});

    if (response.statusCode == 200) {
      print("Liked video successfully.");
    } else {
      print("Failed to like video.");
    }
  }

  Future<void> likeComment(int commentId, int userId) async {
    final response = await http.post(Uri.parse('$baseUrl/comment/$commentId/like'), body: {'userId': '$userId'});

    if (response.statusCode == 200) {
      print("Liked comment successfully.");
    } else {
      print("Failed to like comment.");
    }
  }
  Future<List<dynamic>> getAllVideos() async {
    final response = await http.get(Uri.parse('$baseUrl/videos'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print("Failed to fetch videos.");
      return [];
    }
  }

  Future<void> deleteComment(int commentId) async {
    final response = await http.delete(Uri.parse('$baseUrl/comment/$commentId'));

    if (response.statusCode == 204) {
      print("Comment deleted successfully.");
    } else {
      print("Failed to delete comment.");
    }
  }
  Future<bool> isCommentLiked(int commentId, int userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/isLiked?idComment=$commentId&idUser=$userId'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as bool;
    } else {
      throw Exception("Failed to check if comment is liked.");
    }
  }

  Future<String?> getVideoUrl(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/videoUrl/$id'));

    if (response.statusCode == 200) {
      return response.body;
    } else if (response.statusCode == 404) {
      print('Video not found');
      return null;
    } else {
      print('Failed to get video URL');
      return null;
    }
  }



}
