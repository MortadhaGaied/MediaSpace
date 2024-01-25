package tn.medianet.mediaspace.reservationservice.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import tn.medianet.mediaspace.reservationservice.entity.Reservation;
import tn.medianet.mediaspace.reservationservice.entity.ReservationEquipment;
import tn.medianet.mediaspace.reservationservice.exceptions.ResourceNotFoundException;
import tn.medianet.mediaspace.reservationservice.repository.ReservationEquipmentRepository;
import tn.medianet.mediaspace.reservationservice.repository.ReservationRepository;
import tn.medianet.mediaReservation.reservationservice.service.ReservationService;
import java.util.List;

@Service
@RequiredArgsConstructor
public class ReservationServiceImpl implements ReservationService {
    private final ReservationRepository reservationRepository;
    private final ReservationEquipmentRepository reservationEquipmentRepository;


    @Override
    public Reservation addReservation(Reservation reservation) {
        for (ReservationEquipment equipment : reservation.getReservationEquipments()) {
            equipment.setReservation(reservation);
        }
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

    @Override
    public List<Reservation> retrieveReservationByUser(Long idUser) {
        return reservationRepository.findAllByIdUser(idUser);
    }
    @Override
    public ReservationEquipment retrieveReservationEquipmentById(Integer id){
        return reservationEquipmentRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("ReservationEquipment not found with id: " + id));

    }
}
