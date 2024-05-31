package com.attendence.api_server.Asset;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface Asset_Repository extends JpaRepository<Asset,Long> {
    Optional<Asset>findByName(String name);
}
