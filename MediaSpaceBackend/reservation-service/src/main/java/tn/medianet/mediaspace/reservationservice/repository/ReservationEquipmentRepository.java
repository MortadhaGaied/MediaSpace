package tn.medianet.mediaspace.reservationservice.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import tn.medianet.mediaspace.reservationservice.entity.ReservationEquipment;

@Repository
public interface ReservationEquipmentRepository extends JpaRepository<ReservationEquipment, Integer> {

}
