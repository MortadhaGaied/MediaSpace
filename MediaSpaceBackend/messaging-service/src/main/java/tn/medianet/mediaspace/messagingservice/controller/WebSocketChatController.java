package tn.medianet.mediaspace.messagingservice.controller;


import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import tn.medianet.mediaspace.messagingservice.entity.Message;
import tn.medianet.mediaspace.messagingservice.repository.MessageRepository;



@Controller
@Slf4j
public class WebSocketChatController {

    @Autowired
    private SimpMessagingTemplate template;

    @Autowired
    private MessageRepository messageRepository;
    @MessageMapping("/send")
    public void sendMessage(@Payload Message message) {
        log.info("Received message: {}", message);

        // Save the message to the database
        Message savedMessage = messageRepository.save(message);
        log.info("Saved message: {}", savedMessage);

        // Broadcast the message to all connected clients
        template.convertAndSend("/topic/messages", savedMessage);
        log.info("Broadcasted message: {}", savedMessage);
    }
}

