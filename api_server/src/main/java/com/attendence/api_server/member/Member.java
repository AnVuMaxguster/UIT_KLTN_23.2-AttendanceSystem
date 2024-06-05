package com.attendence.api_server.member;

import com.attendence.api_server.Member_Class.Member_Class;
import com.fasterxml.jackson.annotation.*;
import jakarta.persistence.*;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

@Entity(name = "Member")
@Table
//@JsonIdentityInfo(generator=ObjectIdGenerators.PropertyGenerator.class, property="id")
public class Member implements UserDetails {

    @Id
    @SequenceGenerator(
            name="user_sq",
            sequenceName ="user_sq",
            allocationSize = 1
    )
    @GeneratedValue(
            strategy = GenerationType.SEQUENCE,
            generator = "user_sq"
    )
    private long id;
    @Column(nullable = false)
    private String Display_name;
    @Column(columnDefinition = "TEXT")
    private String Description;
    @Column(
            name = "username",
            unique = true,
            nullable = false
    )
    private String username;
    @Column(
            nullable = false
    )
    @JsonIgnore
    private String password;
    @Column(
            nullable = false,
            unique = true
    )
    private String email;

    @JsonIgnore
    private String resetPassCode;

    private String bleMac;

    private Date bleUpdateTime;

    @Enumerated(EnumType.STRING)
    private Role role;

//    @JsonIdentityInfo(
//            generator = ObjectIdGenerators.PropertyGenerator.class,
//            property = "id"
//    )
//    @JsonIdentityReference(alwaysAsId = true)
    @OneToMany(mappedBy = "member")
//    @JsonManagedReference
    private Set<Member_Class> classes;

    public Member() {
    }

    public Member(String display_name, String username, String password, String email, Role role) {
        Display_name = display_name;
        this.username = username;
        this.password = password;
        this.email = email;
        this.role = role;
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getDisplay_name() {
        return Display_name;
    }

    public void setDisplay_name(String display_name) {
        Display_name = display_name;
    }

    public String getDescription() {
        return Description;
    }

    public void setDescription(String description) {
        Description = description;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getResetPassCode() {
        return resetPassCode;
    }

    public void setResetPassCode(String resetPassCode) {
        this.resetPassCode = resetPassCode;
    }

    public Role getRole() {
        return role;
    }

    public void setRole(Role role) {
        this.role = role;
    }

    public Set<Member_Class> getClasses() {
        return classes;
    }

    public void setClasses(Set<Member_Class> classes) {
        this.classes = classes;
    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {

        return List.of(new SimpleGrantedAuthority(role.name()));
    }

    @Override
    public String getPassword() {
        return this.password;
    }

    @Override
    public String getUsername() {
        return this.username;
    }

    @Override
    public boolean isAccountNonExpired() {
        return true;
    }

    @Override
    public boolean isAccountNonLocked() {
        return true;
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return true;
    }

    @Override
    public boolean isEnabled() {
        return true;
    }

    public static boolean hasAdminPrivileges(Member requester)
    {
        return requester!=null && requester.getRole() != null && requester.getRole() == Role.ADMIN;
    }

    public static boolean hasLecturePrivileges(Member requester)
    {
        return requester!=null && requester.getRole() != null && (requester.getRole() == Role.ADMIN||requester.getRole()==Role.LECTURE);
    }

    public String getBleMac() {
        return bleMac;
    }

    public void setBleMac(String bleMac) {
        this.bleMac = bleMac;
        this.bleUpdateTime=new Date();
    }

    public Date getBleUpdateTime() {
        return bleUpdateTime;
    }

    public void setBleUpdateTime(String bleUpdateTime) throws ParseException {
        SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
        dateFormat.setTimeZone(TimeZone.getTimeZone("GMT+7"));
        Date date = dateFormat.parse(bleUpdateTime);
        this.bleUpdateTime=date;
    }
}
