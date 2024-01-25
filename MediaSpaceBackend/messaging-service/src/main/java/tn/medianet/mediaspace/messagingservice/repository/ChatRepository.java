package tn.medianet.mediaspace.messagingservice.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import tn.medianet.mediaspace.messagingservice.entity.Chat;

import java.util.List;

@Repository
public interface ChatRepository extends JpaRepository<Chat, Long> {
    List<Chat> findAllByParticipantId1OrParticipantId2(Long participantId1, Long participantId2);

}
