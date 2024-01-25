
import 'package:flutter/material.dart';

import '../chat_details_page.dart';

class ChatUsersList extends StatefulWidget{
  String fullname;
  String secondaryText;
  String image;
  String time;
  bool isMessageRead;
  int chatId;
  int otherParticipantId;
  ChatUsersList({
    required this.fullname,
    required this.secondaryText,
    required this.image,
    required this.time,
    required this.isMessageRead,
    required this.chatId,  // Add this
    required this.otherParticipantId,  // Add this
  });  @override
  _ChatUsersListState createState() => _ChatUsersListState();
}

class _ChatUsersListState extends State<ChatUsersList> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context){
          return ChatDetailPage(
            chatId: widget.chatId,  // Pass the chatId
            otherParticipantId: widget.otherParticipantId,  // Pass the otherParticipantId
          );
        }));
      },
      child: Container(
        padding: EdgeInsets.only(left: 16,right: 16,top: 10,bottom: 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: NetworkImage(widget.image),
                    maxRadius: 30,
                  ),
                  SizedBox(width: 16,),
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(widget.fullname),
                          SizedBox(height: 6,),
                          Text(widget.secondaryText,style: TextStyle(fontSize: 14,color: Colors.grey.shade500),),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(widget.time,style: TextStyle(fontSize: 12,color: widget.isMessageRead?Colors.pink:Colors.grey.shade500),),
          ],
        ),
      ),
    );
  }
}