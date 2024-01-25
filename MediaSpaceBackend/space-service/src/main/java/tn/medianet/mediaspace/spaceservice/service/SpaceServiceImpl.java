package tn.medianet.mediaspace.spaceservice.service;


import org.springframework.stereotype.Service;
import tn.medianet.mediaspace.spaceservice.entity.Space;
import tn.medianet.mediaspace.spaceservice.entity.SpaceEquipement;
import tn.medianet.mediaspace.spaceservice.entity.SpaceEventPrice;
import tn.medianet.mediaspace.spaceservice.exceptions.ResourceNotFoundException;
import tn.medianet.mediaspace.spaceservice.repository.SpaceEquipementRepository;
import tn.medianet.mediaspace.spaceservice.repository.SpaceRepository;

import java.util.List;

@Service
public class SpaceServiceImpl implements SpaceService {
    private final SpaceRepository spaceRepository;
    private final SpaceEquipementRepository equipmentRepository;

    public SpaceServiceImpl(SpaceRepository spaceRepository, SpaceEquipementRepository equipmentRepository) {
        this.spaceRepository = spaceRepository;
        this.equipmentRepository = equipmentRepository;
    }

    @Override
    public Space addSpace(Space space) {

        return spaceRepository.save(space);
    }

    @Override
    public Space updateSpace(Space space) {
        return spaceRepository.save(space);
    }

    @Override
    public void deleteSpace(Long id) {
        spaceRepository.deleteById(id);
    }

    @Override
    public Space retrieveSpace(Long id) {
        return spaceRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Space not found with id: " + id));
    }

    @Override
    public List<Space> retrieveAllSpace() {
        return spaceRepository.findAll();
    }

    @Override
    public void addEquipmentAndAssignedToSpace(Long spaceId, SpaceEquipement spaceEquipement) {
        Space space = retrieveSpace(spaceId);


        space.getEquipments().add(spaceEquipement);
        spaceRepository.save(space);
    }
}

