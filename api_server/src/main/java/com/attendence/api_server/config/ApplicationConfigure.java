package com.attendence.api_server.config;

import com.attendence.api_server.member.Member_repository;
import jakarta.servlet.MultipartConfigElement;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.annotation.Order;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.filter.CommonsRequestLoggingFilter;
import org.springframework.web.multipart.MultipartResolver;
import org.springframework.web.multipart.support.MultipartFilter;
import org.springframework.web.multipart.support.StandardServletMultipartResolver;

@Configuration
public class ApplicationConfigure {

    private final Member_repository memberRepository;

    public ApplicationConfigure(Member_repository userRepository) {
        this.memberRepository = userRepository;
    }
    @Bean
    public UserDetailsService userDetailsService()
    {
        return username -> memberRepository.findByUsername(username)
                .orElseThrow(()->new UsernameNotFoundException("User not found!"));
    }

    @Bean
    public AuthenticationProvider authenticationProvider()
    {
        DaoAuthenticationProvider authProvider=new DaoAuthenticationProvider();
        authProvider.setUserDetailsService(userDetailsService());
        authProvider.setPasswordEncoder(passwordEncoder());
        return authProvider;
    }
    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration config ) throws Exception
    {
        return config.getAuthenticationManager();
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

//    @Bean
//    public MultipartConfigElement multipartConfigElement() {
//        // Cấu hình vị trí lưu tạm, kích thước file tối đa, kích thước yêu cầu tối đa, và kích thước tối thiểu khi dữ liệu được ghi vào đĩa
//        return new MultipartConfigElement("/tmp", 10 * 1024 * 1024 * 1024, 11 * 1024 * 1024 * 1024, 0);
//    }
    @Bean
    public MultipartResolver multipartResolver() {
        return new StandardServletMultipartResolver();
    }
//    @Bean
//    @Order(0)
//    public MultipartFilter multipartFilter() {
//        MultipartFilter multipartFilter = new MultipartFilter();
//        multipartFilter.setMultipartResolverBeanName("multipartResolver");
//        return multipartFilter;
//    }
//    @Bean
//    public CommonsRequestLoggingFilter requestLoggingFilter() {
//        CommonsRequestLoggingFilter loggingFilter = new CommonsRequestLoggingFilter();
//        loggingFilter.setIncludeClientInfo(true);
//        loggingFilter.setIncludeQueryString(true);
//        loggingFilter.setIncludePayload(true);
//        loggingFilter.setMaxPayloadLength(10000);
//        return loggingFilter;
//    }
}
