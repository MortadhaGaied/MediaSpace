package tn.medianet.mediaspace.mediainteractionservice.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import tn.medianet.mediaspace.mediainteractionservice.entity.Video;
@Repository
public interface VideoRepository extends JpaRepository<Video,Long> {
}
