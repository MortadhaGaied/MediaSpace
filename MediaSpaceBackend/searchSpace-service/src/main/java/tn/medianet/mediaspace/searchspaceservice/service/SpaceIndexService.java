package tn.medianet.mediaspace.searchspaceservice.service;

import org.elasticsearch.action.search.SearchResponse;
import tn.medianet.mediaspace.searchspaceservice.document.SpaceIndex;

import java.io.IOException;
import java.util.List;

public interface SpaceIndexService {
    //SearchResponse searchSpaces(double minPrice, double maxPrice, int minRooms, int maxRooms, int minBathrooms, int maxBathrooms) throws IOException ;
    public SearchResponse filterSpaces(Double minPrice, Double maxPrice, Integer maxGuests, Integer roomNumbers, Integer floorNumber) throws IOException ;
    void save(SpaceIndex spaceIndex);
    SpaceIndex findById(Long id);
}
