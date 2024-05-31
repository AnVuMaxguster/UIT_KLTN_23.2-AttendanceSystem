package com.attendence.api_server.Class;

import com.attendence.api_server.Asset.Asset;
import com.attendence.api_server.Member_Class.Member_Class;
import com.fasterxml.jackson.annotation.JsonIdentityInfo;
import com.fasterxml.jackson.annotation.JsonIdentityReference;
import com.fasterxml.jackson.annotation.JsonManagedReference;
import com.fasterxml.jackson.annotation.ObjectIdGenerators;
import jakarta.persistence.*;
import lombok.*;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Set;
import java.util.TimeZone;

@Table
@Entity(name = "Class")
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Getter
@Setter
//@JsonIdentityInfo(generator=ObjectIdGenerators.PropertyGenerator.class, property="id")
public class    Class {
    @Id
    @SequenceGenerator(
            name="class_sq",
            sequenceName ="class_sq",
            allocationSize = 1
    )
    @GeneratedValue(
            strategy = GenerationType.SEQUENCE,
            generator = "class_sq"
    )
    private long id;
    @Column(columnDefinition = "TEXT")
    private String subject;
    private Date start_time;
    private Date end_time;
    private String ble_log;
    private String class_name;
    @OneToMany(fetch = FetchType.LAZY,cascade = CascadeType.ALL, mappedBy = "aclass")
//    @JsonManagedReference
    private List<Asset> video_footage_list;
//    @JsonIdentityInfo(
//            generator = ObjectIdGenerators.PropertyGenerator.class,
//            property = "id"
//    )
//    @JsonIdentityReference(alwaysAsId = true)
    @OneToMany(mappedBy = "aClass")
//    @JsonManagedReference(value = "class_memberclass")
    private Set<Member_Class> members;

    public void setStart_time(String start_time) throws Exception {
        SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
        dateFormat.setTimeZone(TimeZone.getTimeZone("GMT+7"));
        Date date = dateFormat.parse(start_time);
        this.start_time=date;
    }

    public void setEnd_time(String end_time) throws  Exception{
        SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
        dateFormat.setTimeZone(TimeZone.getTimeZone("GMT+7"));
        Date date = dateFormat.parse(end_time);
        this.end_time=date;
    }
}
