package com.attendence.api_server.Class;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface Class_Repository extends JpaRepository<Class,Long> {
    @Query("SELECT c FROM Class c WHERE LOWER(c.class_name) LIKE LOWER(CONCAT('%', :class_name, '%'))")
    List<Class> findByClass_nameContainingIgnoreCase(@Param("class_name") String class_name);
}
