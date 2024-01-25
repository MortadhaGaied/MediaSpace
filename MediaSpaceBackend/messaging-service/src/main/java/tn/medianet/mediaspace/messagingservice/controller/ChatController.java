package tn.medianet.mediaspace.messagingservice.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import tn.medianet.mediaspace.messagingservice.entity.Chat;
import tn.medianet.mediaspace.messagingservice.entity.Message;
import tn.medianet.mediaspace.messagingservice.repository.ChatRepository;
import tn.medianet.mediaspace.messagingservice.repository.MessageRepository;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/chat")
public class ChatController {

    @Autowired
    private ChatRepository chatRepository;

    @Autowired
    private MessageRepository messageRepository;

    // Create a new chat
    @PostMapping("/create")
    public Chat createChat(@RequestBody Chat chat) {
        chat.setCreatedAt(System.currentTimeMillis());
        return chatRepository.save(chat);
    }

    // Send a message
    @PostMapping("/message/send")
    public Message sendMessage(@RequestBody Message message) {
        message.setTimestamp(System.currentTimeMillis());
        return messageRepository.save(message);
    }


    // Fetch all chats for a given participant
    @GetMapping("/allChats/{participantId}")
    public List<Chat> getAllChatsForParticipant(@PathVariable Long participantId) {
        return chatRepository.findAllByParticipantId1OrParticipantId2(participantId, participantId);
    }
    @GetMapping("/last/{chatId}")
    public ResponseEntity<Message> getLastMessage(@PathVariable Long chatId) {
        Optional<Message> lastMessage = messageRepository.findLastMessageByChatId(chatId);
        return lastMessage.map(ResponseEntity::ok).orElseGet(() -> ResponseEntity.notFound().build());
    }
    @GetMapping("/chat/{chatId}")
    public List<Message> getAllMessagesByChatId(@PathVariable Long chatId) {
        return messageRepository.findAllByChatIdOrderByTimestampAsc(chatId);
    }

}
