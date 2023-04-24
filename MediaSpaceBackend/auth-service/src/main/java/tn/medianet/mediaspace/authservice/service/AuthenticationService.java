package tn.medianet.mediaspace.authservice.service;

public interface AuthenticationService {
    AuthenticationResponse register(RegisterRequest request);
    AuthenticationResponse authenticate(AuthenticationRequest request);
    AuthenticationResponse refresh(RefreshRequest request);
    boolean validateToken(String token);
}
