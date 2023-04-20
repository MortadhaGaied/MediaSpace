package tn.medianet.mediaspace.reservationservice.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import tn.medianet.mediaspace.reservationservice.entity.Reservation;
import tn.medianet.mediaspace.reservationservice.exceptions.ResourceNotFoundException;
import tn.medianet.mediaspace.reservationservice.repository.ReservationRepository;
import tn.medianet.mediaReservation.reservationservice.service.ReservationService;
import java.util.List;

@Service
@RequiredArgsConstructor
public class ReservationServiceImpl implements ReservationService {
    private final ReservationRepository reservationRepository;



    @Override
    public Reservation addReservation(Reservation reservation) {
        return reservationRepository.save(reservation);
    }

    @Override
    public Reservation updateReservation(Reservation reservation) {
        return reservationRepository.save(reservation);
    }

    @Override
    public void deleteReservation(Long id) {
        reservationRepository.deleteById(id);
    }

    @Override
    public Reservation retrieveReservation(Long id) {
        return reservationRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Reservation not found with id: " + id));
    }

    @Override
    public List<Reservation> retrieveAllReservation() {
        return reservationRepository.findAll();
    }
}
