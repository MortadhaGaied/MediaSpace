package tn.medianet.mediaspace.reservationservice.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Getter
@Setter
@Entity
@Table(name = "reservations")
public class Reservation {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    private double totalPrice;

    private int idSpace;

    private int idUser;

    @Enumerated(EnumType.STRING)
    private EventType eventType;

    private int nbParticipant;

    private LocalDate date;

    private LocalDateTime startTime;

    private LocalDateTime endTime;
    @Enumerated(EnumType.STRING)
    private ReservationStatus reservationStatus;

    @OneToMany(mappedBy = "reservation", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<ReservationEquipment> reservationEquipments;
}

enum EventType {
    MEETING,
    PARTY,
    PRODUCTION,
    OTHER
}
