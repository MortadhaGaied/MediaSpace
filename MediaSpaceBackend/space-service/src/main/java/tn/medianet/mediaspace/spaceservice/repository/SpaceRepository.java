package tn.medianet.mediaspace.spaceservice.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import tn.medianet.mediaspace.spaceservice.entity.Space;

@Repository
public interface SpaceRepository extends JpaRepository<Space,Long> {
}
