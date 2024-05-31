package com.attendence.api_server.Authentication;

import com.attendence.api_server.member.Role;

public class RegisterRequest {
    private String Username;
    private String Password;
    private String DisplayName;
    private String email;
    private Role role;

    public RegisterRequest(String username, String password, String displayName,String email,Role role) {
        Username = username;
        Password = password;
        DisplayName = displayName;
        this.email=email;
        this.role=role;
    }

    public String getUsername() {
        return Username;
    }

    public void setUsername(String username) {
        Username = username;
    }

    public String getPassword() {
        return Password;
    }

    public void setPassword(String password) {
        Password = password;
    }

    public String getDisplayName() {
        return DisplayName;
    }

    public void setDisplayName(String displayName) {
        DisplayName = displayName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public Role getRole() {
        return role;
    }

    public void setRole(Role role) {
        this.role = role;
    }
}
