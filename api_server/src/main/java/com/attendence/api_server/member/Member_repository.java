package com.attendence.api_server.member;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface Member_repository extends JpaRepository<Member,Long> {
    Optional<Member> findByUsername(String username);
    Optional<Member> findById(long id);

    Optional<Member> findByEmail(String email);

    List<Member>findByUsernameContainingIgnoreCase(String search);

    List<Member>findByRole(Role role);
}
