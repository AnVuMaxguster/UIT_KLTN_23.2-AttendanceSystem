package com.attendence.api_server;

import com.attendence.api_server.Asset.Asset_Service;
import com.attendence.api_server.Authentication.AuthenticationRequest;
import com.attendence.api_server.Authentication.Authentication_Services;
import com.attendence.api_server.Authentication.RegisterRequest;
import com.attendence.api_server.Class.Class;
import com.attendence.api_server.Class.Class_Services;
import com.attendence.api_server.Member_Class.Member_Class_Services;
import com.attendence.api_server.member.Member;
import com.attendence.api_server.member.Member_Services;
import lombok.RequiredArgsConstructor;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.Optional;

@RestController
@RequestMapping(path = ("/api"))
@RequiredArgsConstructor
public class Rest_controller {
    private final Member_Services memberServices;
    private final Authentication_Services authenticationServices;
    private final Asset_Service assetService;
    private final Class_Services classServices;
    private final Member_Class_Services memberClassServices;
    private final MqttGateway mqttGateway;
    @GetMapping(path = "/testing")
    public String testing()
    {
        try
        {
            mqttGateway.sendToMqtt("testing from api","testing");
        }
        catch (Exception e)
        {
            
        }
        return "Server is working";
    }

    //todo: Authenticate -------------------------------------------
    @PostMapping("/auth/register")
    public ResponseEntity<Object> register(
            @RequestBody RegisterRequest registerRequest,
            @RequestHeader(name = "secret",required = false) String secret
            )
    {
        try
        {
            return ResponseEntity.ok(authenticationServices.register(
                    registerRequest,
                    Optional.ofNullable(secret),
                    Optional.ofNullable(getCurrentSessionMember())
            ));
        }
        catch (Exception e)
        {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }
    @PostMapping(path = "/auth/authenticate")
    public ResponseEntity<Object> authenticate(
            @RequestBody AuthenticationRequest authenticationRequest
    )
    {
        try {
            return ResponseEntity.ok(authenticationServices.authenticate(authenticationRequest));
        }
        catch (Exception e)
        {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }
    //authenticate-----------------------------------------------------


    //todo:Asset------------------------------------
    @PostMapping(value = "/assets",consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<Object> UploadAsset(
            @RequestParam(name = "asset") MultipartFile file
            )
    {
        try{
            String link=assetService.uploadAsset(file,getCurrentSessionMember()).getAsset_link();
            return ResponseEntity.ok(link);
        }
        catch (Exception e)
        {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }
    @PostMapping(value = "/assets/class",consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<?> UploadAsset_to_class(
            @RequestParam(name = "asset") MultipartFile file,
            @RequestParam(name = "class_id") long id
    )
    {
        try{
            return ResponseEntity.ok(classServices.append_videoFootage(id,file,getCurrentSessionMember()));
        }
        catch (Exception e)
        {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }
    @DeleteMapping("/assets")
    public ResponseEntity<Object> DeleteAsset(
            @RequestParam(name = "name") String name
    )
    {
        try
        {
            assetService.deleteAsset_byName(name,getCurrentSessionMember());
            return ResponseEntity.ok("Deleted "+name);
        }
        catch (Exception e)
        {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    //Asset-----------------------------------------
    //todo:Class------------------------------------
    @PostMapping("/class")
    public ResponseEntity<?> addClass(
            @RequestBody Class newclass
            )
    {
        try
        {
            return ResponseEntity.ok(classServices.addClass(newclass,getCurrentSessionMember()));
        }
        catch (Exception e)
        {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }
    @GetMapping("/class")
    public ResponseEntity<?> getClassById(
            @RequestParam(name = "id") long id
    )
    {
        try
        {
            return ResponseEntity.ok(classServices.getClassByID(id,getCurrentSessionMember()));
        }
        catch (Exception e)
        {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }
    @GetMapping("/class/all")
    public ResponseEntity<?> getAllClass()
    {
        try
        {
            return ResponseEntity.ok(classServices.getAllClass(getCurrentSessionMember()));
        }
        catch (Exception e)
        {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }
    @GetMapping("/class/member/name")
    public ResponseEntity<?> getMembersNameByClassId(
            @RequestParam(name = "class_id") long id
    )
    {
        try
        {
            return ResponseEntity.ok(classServices.getMembersName(id,getCurrentSessionMember()));
        }
        catch (Exception e)
        {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }
    @PutMapping("/class")
    public ResponseEntity<?> putClassByID(
            @RequestBody PutRequest putRequest
    )
    {
        try
        {
            return ResponseEntity.ok(classServices.updateByID(putRequest,getCurrentSessionMember()));
        }
        catch (Exception e)
        {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }
    @DeleteMapping("/class")
    public ResponseEntity<?> deleteClassByID(
            @RequestParam(name = "id") long id
    )
    {
        try
        {
            return ResponseEntity.ok(classServices.deleteClassById(id,getCurrentSessionMember()));
        }
        catch (Exception e)
        {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }
    //Class-----------------------------------------
    //todo:Member_Class-----------------------------
    @PostMapping("/member_class")
    public ResponseEntity<?> addMember_to_Class_ById(
            @RequestParam(name = "member_id") long member_id,
            @RequestParam(name = "class_id") long class_id
    )
    {
        try
        {
            return ResponseEntity.ok(memberClassServices.addMember_To_Class_ById(member_id,class_id,getCurrentSessionMember()));
        }
        catch (Exception e)
        {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }
    @PutMapping("/member_class")
    public ResponseEntity<?> updateMember_ClassById(
            @RequestBody PutRequest putRequest,
            @RequestParam(name = "member_id") long member_id,
            @RequestParam(name = "class_id") long class_id
    )
    {
        try
        {
            return ResponseEntity.ok(memberClassServices.updateByID(member_id,class_id,putRequest,getCurrentSessionMember()));
        }
        catch (Exception e)
        {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }
    @DeleteMapping("/member_class")
    public ResponseEntity<?> deleteMember_ClassById(
            @RequestParam(name = "member_id") long member_id,
            @RequestParam(name = "class_id") long class_id
    )
    {
        try
        {
            return ResponseEntity.ok(memberClassServices.deleteById(member_id,class_id,getCurrentSessionMember()));
        }
        catch (Exception e)
        {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }
    //Member_Class----------------------------------

    //todo: Member----------------------------------
    @GetMapping("/member")
    public Member getCurrentSessionMember()
    {
        return memberServices.getMemberByUsername(
                SecurityContextHolder
                        .getContext()
                        .getAuthentication()
                        .getName()
        ).orElse(
                null
        );
    }
    @GetMapping("/member/all")
    public ResponseEntity<?> getAllStudent()
    {
        try
        {
            return ResponseEntity.ok(memberServices.getAllStudent(getCurrentSessionMember()));
        }
        catch (Exception e)
        {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }
    @GetMapping("/member/full")
    public ResponseEntity<?> getAllMember()
    {
        try
        {
            return ResponseEntity.ok(memberServices.getAllMember(getCurrentSessionMember()));
        }
        catch (Exception e)
        {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }
    @GetMapping("/member/search")
    public ResponseEntity<?> findMember_ByUsername(
            @RequestParam(name = "username") String username
    )
    {
        try
        {
            return ResponseEntity.ok(memberServices.findByUsername(username,getCurrentSessionMember()));
        }
        catch (Exception e)
        {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @PutMapping("/member")
    public ResponseEntity<?>putMember(
            @RequestBody PutRequest putRequest
    )
    {
        try
        {
            return ResponseEntity.ok(memberServices.updateById(putRequest,getCurrentSessionMember()));
        }
        catch (Exception e)
        {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @GetMapping("/member/classes/done")
    public ResponseEntity<?>getFinishedClasses(
            @RequestParam(name = "member_id") long id
    )
    {
        try
        {
            return ResponseEntity.ok(memberServices.FinishedClasses(getCurrentSessionMember(),memberServices.getMemberById(id)));
        }
        catch (Exception e)
        {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }
    @GetMapping("/member/classes/undone")
    public ResponseEntity<?> getUnfinishedClasses(
            @RequestParam(name = "member_id") long id
    )
    {
        try
        {
            return ResponseEntity.ok(memberServices.UnfinishedClasses(getCurrentSessionMember(),memberServices.getMemberById(id)));
        }
        catch (Exception e)
        {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }
    //Member----------------------------------------
}
