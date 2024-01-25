package tn.medianet.mediaspace.mediainteractionservice.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import tn.medianet.mediaspace.mediainteractionservice.entity.Like;
import tn.medianet.mediaspace.mediainteractionservice.entity.LikeType;

import java.util.Optional;

@Repository
public interface LikeRepository extends JpaRepository<Like,Long> {
    Optional<Like> findByUserIdAndTargetIdAndTargetType(Long userId, Long targetId, LikeType targetType);

}
