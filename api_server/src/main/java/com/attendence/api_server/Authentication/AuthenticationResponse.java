package com.attendence.api_server.Authentication;

public class AuthenticationResponse {
    private String Token;

    public String getToken() {
        return Token;
    }

    public void setToken(String token) {
        Token = token;
    }

    public AuthenticationResponse(String token) {
        Token = token;
    }
}
