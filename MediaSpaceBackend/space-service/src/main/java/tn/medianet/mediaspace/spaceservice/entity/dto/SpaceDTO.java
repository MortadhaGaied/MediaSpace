package tn.medianet.mediaspace.spaceservice.entity.dto;


import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import tn.medianet.mediaspace.spaceservice.entity.Address;
import tn.medianet.mediaspace.spaceservice.entity.SpaceAvailability;
import tn.medianet.mediaspace.spaceservice.entity.SpaceEventPrice;
import tn.medianet.mediaspace.spaceservice.entity.SpaceType;

import java.time.LocalDateTime;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class SpaceDTO {
    private Long id;
    private String name;
    private Address address;
    private String description;
    private List<SpaceEventPrice> eventPrices;
    private int maxGuest;
    private int roomNumber;
    private int bathroomNumber;
    private int floorNumber;
    private int restrictedMinAge;
    private int restrictedMaxAge;
    private SpaceType spaceType;
    private String spaceRule;
    private List<String> amenities;
    private List<SpaceEquipementDTO> equipments;
    private List<String> accessibility;
    private List<String> images;
    private double squareFootage;
    private List<SpaceAvailability> availabilities;
    private Long ownerId;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}