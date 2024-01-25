package tn.medianet.mediaspace.messagingservice.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import tn.medianet.mediaspace.messagingservice.entity.Message;

import java.util.List;
import java.util.Optional;

@Repository
public interface MessageRepository extends JpaRepository<Message, Long> {
    @Query(value = "SELECT * FROM Message WHERE chat_id = ?1 ORDER BY timestamp DESC LIMIT 1", nativeQuery = true)
    Optional<Message> findLastMessageByChatId(Long chatId);

    @Query("SELECT m FROM Message m WHERE m.chatId = ?1 ORDER BY m.timestamp DESC")
    List<Message> findAllByChatIdOrderByTimestampAsc(Long chatId);
}
