package tn.medianet.mediaspace.messagingservice.controller;



import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.web.bind.annotation.*;
import tn.medianet.mediaspace.messagingservice.entity.Chat;
import tn.medianet.mediaspace.messagingservice.entity.Message;
import tn.medianet.mediaspace.messagingservice.service.FirebaseService;

import java.util.List;

@RestController
@RequestMapping("/messaging")
public class MessagingController {

    private final FirebaseService firebaseService;

    @Autowired
    public MessagingController(FirebaseService firebaseService) {
        this.firebaseService = firebaseService;
    }

    @MessageMapping("/sendMessage")
    @SendTo("/topic/public")
    public Message sendMessage(Message message) {
        firebaseService.saveMessage(message);
        return message;
    }

    @GetMapping("/{chatId}")
    public List<Message> getChatMessages(@PathVariable String chatId) {
        return firebaseService.getMessagesForChat(chatId);
    }



    @DeleteMapping("/message/{messageId}")
    public void deleteMessage(@PathVariable String messageId) {
        firebaseService.deleteMessage(messageId);
    }

    @GetMapping("/message/{messageId}")
    public Message getMessage(@PathVariable String messageId) {
        return firebaseService.getMessage(messageId);
    }

    @GetMapping("/{chatId}/unread-messages")
    public List<Message> getUnreadMessages(@PathVariable String chatId) {
        return firebaseService.getUnreadMessages(chatId);
    }
    @GetMapping("/chats/{participantId}")
    public List<Chat> getChatsForParticipant(@PathVariable Long participantId) {
        return firebaseService.getChatsForParticipant(participantId);
    }

}
