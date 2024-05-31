package com.attendence.api_server.Member_Class;

import com.attendence.api_server.Class.Class;
import com.attendence.api_server.member.Member;
import com.fasterxml.jackson.annotation.*;
import jakarta.persistence.*;
import lombok.*;

@Table
@Entity(name = "Member_Class")
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Getter
@Setter
@JsonIdentityInfo(generator=ObjectIdGenerators.PropertyGenerator.class, property="id")
public class Member_Class {
    @EmbeddedId
    private Member_Class_key id;

//    @JsonIdentityInfo(
//            generator = ObjectIdGenerators.PropertyGenerator.class,
//            property = "id"
//    )
//    @JsonIdentityReference(alwaysAsId = true)
//    @JsonProperty("member_id")
    @ManyToOne
    @MapsId("member_id")
    @JoinColumn(name = "member_id")
//    @JsonBackReference
    private Member member;


//    @JsonIdentityInfo(
//            generator = ObjectIdGenerators.PropertyGenerator.class,
//            property = "id"
//    )
//    @JsonIdentityReference(alwaysAsId = true)
//    @JsonProperty("class_id")
    @ManyToOne
    @MapsId("class_id")
    @JoinColumn(name = "class_id")
//    @JsonBackReference(value = "class_memberclass")
    private Class aClass;

    private Boolean present;
    private Double attendance_percents;
    @Column(columnDefinition = "TEXT")
    private String attendance_log;
//    public String getId() {
//        return "member id: "+member.getId() + " _ " + "class id: "+aClass.getId();
//    }


}
