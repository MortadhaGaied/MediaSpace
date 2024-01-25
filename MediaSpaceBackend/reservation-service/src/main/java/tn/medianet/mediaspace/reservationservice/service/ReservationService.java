package tn.medianet.mediaReservation.reservationservice.service;

import tn.medianet.mediaspace.reservationservice.entity.Reservation;
import tn.medianet.mediaspace.reservationservice.entity.ReservationEquipment;

import java.util.List;

public interface ReservationService {
    Reservation addReservation(Reservation reservation);

    Reservation updateReservation(Reservation reservation);

    void deleteReservation(Long id);

    Reservation retrieveReservation(Long id);

    List<Reservation> retrieveAllReservation();

    List<Reservation> retrieveReservationByUser(Long idUser);

    ReservationEquipment retrieveReservationEquipmentById(Integer id);
}
