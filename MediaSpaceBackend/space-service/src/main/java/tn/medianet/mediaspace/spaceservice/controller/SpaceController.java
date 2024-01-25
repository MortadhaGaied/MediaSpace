package tn.medianet.mediaspace.spaceservice.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import tn.medianet.mediaspace.spaceservice.entity.Space;
import tn.medianet.mediaspace.spaceservice.entity.SpaceEquipement;
import tn.medianet.mediaspace.spaceservice.entity.dto.SpaceDTO;
import tn.medianet.mediaspace.spaceservice.entity.dto.SpaceEquipementDTO;
import tn.medianet.mediaspace.spaceservice.entity.mapper.SpaceEquipementMapper;
import tn.medianet.mediaspace.spaceservice.entity.mapper.SpaceMapper;
import tn.medianet.mediaspace.spaceservice.service.SpaceService;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/space")
public class SpaceController {

    private final SpaceService spaceService;

    @Autowired
    public SpaceController(SpaceService spaceService) {

        this.spaceService = spaceService;
    }

    @PostMapping
    public ResponseEntity<SpaceDTO> addSpace(@RequestBody SpaceDTO spaceDto) {
        Space space = SpaceMapper.toEntity(spaceDto);
        Space createdSpace = spaceService.addSpace(space);
        SpaceDTO createdSpaceDto = SpaceMapper.toDto(createdSpace);
        return new ResponseEntity<>(createdSpaceDto, HttpStatus.CREATED);
    }

    @PutMapping("/{id}")
    public ResponseEntity<SpaceDTO> updateSpace(@PathVariable Long id, @RequestBody SpaceDTO spaceDto) {
        spaceDto.setId(id);
        Space space = SpaceMapper.toEntity(spaceDto);
        Space updatedSpace = spaceService.updateSpace(space);
        SpaceDTO updatedSpaceDto = SpaceMapper.toDto(updatedSpace);
        return new ResponseEntity<>(updatedSpaceDto, HttpStatus.OK);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteSpace(@PathVariable Long id) {
        spaceService.deleteSpace(id);
        return new ResponseEntity<>(HttpStatus.NO_CONTENT);
    }

    @GetMapping("/{id}")
    public ResponseEntity<SpaceDTO> retrieveSpace(@PathVariable Long id) {
        Space retrievedSpace = spaceService.retrieveSpace(id);
        SpaceDTO retrievedSpaceDto = SpaceMapper.toDto(retrievedSpace);
        return new ResponseEntity<>(retrievedSpaceDto, HttpStatus.OK);
    }

    @GetMapping
    public ResponseEntity<List<SpaceDTO>> retrieveAllSpace() {
        List<Space> spaces = spaceService.retrieveAllSpace();
        List<SpaceDTO> spaceDtos = spaces.stream()
                .map(SpaceMapper::toDto)
                .collect(Collectors.toList());
        return new ResponseEntity<>(spaceDtos, HttpStatus.OK);
    }

    @PostMapping("/{spaceId}/equipment")
    public ResponseEntity<Void> addEquipmentAndAssignedToSpace(@PathVariable Long spaceId, @RequestBody SpaceEquipementDTO spaceEquipementDto) {
        SpaceEquipement spaceEquipement = SpaceEquipementMapper.toEntity(spaceEquipementDto);
        spaceService.addEquipmentAndAssignedToSpace(spaceId, spaceEquipement);
        return new ResponseEntity<>(HttpStatus.CREATED);
    }

}

