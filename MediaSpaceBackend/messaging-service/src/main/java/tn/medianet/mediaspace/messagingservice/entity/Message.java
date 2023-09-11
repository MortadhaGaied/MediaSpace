package tn.medianet.mediaspace.messagingservice.entity;

import lombok.*;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class Message {

    private Long id;
    private Long chatId;
    private Long senderId;
    private Long recipientId;
    private String content;
    private long timestamp;
    private boolean read;

}
