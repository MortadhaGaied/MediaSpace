package tn.medianet.mediaReservation.reservationservice.service;

import tn.medianet.mediaspace.reservationservice.entity.Reservation;

import java.util.List;

public interface ReservationService {
    Reservation addReservation(Reservation reservation);
    Reservation updateReservation(Reservation reservation);
    void deleteReservation(Long id);
    Reservation retrieveReservation(Long id);
    List<Reservation> retrieveAllReservation();
}
