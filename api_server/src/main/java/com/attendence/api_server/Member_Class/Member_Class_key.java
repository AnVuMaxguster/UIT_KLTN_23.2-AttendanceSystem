package com.attendence.api_server.Member_Class;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.util.Objects;

@Embeddable
public class Member_Class_key implements Serializable {
    @Column(name = "member_id")
    Long member_id;
    @Column(name = "class_id")
    Long class_id;

    public Member_Class_key() {
    }

    public Member_Class_key(Long member_id, Long class_id) {
        this.member_id = member_id;
        this.class_id = class_id;
    }

    public Long getMember_id() {
        return member_id;
    }

    public void setMember_id(Long member_id) {
        this.member_id = member_id;
    }

    public Long getClass_id() {
        return class_id;
    }

    public void setClass_id(Long class_id) {
        this.class_id = class_id;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Member_Class_key that = (Member_Class_key) o;
        return Objects.equals(member_id, that.member_id) && Objects.equals(class_id, that.class_id);
    }

    @Override
    public int hashCode() {
        return Objects.hash(member_id, class_id);
    }
}
