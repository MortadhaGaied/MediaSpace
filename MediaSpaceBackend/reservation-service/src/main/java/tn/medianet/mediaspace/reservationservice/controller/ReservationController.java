package tn.medianet.mediaspace.reservationservice.controller;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import tn.medianet.mediaspace.reservationservice.entity.Reservation;
import tn.medianet.mediaspace.reservationservice.entity.ReservationEquipment;
import tn.medianet.mediaspace.reservationservice.service.ReservationServiceImpl;

import java.util.List;

@RestController
@RequestMapping("/reservation")
public class ReservationController {

    private final ReservationServiceImpl reservationService;

    public ReservationController(ReservationServiceImpl reservationService) {
        this.reservationService = reservationService;
    }

    @PostMapping
    public ResponseEntity<Reservation> createReservation(@RequestBody Reservation reservation) {
        Reservation newReservation = reservationService.addReservation(reservation);
        return new ResponseEntity<>(newReservation, HttpStatus.CREATED);
    }

    @GetMapping("/{id}")
    public ResponseEntity<Reservation> getReservationById(@PathVariable Long id) {
        Reservation reservation = reservationService.retrieveReservation(id);
        return ResponseEntity.ok(reservation);
    }
    @GetMapping("/equipment/{id}")
    public ResponseEntity<ReservationEquipment> getReservationEquipmentById(@PathVariable Integer id) {
        ReservationEquipment reservationEquipment= reservationService.retrieveReservationEquipmentById(id);
        return ResponseEntity.ok(reservationEquipment);
    }

    @GetMapping
    public ResponseEntity<List<Reservation>> getAllReservations() {
        List<Reservation> reservations = reservationService.retrieveAllReservation();
        return ResponseEntity.ok(reservations);
    }
    @GetMapping("/byuser/{id}")
    public ResponseEntity<List<Reservation>> getAllReservationsByUser(@PathVariable Long id) {
        List<Reservation> reservations = reservationService.retrieveReservationByUser(id);
        return ResponseEntity.ok(reservations);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Reservation> updateReservation(@PathVariable Long id, @RequestBody Reservation reservationDetails) {
        Reservation currentReservation = reservationService.retrieveReservation(id);
        currentReservation.setEventType(reservationDetails.getEventType());
        currentReservation.setDate(reservationDetails.getDate());
        currentReservation.setEndTime(reservationDetails.getEndTime());
        currentReservation.setIdSpace(reservationDetails.getIdSpace());
        currentReservation.setIdUser(reservationDetails.getIdUser());
        currentReservation.setNbParticipant(reservationDetails.getNbParticipant());
        currentReservation.setStartTime(reservationDetails.getStartTime());
        currentReservation.setTotalPrice(reservationDetails.getTotalPrice());
        // set other fields you want to update

        Reservation updatedReservation = reservationService.updateReservation(currentReservation);
        return ResponseEntity.ok(updatedReservation);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteReservation(@PathVariable Long id) {
        reservationService.deleteReservation(id);
        return ResponseEntity.noContent().build();
    }
}

