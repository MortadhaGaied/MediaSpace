package tn.medianet.mediaspace.spaceservice.entity.mapper;


import tn.medianet.mediaspace.spaceservice.entity.SpaceEquipement;
import tn.medianet.mediaspace.spaceservice.entity.dto.SpaceEquipementDTO;

import java.util.List;
import java.util.stream.Collectors;

public class SpaceEquipementMapper {

    public static SpaceEquipement toEntity(SpaceEquipementDTO spaceEquipementDto) {
        if (spaceEquipementDto == null) {
            return null;
        }

        SpaceEquipement spaceEquipement = new SpaceEquipement();
        spaceEquipement.setId(spaceEquipementDto.getId());
        spaceEquipement.setName(spaceEquipementDto.getName());
        spaceEquipement.setImage(spaceEquipementDto.getImage());
        spaceEquipement.setQuantity(spaceEquipementDto.getQuantity());
        spaceEquipement.setPrice(spaceEquipementDto.getPrice());
        spaceEquipement.setDescription(spaceEquipementDto.getDescription());
        return spaceEquipement;
    }

    public static SpaceEquipementDTO toDto(SpaceEquipement spaceEquipement) {
        if (spaceEquipement == null) {
            return null;
        }

        SpaceEquipementDTO spaceEquipementDto = new SpaceEquipementDTO();
        spaceEquipementDto.setId(spaceEquipement.getId());
        spaceEquipementDto.setName(spaceEquipement.getName());
        spaceEquipementDto.setImage(spaceEquipement.getImage());
        spaceEquipementDto.setQuantity(spaceEquipement.getQuantity());
        spaceEquipementDto.setPrice(spaceEquipement.getPrice());
        spaceEquipementDto.setDescription(spaceEquipement.getDescription());

        return spaceEquipementDto;
    }

    public static List<SpaceEquipement> toEntityList(List<SpaceEquipementDTO> spaceEquipementDtos) {
        if (spaceEquipementDtos == null) {
            return null;
        }

        return spaceEquipementDtos.stream()
                .map(SpaceEquipementMapper::toEntity)
                .collect(Collectors.toList());
    }

    public static List<SpaceEquipementDTO> toDtoList(List<SpaceEquipement> spaceEquipements) {
        if (spaceEquipements == null) {
            return null;
        }

        return spaceEquipements.stream()
                .map(SpaceEquipementMapper::toDto)
                .collect(Collectors.toList());
    }
}

