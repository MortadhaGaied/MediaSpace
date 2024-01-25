

import 'package:MediaSpaceFrontend/services/backend/auth-service.dart';
import 'package:flutter/material.dart';

import '../../services/backend/mediaInteraction-service.dart';
import '../../services/models/comment.dart';
class CommentScreen extends StatefulWidget {
  final int id;

  CommentScreen({Key? key, required this.id}) : super(key: key);

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {


  final TextEditingController _commentController = TextEditingController();
  final MediaInteractionService mediaService = MediaInteractionService();
  final AuthenticationService authenticationService = AuthenticationService();
  List<dynamic> commentList = [];
  List<Comment> comments = [];

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  Future<void> _loadComments() async {
    commentList = await mediaService.getCommentsForVideo(widget.id);
    for (var data in commentList) {
      var user = await authenticationService.getUserById(data['userId']);
      Comment comment = Comment(
          id: data['id'],
          profilePhoto: "${user['profile_picture']}",
          username: "${user['firstname']} ${user['lastname']}",

          comment: data['comment'],
          datePublished: data['createdAt'],
          likes: data['likeCount']
      );
      comments.add(comment);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: comments.isEmpty
                  ? CircularProgressIndicator()
                  : ListView.builder(
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  final comment = comments[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.black,
                      backgroundImage: NetworkImage(comment.profilePhoto),
                    ),
                    title: Row(
                      children: [
                        Text(
                          '${comment.username}   ',
                          style: const TextStyle(
                              fontSize: 20,
                              color: Colors.red,
                              fontWeight: FontWeight.w700),
                        ),
                        Text(
                          comment.comment,
                          style: const TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    subtitle: Row(
                      children: [
                        Text(
                          // TODO: Ensure you have the appropriate formatter here
                          comment.datePublished.toString(),
                          style: TextStyle(
                              fontSize: 12, color: Colors.white),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          '${comment.likes} likes',
                          style: const TextStyle(
                              fontSize: 12, color: Colors.white),
                        ),
                      ],
                    ),
                    trailing: InkWell(
                      onTap: () => {},
                      child: Icon(
                        Icons.favorite,
                        size: 25,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
            ),
            Column(
              children: [
                const Divider(),
                ListTile(
                  title: TextFormField(
                    controller: _commentController,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Comment',
                      labelStyle: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w700),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red)),
                    ),
                  ),
                  trailing: TextButton(
                    onPressed: () =>
                        {},
                    child: const Text(
                      'Send',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}