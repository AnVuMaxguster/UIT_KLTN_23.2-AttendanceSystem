package com.attendence.api_server.Authentication;

public class ChangePasswordRequest {
    private AuthenticationRequest authenticationRequest;
    private String newPassword;

    private String resetPasscode;
    private String email;

    public ChangePasswordRequest(AuthenticationRequest authenticationRequest, String newPassword) {
        this.authenticationRequest = authenticationRequest;
        this.newPassword = newPassword;
    }

    public ChangePasswordRequest(String newPassword, String resetPasscode, String email) {
        this.newPassword = newPassword;
        this.resetPasscode = resetPasscode;
        this.email = email;
    }

    public ChangePasswordRequest() {
    }

    public AuthenticationRequest getAuthenticationRequest() {
        return authenticationRequest;
    }

    public void setAuthenticationRequest(AuthenticationRequest authenticationRequest) {
        this.authenticationRequest = authenticationRequest;
    }

    public String getNewPassword() {
        return newPassword;
    }

    public void setNewPassword(String newPassword) {
        this.newPassword = newPassword;
    }

    public String getResetPasscode() {
        return resetPasscode;
    }

    public void setResetPasscode(String resetPasscode) {
        this.resetPasscode = resetPasscode;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }
}
