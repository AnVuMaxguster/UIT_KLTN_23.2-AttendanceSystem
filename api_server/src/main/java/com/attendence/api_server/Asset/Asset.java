package com.attendence.api_server.Asset;

import com.attendence.api_server.Class.Class;
import com.fasterxml.jackson.annotation.JsonBackReference;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Table
@Entity(name = "Asset")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Asset {
    @Id
    @SequenceGenerator(
            name="asset_sq",
            sequenceName ="asset_sq",
            allocationSize = 1
    )
    @GeneratedValue(
            strategy = GenerationType.SEQUENCE,
            generator = "asset_sq"
    )
    private long id;
    @Column(columnDefinition = "TEXT",unique = true)
    private String name;
    @Column(columnDefinition = "TEXT")
    private String asset_local_path;
    @Column(columnDefinition = "TEXT")
    private String asset_link;
    @Column(columnDefinition = "TEXT")
    private String asset_type;
    @ManyToOne
    @JoinColumn(name = "class_id")
//    @JsonBackReference
    private Class aclass;
}
