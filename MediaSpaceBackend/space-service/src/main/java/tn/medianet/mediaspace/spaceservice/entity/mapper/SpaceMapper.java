package tn.medianet.mediaspace.spaceservice.entity.mapper;




import tn.medianet.mediaspace.spaceservice.entity.Space;
import tn.medianet.mediaspace.spaceservice.entity.dto.SpaceDTO;

public class SpaceMapper {

    public static Space toEntity(SpaceDTO spaceDto) {
        if (spaceDto == null) {
            return null;
        }

        Space space = new Space();
        space.setId(spaceDto.getId());
        space.setName(spaceDto.getName());
        space.setAddress(spaceDto.getAddress());
        space.setDescription(spaceDto.getDescription());
        space.setEventPrices(spaceDto.getEventPrices());
        space.setMaxGuest(spaceDto.getMaxGuest());
        space.setRoomNumber(spaceDto.getRoomNumber());
        space.setBathroomNumber(spaceDto.getBathroomNumber());
        space.setFloorNumber(spaceDto.getFloorNumber());
        space.setRestrictedMinAge(spaceDto.getRestrictedMinAge());
        space.setRestrictedMaxAge(spaceDto.getRestrictedMaxAge());
        space.setSpaceType(spaceDto.getSpaceType());
        space.setSpaceRule(spaceDto.getSpaceRule());
        space.setAmenities(spaceDto.getAmenities());
        space.setEquipments(SpaceEquipementMapper.toEntityList(spaceDto.getEquipments()));
        space.setAccessibility(spaceDto.getAccessibility());
        space.setImages(spaceDto.getImages());
        space.setSquareFootage(spaceDto.getSquareFootage());
        space.setAvailabilities(spaceDto.getAvailabilities());
        space.setOwnerId(spaceDto.getOwnerId());
        space.setCreatedAt(spaceDto.getCreatedAt());
        space.setUpdatedAt(spaceDto.getUpdatedAt());

        return space;
    }

    public static SpaceDTO toDto(Space space) {
        if (space == null) {
            return null;
        }

        SpaceDTO spaceDto = new SpaceDTO();
        spaceDto.setId(space.getId());
        spaceDto.setName(space.getName());
        spaceDto.setAddress(space.getAddress());
        spaceDto.setDescription(space.getDescription());
        spaceDto.setEventPrices(space.getEventPrices());
        spaceDto.setMaxGuest(space.getMaxGuest());
        spaceDto.setRoomNumber(space.getRoomNumber());
        spaceDto.setBathroomNumber(space.getBathroomNumber());
        spaceDto.setFloorNumber(space.getFloorNumber());
        spaceDto.setRestrictedMinAge(space.getRestrictedMinAge());
        spaceDto.setRestrictedMaxAge(space.getRestrictedMaxAge());
        spaceDto.setSpaceType(space.getSpaceType());
        spaceDto.setSpaceRule(space.getSpaceRule());
        spaceDto.setAmenities(space.getAmenities());
        spaceDto.setEquipments(SpaceEquipementMapper.toDtoList(space.getEquipments()));
        spaceDto.setAccessibility(space.getAccessibility());
        spaceDto.setImages(space.getImages());
        spaceDto.setSquareFootage(space.getSquareFootage());
        spaceDto.setAvailabilities(space.getAvailabilities());
        spaceDto.setOwnerId(space.getOwnerId());
        spaceDto.setCreatedAt(space.getCreatedAt());
        spaceDto.setUpdatedAt(space.getUpdatedAt());

        return spaceDto;
    }
}

