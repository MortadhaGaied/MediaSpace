package tn.medianet.mediaspace.messagingservice.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class Message {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private Long chatId;
    private Long senderId;
    private Long recipientId;
    private String content;
    private long timestamp;
    @Column(name = "is_read")
    private boolean read;
}

