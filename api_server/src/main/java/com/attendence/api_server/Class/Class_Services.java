package com.attendence.api_server.Class;

import com.attendence.api_server.Asset.Asset;
import com.attendence.api_server.Asset.Asset_Service;
import com.attendence.api_server.Member_Class.Member_Class;
import com.attendence.api_server.Member_Class.Member_Class_repository;
import com.attendence.api_server.MqttGateway;
import com.attendence.api_server.PutRequest;
import com.attendence.api_server.member.Member;
import com.google.gson.Gson;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.lang.reflect.Method;
import java.util.*;

@Service
@RequiredArgsConstructor
public class Class_Services {
    private final Class_Repository classRepository;
    private final Asset_Service assetService;
    private final Member_Class_repository memberClassRepository;
    private final MqttGateway mqttGateway;

    public Class addClass(Class newClass, Member requester)
    {
        if(!Member.hasAdminPrivileges(requester))
        {
            throw new IllegalStateException("Unauthorized for this service");
        }
        newClass.setVideo_footage_list(new ArrayList<>());
        Class dbResult = classRepository.save(newClass);
        sendObjectMqtt(dbResult,"/mqtt/class/post");
        return dbResult;
    }
    public void sendObjectMqtt(Object obj, String topic)
    {
        try {
            Gson gson = new Gson();
            String data = gson.toJson(obj);
            mqttGateway.sendToMqtt(data, topic);
        }
        catch (Exception e)
        {

        }
    }
    @Transactional
    public String deleteClassById(long id,Member requester)
    {
        if(!Member.hasAdminPrivileges(requester))
        {
            throw new IllegalStateException("Unauthorized for this service");
        }
        Class aclass=getClassByID(id,requester);
        Set<Member_Class> memberClasses=aclass.getMembers();
        for(Member_Class memberClass : memberClasses)
        {
            memberClass.getMember().getClasses().remove(memberClass);
            memberClass.setMember(null);
            memberClass.setAClass(null);
            memberClassRepository.delete(memberClass);
        }
        aclass.getMembers().clear();
        classRepository.deleteById(id);
        try
        {
            mqttGateway.sendToMqtt(""+id,"/mqtt/class/del");
        }
        catch (Exception e)
        {

        }
        return "Class id "+id+" deleted.";
    }
    @Transactional
    public Class append_videoFootage(long classId, MultipartFile file,Member requester) throws IOException {
        Class aclass=classRepository.findById(classId)
                .orElseThrow(()->new IllegalStateException("Class with id "+classId+" does not exist."));
        Asset asset=assetService.uploadAsset(file,requester);
        asset.setAclass(aclass);
        aclass.getVideo_footage_list().add(asset);
        return aclass;
    }
    @Transactional
    public Class updateByID(PutRequest putRequest,Member requester) throws Exception
    {
        if(!Member.hasAdminPrivileges(requester))
        {
            throw new IllegalStateException("Unauthorized for this service.");
        }
        String property=putRequest.getProperty();
        long id=putRequest.getItemId();
        Class aclass=classRepository.findById(id).
                orElseThrow(()->new IllegalStateException("Class with id "+id+" does not exist."));
        if(putRequest.getValue()!=null) {
            java.lang.Class valueClass=putRequest.getValue().getClass();
            Method setter = aclass.getClass().getMethod(property, valueClass);
            setter.invoke(aclass, putRequest.getValue());
        }
//        sendObjectMqtt(aclass,"/mqtt/class/put");
        return aclass;
    }

    public List<Class> getAllClass(Member requester)
    {
        if(!Member.hasLecturePrivileges(requester))
        {
            throw new IllegalStateException("Unauthorized for this service.");
        }
        return classRepository.findAll();
    }
    public Map<String,Object> getMembersName(long class_id, Member requester)
    {
        Class selectClass=getClassByID(class_id,requester);
        Map<String,Object> result=new HashMap<>();
        for(Member_Class memberClass : selectClass.getMembers())
        {
            Map<String,Object> temp=new HashMap<>();
            Member member=memberClass.getMember();
            temp.put("id",member.getId());
            temp.put("bleMac",member.getBleMac());
            result.put(member.getUsername(),temp);
        }
        return result;
    }

    public Class getClassByID(long id,Member requester)
    {
        if(!Member.hasLecturePrivileges(requester))
        {
            throw new IllegalStateException("Unauthorized for this service");
        }
        return classRepository.findById(id)
                .orElseThrow(()->new IllegalStateException("Class with id "+id+" does not exist."));
    }
}
