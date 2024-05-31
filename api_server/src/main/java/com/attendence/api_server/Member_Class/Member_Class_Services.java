package com.attendence.api_server.Member_Class;

import com.attendence.api_server.Class.Class;
import com.attendence.api_server.Class.Class_Repository;
import com.attendence.api_server.PutRequest;
import com.attendence.api_server.member.Member;
import com.attendence.api_server.member.Member_repository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.lang.reflect.Method;
import java.util.List;

@Service
@RequiredArgsConstructor
public class Member_Class_Services {
    private final Member_repository memberRepository;
    private final Class_Repository classRepository;
    private final Member_Class_repository memberClassRepository;
    @Transactional
    public String addMember_To_Class_ById(long member_id, long class_id, Member requester)
    {
        if(!Member.hasAdminPrivileges(requester))
        {
            throw new IllegalStateException("Unauthorized for this services");
        }
        Member member=memberRepository.findById(member_id)
                .orElseThrow(()-> new IllegalStateException("Member with id "+ member_id +" does not Exist."));
        Class aClass=classRepository.findById(class_id)
                .orElseThrow(()-> new IllegalStateException("Class with id "+class_id+" does not Exist."));

        Member_Class memberClass=new Member_Class();
        Member_Class_key memberClassKey=new Member_Class_key();
        memberClassKey.setClass_id(aClass.getId());
        memberClassKey.setMember_id(member.getId());
        memberClass.setId(memberClassKey);
        memberClass.setMember(member);
        memberClass.setAClass(aClass);
        memberClass.setPresent(false);
        memberClass.setAttendance_percents(0.0);
        member.getClasses().add(memberClass);
        aClass.getMembers().add(memberClass);
        memberClassRepository.save(memberClass);
        return "Successfully added "+member.getUsername()+" to clas id "+aClass.getId()+".";
    }
    @Transactional
    public Member_Class updateByID(long member_id, long class_id, PutRequest putRequest,Member requester) throws Exception {
        if (!Member.hasAdminPrivileges(requester)) {
            throw new IllegalStateException("Unauthorized for this service.");
        }
        String property = putRequest.getProperty();
        Member_Class_key id = new Member_Class_key(member_id, class_id);
        Member_Class memberClass = memberClassRepository.findById(id).
                orElseThrow(() -> new IllegalStateException("Member and Class combination with id " + id + " does not exist."));
        if (putRequest.getValue() != null) {
            java.lang.Class valueClass = putRequest.getValue().getClass();
            Method setter = memberClass.getClass().getMethod(property, valueClass);
            setter.invoke(memberClass, putRequest.getValue());
        }
        return memberClass;
    }
    @Transactional
    public String deleteById(long member_id,long class_id,Member requester)
    {
        if(!Member.hasAdminPrivileges(requester))
        {
            throw new IllegalStateException("Unauthorized for this service");
        }
        Member_Class_key memberClassKey=new Member_Class_key(member_id,class_id);
        Member_Class memberClass=memberClassRepository.findById(memberClassKey)
                .orElseThrow(() -> new IllegalStateException("Member and Class combination with id " + member_id + " does not exist."));
        memberClass.getMember().getClasses().remove(memberClass);
        memberClass.getAClass().getMembers().remove(memberClass);
        memberClassRepository.delete(memberClass);
        return "Member id "+member_id+" has been deleted from class id "+class_id+".";
    }
}
