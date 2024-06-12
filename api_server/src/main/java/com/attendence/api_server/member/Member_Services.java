package com.attendence.api_server.member;

import com.attendence.api_server.Authentication.RegisterRequest;
import com.attendence.api_server.Class.Class;
import com.attendence.api_server.Member_Class.Member_Class;
import com.attendence.api_server.Member_Class.Member_Class_repository;
import com.attendence.api_server.PutRequest;
import jakarta.transaction.Transactional;
import org.springframework.stereotype.Service;

import java.lang.reflect.Method;
import java.security.Permission;
import java.time.Instant;
import java.util.*;

@Service
public class Member_Services {
    private final Member_repository memberRepository;
    private final Member_Class_repository memberClassRepository;

    public Member_Services(Member_repository memberRepository, Member_Class_repository memberClassRepository) {
        this.memberRepository = memberRepository;
        this.memberClassRepository=memberClassRepository;
    }


    public void addMember(Member newMember)
    {
        memberRepository.save(newMember);
    }

    public Member getMemberById(long id)
    {
        return memberRepository.findById(id)
                .orElseThrow(
                        ()->new IllegalStateException("Member with id "+id+" does not exist!")
                );
    }
    public Optional<Member> getMemberByUsername(String username)
    {
        return memberRepository.findByUsername(username);
    }
    public List<Member>findByUsername(String search,Member requester)
    {
        if(!Member.hasLecturePrivileges(requester))
        {
            throw new IllegalStateException("Unauthorized for this service");
        }
        return memberRepository.findByUsernameContainingIgnoreCase(search);
    }
    @Transactional
    public Member  updateById(PutRequest putRequest, Member requester) throws Exception
    {
        if(!Member.hasAdminPrivileges(requester) && requester.getId()!=putRequest.getItemId())
        {
            throw new IllegalStateException("Unauthorized for this service");
        }
        Member member=memberRepository.findById(putRequest.getItemId())
                .orElseThrow(()->new IllegalStateException("Member with id "+putRequest.getItemId()+" does not exist."));
        String property=putRequest.getProperty();
        if(putRequest.getValue()!=null && put_Exceptions(member,putRequest,requester)) {
            java.lang.Class valueClass = putRequest.getValue().getClass();
            Method setter = member.getClass().getMethod(property, valueClass);
            setter.invoke(member, putRequest.getValue());
        }
        return member;
    }
    private boolean put_Exceptions(Member target,PutRequest putRequest,Member requester)
    {
        boolean flag=true;
        switch (putRequest.getProperty())
        {
            case "setBleMac":
                Optional<Date> targetUpdateBle_time= Optional.ofNullable(target.getBleUpdateTime());
                if( targetUpdateBle_time.isPresent())
                {
                    long current_time=new Date().getTime();
                    long convertTargetUpdateBle_time=targetUpdateBle_time.get().getTime();
                    if((current_time-convertTargetUpdateBle_time)/3600000<=1440) {
                        if (!Member.hasAdminPrivileges(requester)) {
                            flag = false;
                            throw new IllegalStateException(1440 - (current_time-convertTargetUpdateBle_time)/3600000 + " hours until BleMac can be changed");
                        }
                    }
                }
                break;
            case "setBleUpdateTime":
                if(!Member.hasAdminPrivileges(requester)) {
                    flag = false;
                    throw new IllegalStateException("Unauthorized for this service");

                }

                break;
        }
        return flag;
    }
    public List<Member> getAllStudent(Member requester)
    {
        if(!Member.hasLecturePrivileges(requester))
            throw new IllegalStateException("Unauthorized for this service");
        return memberRepository.findByRole(Role.STUDENT);
    }
    public List<Member> getAllMember(Member requester)
    {
        if(!Member.hasLecturePrivileges(requester))
            throw new IllegalStateException("Unauthorized for this service");
        return  memberRepository.findAll();
    }
    public List<Map<String,Object>> getAllClasses(Member requester, Member target)
    {
        if(!Member.hasLecturePrivileges(requester) && requester.getId()!= target.getId())
            throw new IllegalStateException("Unauthorized for this service");
//        List<Class> targetClasses=new ArrayList<>();
//        List<Boolean> targetFollowingAttendanceList=new ArrayList<>();
        List<Map<String,Object>> targetFullList=new ArrayList<>();
        for(Member_Class memberClass : target.getClasses())
        {
//            targetClasses.add(memberClass.getAClass());
            Map<String,Object> newItem=new HashMap<>();
            newItem.put("class",memberClass.getAClass());
            newItem.put("is_present",memberClass.getPresent());
            newItem.put("attendance_percents",memberClass.getAttendance_percents());
            targetFullList.add(newItem);
        }
        return targetFullList;
    }
    public List<Map<String,Object>> FinishedClasses(Member requester,Member target)
    {
        Date now=Date.from(Instant.now());
        List<Map<String,Object>> allClassesItem=getAllClasses(requester,target);
        List<Map<String,Object>> finishedClasses=new ArrayList<>();
        for(Map<String,Object> aclassItem : allClassesItem)
        {
            Class aclass=(Class) aclassItem.get("class");
            if (now.after(aclass.getEnd_time()))
            {
                finishedClasses.add(aclassItem);
            }
        }
        return finishedClasses;
    }
    public List<Class> UnfinishedClasses(Member requester,Member target)
    {
        Date now=Date.from(Instant.now());
        List<Map<String,Object>> allClassesItem=getAllClasses(requester,target);
        List<Class> unfinishedClasses=new ArrayList<>();
        for(Map<String,Object> aclassItem : allClassesItem)
        {
            Class aclass=(Class) aclassItem.get("class");
            if (now.before(aclass.getEnd_time()))
            {
                unfinishedClasses.add(aclass);
            }
        }
        return unfinishedClasses;
    }

    @Transactional
    public String deleteMemberById(long id,Member requester)
    {
        if(!Member.hasAdminPrivileges(requester))
        {
            throw new IllegalStateException("Unauthorized for this service");
        }
        Member member=getMemberById(id);
        Set<Member_Class> memberClasses=member.getClasses();
        for(Member_Class memberClass : memberClasses)
        {
            memberClass.getAClass().getMembers().remove(memberClass);
            memberClass.setMember(null);
            memberClass.setAClass(null);
            memberClassRepository.delete(memberClass);
        }
        member.getClasses().clear();
        memberRepository.deleteById(id);
        return "Member id "+id+" deleted.";
    }
}
