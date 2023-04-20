package tn.medianet.mediaspace.searchspaceservice.repository;

import org.springframework.data.elasticsearch.repository.ElasticsearchRepository;
import org.springframework.stereotype.Repository;
import tn.medianet.mediaspace.searchspaceservice.document.SpaceIndex;

@Repository
public interface SpaceIndexRepository extends ElasticsearchRepository<SpaceIndex, Long> {
}
