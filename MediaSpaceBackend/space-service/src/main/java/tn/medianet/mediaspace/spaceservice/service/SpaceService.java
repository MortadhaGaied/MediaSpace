package tn.medianet.mediaspace.spaceservice.service;

import tn.medianet.mediaspace.spaceservice.entity.Space;
import tn.medianet.mediaspace.spaceservice.entity.SpaceEquipement;

import java.util.List;

public interface SpaceService {
    Space addSpace(Space space);
    Space updateSpace(Space space);
    void deleteSpace(Long id);
    Space retrieveSpace(Long id);
    List<Space> retrieveAllSpace();
    void addEquipmentAndAssignedToSpace(Long spaceId, SpaceEquipement spaceEquipement);

}