package tn.medianet.mediaspace.searchspaceservice.document;

import lombok.Getter;
import lombok.Setter;
import org.springframework.data.annotation.Id;
import org.springframework.data.elasticsearch.annotations.*;


import org.springframework.data.annotation.Id;
import org.springframework.data.elasticsearch.annotations.Document;
import org.springframework.data.elasticsearch.annotations.Field;
import org.springframework.data.elasticsearch.annotations.FieldType;

import java.util.List;

@Document(indexName = "spaces")
@Setting(settingPath = "static/es-settings.json")
@Getter
@Setter
public class SpaceIndex {

    @Id
    private Long id;

    @Field(type = FieldType.Text)
    private String name;
    @Field(type=FieldType.Text)
    private String address;
    @Field(type = FieldType.Double)
    private double price;

    @Field(type = FieldType.Integer)
    private int maxGuest;

    @Field(type = FieldType.Keyword)
    private SpaceType spaceType;

    @Field(type = FieldType.Keyword)
    private List<String> amenities;

    @Field(type = FieldType.Double)
    private double squareFootage;
    @Field(type=FieldType.Integer)
    private int roomNumber;
    @Field(type=FieldType.Integer)
    private int bathroomNumber;
    @Field(type=FieldType.Integer)
    private int floorNumber;

    // Constructors, getters and setters

}
