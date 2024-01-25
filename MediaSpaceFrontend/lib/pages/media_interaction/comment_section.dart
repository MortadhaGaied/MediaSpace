import 'package:flutter/material.dart';

import '../../services/backend/auth-service.dart';
import '../../services/backend/mediaInteraction-service.dart';
import '../../services/models/comment.dart';
import 'package:intl/intl.dart';
class CommentSection extends StatefulWidget {
  final int id;

  CommentSection({required this.id});

  @override
  _CommentSectionState createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  final MediaInteractionService mediaService = MediaInteractionService();
  final AuthenticationService authenticationService = AuthenticationService();
  List<Comment> comments = [];
  String newComment = '';
  TextEditingController commentController = TextEditingController();
  FocusNode _commentFocusNode = FocusNode();
  bool _isIconClicked = false;
  Map<int, ValueNotifier<int>> likesCountNotifiers = {};
  Map<int, ValueNotifier<bool>> likeStatusNotifiers = {};

  @override
  void initState() {
    super.initState();
    _loadComments().then((_) {
      comments.forEach((comment) {
        likesCountNotifiers[comment.id] = ValueNotifier<int>(comment.likes);
      });
    });
  }

  String timeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) return 'Now';
    if (difference.inMinutes < 60) return '${difference.inMinutes} min';
    if (difference.inHours < 24) return '${difference.inHours} hr';
    if (difference.inDays < 30) return '${difference.inDays} days';

    return DateFormat('yMMMd').format(dateTime);
  }
  Future<void> _loadComments() async {
    var commentList = await mediaService.getCommentsForVideo(widget.id);

    Map<String, dynamic> currentUser = await authenticationService.getCurrentUser();
    int userId = currentUser['id'];

    for (var data in commentList) {
      var user = await authenticationService.getUserById(data['userId']);

      Comment comment = Comment(
        id: data['id'],
        profilePhoto: "${user['profile_picture']}",
        username: "${user['firstname']} ${user['lastname']}",
        comment: data['text'],
        datePublished: DateTime.parse(data['createdAt']),
        likes: data['likeCount'],
      );

      bool isLiked = await mediaService.isCommentLiked(comment.id, userId);
      likeStatusNotifiers[comment.id] = ValueNotifier<bool>(isLiked);

      comments.add(comment);
    }
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          height: MediaQuery.of(context).size.height * 0.6,
          child: Padding(
            padding: const EdgeInsets.all(16.0), // <-- You can adjust the value as needed
            child: Column(
              children: [
                Row(
                  children: [
                    Spacer(),
                    Text(
                      'Comments',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                Expanded(
                  child: comments.isNotEmpty
                      ? ListView.builder(
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      Comment com = comments[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FutureBuilder<String>(
                              future: authenticationService.getUrlFile(com.profilePhoto),
                              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return Center(child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return Text('Image loading error: ${snapshot.error}');
                                } else {
                                  print(snapshot.data!);
                                  return CircleAvatar(
                                    backgroundImage: NetworkImage(snapshot.data!),
                                  );
                                }
                              },
                            ),

                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(com.username),
                                  Text(com.comment ?? "Default Comment"),
                                  Row(
                                    children: [
                                      Text(timeAgo(com.datePublished)),
                                      Spacer(),
                                      ValueListenableBuilder<bool>(
                                        valueListenable: likeStatusNotifiers[com.id]!,
                                        builder: (BuildContext context, bool isLiked, Widget? child) {
                                          
                                          return GestureDetector(
                                            onTap: () async {
                                              Map<String, dynamic> currentUser = await authenticationService.getCurrentUser();
                                              int userId = currentUser['id'];

                                              bool isCurrentlyLiked = likeStatusNotifiers[com.id]!.value;

                                              if (isCurrentlyLiked) {
                                                // Uncomment the below line if you have a method in mediaService to unlike a comment.
                                                // await mediaService.unlikeComment(com.id, userId);

                                                likesCountNotifiers[com.id]!.value -= 1;
                                                likeStatusNotifiers[com.id]!.value = false;
                                              } else {
                                                // Uncomment the below line if you have a method in mediaService to like a comment.
                                                // await mediaService.likeComment(com.id, userId);

                                                likesCountNotifiers[com.id]!.value += 1;
                                                likeStatusNotifiers[com.id]!.value = true;
                                              }
                                            },
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                Icon(Icons.favorite, size: 22, color: Colors.black),
                                                Icon(
                                                    Icons.favorite,
                                                    size: 18,
                                                    color: isLiked ? Colors.yellow : Colors.white
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                      ValueListenableBuilder<int>(
                                        valueListenable: likesCountNotifiers[com.id]!,
                                        builder: (BuildContext context, int likesCount, Widget? child) {
                                          return Text(likesCount.toString());
                                        },
                                      )

                                    ],
                                  ),
                                ],
                              ),
                            )





                          ],
                        ),
                      );
                    },
                  )
                      : Center(
                    child: Text(
                      "Be the first to comment on this video!",
                      style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          focusNode: _commentFocusNode, // Assign the focus node here
                          controller: commentController,
                          decoration: InputDecoration(hintText: 'Add a comment...'),
                          onChanged: (text) {
                            setState(() {
                              newComment = text;
                            });
                          },
                        ),
                      ),
                      if (newComment.isNotEmpty)
                        IconButton(
                          icon: Icon(Icons.send),
                          onPressed: () async {
                            try {
                              // Get the current user's ID
                              Map<String, dynamic> currentUser = await authenticationService.getCurrentUser();
                              int userId = currentUser['id'];

                              // Create the comment map
                              Map<String, dynamic> comment = {
                                'userId': userId,
                                'videoId': widget.id,
                                'text': newComment,
                              };

                              // Post the comment
                              await mediaService.addComment(comment);

                              // Clear the comment input and reload the comments list
                              commentController.clear();
                              await _loadComments();

                            } catch (e) {
                              print("Error while posting comment: $e");
                              // Optionally, show a user-friendly error message to the user.
                              // e.g. using a SnackBar, AlertDialog, etc.
                            }
                          },
                        ),

                    ],
                  ),
                ),
              ],
            ),
          )
          )

        );

  }
  @override
  void dispose() {
    _commentFocusNode.dispose();
    likesCountNotifiers.forEach((_, notifier) => notifier.dispose());
    likeStatusNotifiers.forEach((_, notifier) => notifier.dispose());

    super.dispose();
  }
}
