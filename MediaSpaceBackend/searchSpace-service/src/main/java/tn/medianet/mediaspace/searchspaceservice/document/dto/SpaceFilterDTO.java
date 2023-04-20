package tn.medianet.mediaspace.searchspaceservice.document.dto;

import lombok.Getter;
import lombok.Setter;

import java.util.List;
@Getter
@Setter
public class SpaceFilterDTO {
    private Double minPrice;
    private Double maxPrice;
    private Integer maxGuests;
    private Integer roomNumbers;
    private Integer floorNumber;


}
