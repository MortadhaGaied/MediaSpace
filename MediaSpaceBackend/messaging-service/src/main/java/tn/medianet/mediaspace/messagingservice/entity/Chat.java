package tn.medianet.mediaspace.messagingservice.entity;

import lombok.*;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class Chat {
    private Long id;
    private Long participantId1;
    private Long participantId2;
    private long createdAt;
}
