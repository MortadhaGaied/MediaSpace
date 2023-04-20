package tn.medianet.mediaspace.searchspaceservice.controller;

import org.elasticsearch.action.search.SearchResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import tn.medianet.mediaspace.searchspaceservice.document.SpaceIndex;
import tn.medianet.mediaspace.searchspaceservice.document.dto.SpaceFilterDTO;
import tn.medianet.mediaspace.searchspaceservice.service.SpaceIndexService;

import java.io.IOException;
import java.util.List;

@RestController
@RequestMapping("/api/spaces")
public class SpaceSearchController {

    @Autowired
    private SpaceIndexService spaceSearchService;
//note that my all my space is stored in my sql database because i m using microservice so i think to get all the spaces the i can filter them how can i do this
    /*@GetMapping("/search")
    public SearchResponse searchSpaces(@RequestParam(required = false) Double minPrice,
                                       @RequestParam(required = false) Double maxPrice,
                                       @RequestParam(required = false) Integer minRoomNumber,
                                       @RequestParam(required = false) Integer maxRoomNumber,
                                       @RequestParam(required = false) Integer minBathroomNumber,
                                       @RequestParam(required = false) Integer maxBathroomNumber) throws IOException {
        return spaceSearchService.searchSpaces(minPrice, maxPrice, minRoomNumber, maxRoomNumber,minBathroomNumber,maxBathroomNumber);
    }*/
@GetMapping("/filter")
public ResponseEntity<SearchResponse> filterSpaces(@RequestBody SpaceFilterDTO spaceFilterDTO) {
    try {
        SearchResponse filteredSpaces = spaceSearchService.filterSpaces(
                spaceFilterDTO.getMinPrice(),
                spaceFilterDTO.getMaxPrice(),
                spaceFilterDTO.getMaxGuests(),
                spaceFilterDTO.getRoomNumbers(),
                spaceFilterDTO.getFloorNumber()
        );
        return new ResponseEntity<>(filteredSpaces, HttpStatus.OK);
    } catch (IOException e) {
        e.printStackTrace();
        return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
    }
}
    @PostMapping
    public void save(@RequestBody SpaceIndex spaceIndex) {
        spaceSearchService.save(spaceIndex);
    }

    @GetMapping("/{id}")
    public SpaceIndex findById(@PathVariable Long id) {
        return spaceSearchService.findById(id);
    }
}

