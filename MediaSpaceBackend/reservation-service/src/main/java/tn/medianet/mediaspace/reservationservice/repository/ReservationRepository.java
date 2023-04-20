package tn.medianet.mediaspace.reservationservice.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import tn.medianet.mediaspace.reservationservice.entity.Reservation;
@Repository
public interface ReservationRepository extends JpaRepository<Reservation,Long> {
}
