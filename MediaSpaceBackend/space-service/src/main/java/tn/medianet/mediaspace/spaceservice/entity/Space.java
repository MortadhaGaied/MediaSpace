package tn.medianet.mediaspace.spaceservice.entity;


import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDateTime;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Entity
public class Space {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String name;

    @OneToOne(cascade = CascadeType.ALL)
    private Address address;

    @Column(nullable = false)
    private String description;

    @Column(nullable = false)
    private double price;
    private int maxGuest;
    private int roomNumber;
    private int bathroomNumber;
    private int floorNumber;
    private int restrictedMinAge;
    private int restrictedMaxAge;
    private SpaceType spaceType;
    @Column(length = 5000)
    private String spaceRule;
    @ElementCollection
    private List<String> amenities;
    @ManyToMany(cascade = CascadeType.ALL)
    private List<SpaceEquipement> equipments;
    @ElementCollection
    private List<String> accessibility;
    @ElementCollection
    private List<String> images;
    @Column(nullable = false)
    private double squareFootage;
    @ElementCollection
    private List<SpaceAvailability> availabilities;

    @Column(name = "user_id", nullable = false)
    private Long ownerId;

    @CreationTimestamp
    @Column(nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(nullable = false)
    private LocalDateTime updatedAt;


}


