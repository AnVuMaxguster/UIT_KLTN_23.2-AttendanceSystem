package com.attendence.api_server.JWT;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Service;

import java.security.Key;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.Objects;
import java.util.function.Function;

@Service
public class JwtServices {


    //private key in hex
    private String SecretKey="79314C6F345A62387131723679454E32346178686C596A63566B726968514D33";

    //extract username from token
    public String extractUsername(String Token)
    {
        return extractClaim(Token,Claims::getSubject);
    }

    //extract a claim from token
    public <T> T extractClaim(String Token,Function<Claims,T> Func){
        final Claims claims=extractALLClaims(Token);
        return Func.apply(claims);
    }
    public String generateToken(UserDetails userDetails)
    {
        return generateToken(new HashMap<>(),userDetails);
    }

    public boolean isTokenValid(String token,UserDetails userDetails)
    {
        String username=extractUsername(token);
        return (username.equals(userDetails.getUsername()))&&!isTokenExpired(token);
    }
    public boolean isTokenExpired(String token)
    {
        return  getTokenExpiration(token).before(new Date(System.currentTimeMillis()));
    }
    public Date getTokenExpiration(String token)
    {
        return extractClaim(token,Claims::getExpiration);
    }

    public String generateToken(
            Map<String, Objects> extraClaims,
            UserDetails userDetails
    )
    {
        final int One_Day_Milis=86400000;
        return Jwts
                .builder()
                .setClaims(extraClaims)
                .setSubject(userDetails.getUsername())
                .setIssuedAt(new Date(System.currentTimeMillis()))
                .setExpiration(new Date(System.currentTimeMillis()+One_Day_Milis))
                .signWith(getSigningKey(), SignatureAlgorithm.HS256)
                .compact();
    }

    //using SecretKey to extract all Claims
    private Claims extractALLClaims(String Token)
    {
        return Jwts
                .parserBuilder()
                .setSigningKey(getSigningKey())
                .build()
                .parseClaimsJws(Token)
                .getBody();
    }

    //generate a secretKey
    private Key getSigningKey() {
        byte[] keyBytes= Decoders.BASE64.decode(SecretKey);
        return Keys.hmacShaKeyFor(keyBytes);
    }
}
