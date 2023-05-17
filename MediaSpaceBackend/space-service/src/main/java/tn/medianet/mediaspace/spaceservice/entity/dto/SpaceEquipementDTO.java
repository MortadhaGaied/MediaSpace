package tn.medianet.mediaspace.spaceservice.entity.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class SpaceEquipementDTO {
    private Long id;
    private String name;
    private String image;
    private int quantity;
    private double price;
    private String description;
}
