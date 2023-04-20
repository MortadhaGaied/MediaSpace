package tn.medianet.mediaspace.searchspaceservice.service;


import lombok.RequiredArgsConstructor;
import org.elasticsearch.client.RestHighLevelClient;
import org.elasticsearch.index.query.BoolQueryBuilder;
import org.elasticsearch.index.query.QueryBuilders;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.elasticsearch.core.ElasticsearchOperations;
import org.springframework.data.elasticsearch.core.SearchHit;
import org.springframework.data.elasticsearch.core.SearchHits;
import org.springframework.data.elasticsearch.core.query.Query;
import org.springframework.stereotype.Service;
import tn.medianet.mediaspace.searchspaceservice.document.SpaceIndex;

import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;
import org.elasticsearch.action.search.SearchRequest;
import org.elasticsearch.action.search.SearchResponse;
import org.elasticsearch.client.RequestOptions;
import org.elasticsearch.search.builder.SearchSourceBuilder;
import tn.medianet.mediaspace.searchspaceservice.repository.SpaceIndexRepository;

@Service
@RequiredArgsConstructor
public class SpaceIndexServiceImpl implements SpaceIndexService {


    private final SpaceIndexRepository spaceIndexRepository;


/*
    public SearchResponse searchSpaces(double minPrice, double maxPrice, int minRooms, int maxRooms, int minBathrooms, int maxBathrooms) throws IOException, IOException {
        BoolQueryBuilder boolQuery = QueryBuilders.boolQuery()
                .filter(QueryBuilders.rangeQuery("price").gte(minPrice).lte(maxPrice))
                .filter(QueryBuilders.rangeQuery("roomNumber").gte(minRooms).lte(maxRooms))
                .filter(QueryBuilders.rangeQuery("bathroomN umber").gte(minBathrooms).lte(maxBathrooms));

        SearchSourceBuilder searchSourceBuilder = new SearchSourceBuilder();
        searchSourceBuilder.query(boolQuery);

        SearchRequest searchRequest = new SearchRequest("spaces");
        searchRequest.source(searchSourceBuilder);

        SearchResponse searchResponse = elasticsearchClient.search(searchRequest, RequestOptions.DEFAULT);



        return searchResponse;
    }*/
@Autowired
private RestHighLevelClient client;

    public SearchResponse filterSpaces(Double minPrice, Double maxPrice, Integer maxGuests, Integer roomNumbers, Integer floorNumber) throws IOException {
        SearchRequest searchRequest = new SearchRequest("spaces");
        SearchSourceBuilder searchSourceBuilder = new SearchSourceBuilder();

        BoolQueryBuilder boolQuery = QueryBuilders.boolQuery();

        if (minPrice != null && maxPrice != null) {
            boolQuery.filter(QueryBuilders.rangeQuery("price").gte(minPrice).lte(maxPrice));
        }
/*
        if (maxGuests != null) {
            boolQuery.filter(QueryBuilders.termQuery("maxGuest", maxGuests));
        }

        if (roomNumbers != null) {
            boolQuery.filter(QueryBuilders.termQuery("roomNumbers", roomNumbers));
        }

        if (floorNumber != null) {
            boolQuery.filter(QueryBuilders.termQuery("floorNumber", floorNumber));
        }

        /*if (amenities != null && !amenities.isEmpty()) {
            for (String amenity : amenities) {
                boolQuery.filter(QueryBuilders.termQuery("amenities.keyword", amenity));
            }
        }*/

        searchSourceBuilder.query(boolQuery);
        searchRequest.source(searchSourceBuilder);

        return client.search(searchRequest, RequestOptions.DEFAULT);
    }
        public void save(SpaceIndex spaceIndex){
        spaceIndexRepository.save(spaceIndex);
    }
    public SpaceIndex findById(Long id){
        return spaceIndexRepository.findById(id).orElse(null);
    }
}
