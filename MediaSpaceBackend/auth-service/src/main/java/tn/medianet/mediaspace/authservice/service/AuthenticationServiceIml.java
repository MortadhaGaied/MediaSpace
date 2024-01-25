package tn.medianet.mediaspace.authservice.service;

import com.talanlabs.avatargenerator.Avatar;
import com.talanlabs.avatargenerator.cat.CatAvatar;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.server.ResponseStatusException;
import tn.medianet.mediaspace.authservice.config.JwtService;
import tn.medianet.mediaspace.authservice.entity.Role;
import tn.medianet.mediaspace.authservice.entity.User;
import tn.medianet.mediaspace.authservice.exception.AccountNotEnabledException;
import tn.medianet.mediaspace.authservice.exception.BadRequestException;
import tn.medianet.mediaspace.authservice.exception.ResourceNotFoundException;
import tn.medianet.mediaspace.authservice.exception.UnauthorizedException;
import tn.medianet.mediaspace.authservice.repository.UserRepository;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.Collections;
@Service
@RequiredArgsConstructor
public class AuthenticationServiceIml implements AuthenticationService{

    private final UserRepository repository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;
    private final AuthenticationManager authenticationManager;
    private final IServiceFile serviceFile;
    public AuthenticationResponse register(RegisterRequest request) {
        if (repository.findByEmail(request.getEmail()).isPresent()) {
            throw new BadRequestException("Email already exists.");
        }
        User user = null;
        try {
            Avatar avatar = CatAvatar.newAvatarBuilder().build();

            String filename=serviceFile.uploadFile(avatar.createAsPngBytes(123456L),System.currentTimeMillis()+request.getFirstname()+"_"+request.getLastname()+"_avatar","image/jpeg");


            user = User.builder()
                    .firstname(request.getFirstname())
                    .lastname(request.getLastname())
                    .email(request.getEmail())
                    .password(passwordEncoder.encode(request.getPassword()))
                    .roles(Collections.singleton(Role.ROLE_CLIENT))
                    .profile_picture(filename)
                    .build();
        } catch (IOException e) {
            throw new RuntimeException(e);
        }


        repository.save(user);
        var accessToken = jwtService.generateToken(user);
        var refreshToken = jwtService.generateRefreshToken(user);
        return AuthenticationResponse.builder()
                .accessToken(accessToken)
                .refreshToken(refreshToken)
                .id(user.getId())
                .build();
    }

    public AuthenticationResponse authenticate(AuthenticationRequest request) {
        User user = repository.findByEmail(request.getEmail())
                .orElseThrow(() -> new ResourceNotFoundException("User not found."));
        System.out.println(user);
        if (!user.isEnabled()) {
            throw new AccountNotEnabledException("User account is not enabled.");
        }
        try {

            Authentication authentication = authenticationManager.authenticate(
                    new UsernamePasswordAuthenticationToken(
                            request.getEmail(),
                            request.getPassword()
                    )
            );


            SecurityContextHolder.getContext().setAuthentication(authentication);
        } catch (BadCredentialsException e) {
            throw new UnauthorizedException("Invalid credentials.");
        }

        var accessToken = jwtService.generateToken(user);
        var refreshToken = jwtService.generateRefreshToken(user);
        return AuthenticationResponse.builder()
                .accessToken(accessToken)
                .refreshToken(refreshToken)
                .id(user.getId())
                .build();

    }
    public AuthenticationResponse refresh(RefreshRequest request) {
        String refreshToken = request.getRefreshToken();
        UserDetails userDetails;

        try {
            userDetails = getUserDetailsFromRefreshToken(refreshToken);
        } catch (Exception e) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Invalid refresh token");
        }

        if (!jwtService.isRefreshTokenValid(refreshToken, userDetails)) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Invalid refresh token");
        }

        var accessToken = jwtService.generateToken(userDetails);
        return AuthenticationResponse.builder()
                .accessToken(accessToken)
                .refreshToken(refreshToken)
                .build();
    }

    private UserDetails getUserDetailsFromRefreshToken(String refreshToken) {
        String username = jwtService.extractUsername(refreshToken);
        return repository.findByEmail(username)
                .orElseThrow(() -> new UsernameNotFoundException("User not found"));
    }
    public boolean validateToken(String token) {
        try {
            jwtService.validateToken(token);
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    @Override
    public UserResponse getUserById(Long id) {
        User user = repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("User not found."));
        return UserResponse.builder()
                .id(id)
                .firstname(user.getFirstname())
                .lastname(user.getLastname())
                .profile_picture(user.getProfile_picture())
                .email(user.getEmail())
                .enabled(user.isEnabled())
                .phone_number(user.getPhone_number())
                .build();

    }


}
