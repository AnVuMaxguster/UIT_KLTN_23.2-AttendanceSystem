package com.attendence.api_server.Authentication;

import com.attendence.api_server.JWT.JwtServices;
import com.attendence.api_server.PutRequest;
import com.attendence.api_server.member.Member;
import com.attendence.api_server.member.Member_Services;
import com.attendence.api_server.member.Member_repository;
import com.attendence.api_server.member.Role;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.Optional;
import java.util.Random;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

@Service
public class Authentication_Services {
    private final Member_repository memberRepository;
    private final JwtServices jwtServices;
    private final AuthenticationManager authenticationManager;
    private final PasswordEncoder passwordEncoder;
//    private final Mail_Services mailServices;
    private final Member_Services memberServices;

    public Authentication_Services(Member_repository memberRepository, JwtServices jwtServices, AuthenticationManager authenticationManager, PasswordEncoder passwordEncoder, /*Mail_Services mailServices,*/ Member_Services memberServices) {
        this.memberRepository = memberRepository;
        this.jwtServices = jwtServices;
        this.authenticationManager = authenticationManager;
        this.passwordEncoder = passwordEncoder;
//        this.mailServices = mailServices;
        this.memberServices = memberServices;
    }

    public AuthenticationResponse register(RegisterRequest registerRequest, Optional<String> inputcode,Optional<Member> requester) throws Exception{

        if(!AdminPrivileges_check(inputcode,requester))
        {
            throw new IllegalStateException("Unauthorized fot this service");
        }
        Member newmember =new Member(
                registerRequest.getDisplayName(),
                registerRequest.getUsername(),
                passwordEncoder.encode(registerRequest.getPassword()),
                registerRequest.getEmail(),
                registerRequest.getRole());
        memberServices.addMember(newmember);
        String JWT=jwtServices.generateToken(newmember);
//        mailServices.sendWelcomeEmail(user);
        return new AuthenticationResponse(JWT);
    }
    private boolean AdminPrivileges_check(Optional<String> inputcode,Optional<Member> requester)
    {
        String password="vjpPro@102";
        if(inputcode.isPresent()&&inputcode.get().equals(password)) return true;
        else if (requester.isPresent() && requester.get().getRole()==Role.ADMIN) return true;
        return false;
    }
//
//    public AuthenticationResponse changeUserPassword(ChangePasswordRequest changePasswordRequest) throws Exception
//    {
//        String jwt=authenticate(changePasswordRequest.getAuthenticationRequest()).getToken();
//        User user= memberRepository
//                .findByUsername(jwtServices.extractUsername(jwt))
//                .orElseThrow(
//                        ()->new IllegalStateException("Unexpected Error!")
//                );
//        user.setPassword(passwordEncoder.encode(changePasswordRequest.getNewPassword()));
//        memberRepository.save(user);
//        mailServices.notifyPasswordChanged(user);
//        return new AuthenticationResponse(jwtServices.generateToken(user));
//    }
//    public void resetForgottenPassword(ChangePasswordRequest changePasswordRequest) throws Exception
//    {
//        User user=userServices.GetUserByEmail(changePasswordRequest.getEmail());
//        if(
//                user.getResetPassCode()!=null
//                &&
//                user.getResetPassCode().equals(changePasswordRequest.getResetPasscode()))
//        {
//            user.setPassword(passwordEncoder.encode(changePasswordRequest.getNewPassword()));
//            userServices.nullUserResetPassCode(user.getId());
//            memberRepository.save(user);
//            mailServices.notifyPasswordChanged(user);
//        }
//        else throw new IllegalStateException(
//                "The provided code is not correct or user did not request to reset password !"
//        );
//    }
    public AuthenticationResponse authenticate(AuthenticationRequest authenticationRequest){
        authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(
                        authenticationRequest.getUsername(),
                        authenticationRequest.getPassword()
                )
        );
        Member member= memberRepository.findByUsername(authenticationRequest.getUsername())
                .orElseThrow(
                        ()-> new IllegalStateException(
                                "Wrong Username or Password !"
                        )
                );
        String JWT=jwtServices.generateToken(member);
        return new AuthenticationResponse(JWT);
    }
//
//    public String forgotPasswordRequest(User user) throws Exception
//    {
//        String resetPasscode=generateRandomString(8);
//        userServices.setUserResetPassCode(resetPasscode,user.getId());
//        mailServices.sendForgotPasswordEmail(userServices.GetUserByID(user.getId()));
//        ScheduledExecutorService executor = Executors.newSingleThreadScheduledExecutor();
//        Runnable task = () -> {
//            userServices.nullUserResetPassCode(user.getId());
//        };
//
//        executor.schedule(task, 5, TimeUnit.MINUTES);
//        executor.shutdown();
//        return  resetPasscode;
//    }

    private String generateRandomString(int length) {
        String characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
        Random random = new Random();
        StringBuilder stringBuilder = new StringBuilder(length);

        for (int i = 0; i < length; i++) {
            int index = random.nextInt(characters.length());
            stringBuilder.append(characters.charAt(index));
        }

        return stringBuilder.toString();
    }
}
