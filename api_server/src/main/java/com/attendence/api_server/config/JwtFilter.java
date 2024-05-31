package com.attendence.api_server.config;

import com.attendence.api_server.JWT.JwtServices;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.util.StreamUtils;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.nio.charset.Charset;

@Component
public class JwtFilter extends OncePerRequestFilter {

    private final JwtServices jwtServices;
    private final UserDetailsService userDetailsService;

    public JwtFilter(JwtServices jwtServices, UserDetailsService userDetailsService) {
        this.jwtServices = jwtServices;
        this.userDetailsService = userDetailsService;
    }

    @Override
    protected void doFilterInternal(
            HttpServletRequest request,
            HttpServletResponse response,
            FilterChain filterChain) throws ServletException, IOException {

        final String authHeader=request.getHeader("Authorization");
        final String Jwt;
        final String Username;
        if(authHeader==null||!authHeader.startsWith("Bearer"))
        {
            filterChain.doFilter(request,response);
            return;
        }
        Jwt=authHeader.substring(7);
        Username=jwtServices.extractUsername(Jwt);
        if(Username!=null && SecurityContextHolder.getContext().getAuthentication()==null)
        {
            UserDetails userDetails=this.userDetailsService.loadUserByUsername(Username);
            if(jwtServices.isTokenValid(Jwt,userDetails))
            {
                UsernamePasswordAuthenticationToken authenticationToken= new UsernamePasswordAuthenticationToken(
                        userDetails,
                        null,
                        userDetails.getAuthorities()
                );
                authenticationToken.setDetails(
                        new WebAuthenticationDetailsSource().buildDetails(request)
                );
                SecurityContextHolder.getContext().setAuthentication(authenticationToken);
            }
        }

        MultiReadHttpServletRequest multiReadRequest = new MultiReadHttpServletRequest((HttpServletRequest) request);
//        System.out.println("\n\n\tDEBUG LOGGING:\n"+StreamUtils.copyToString(multiReadRequest.getInputStream(), Charset.defaultCharset())+"\n\n\n");
        filterChain.doFilter(multiReadRequest,response);
    }
}
