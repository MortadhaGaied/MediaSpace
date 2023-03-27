package tn.medianet.mediaspace.authservice.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/demo-controller")
public class DemoController {

    @PreAuthorize("hasAuthority('ROLE_ADMIN')")
    @GetMapping("/admin")
    public ResponseEntity<String> sayHelloAdmin() {
        return ResponseEntity.ok("Hello from admin secured endpoint");
    }

    @PreAuthorize("hasAuthority('ROLE_HOST')")
    @GetMapping("/host")
    public ResponseEntity<String> sayHelloHost() {
        return ResponseEntity.ok("Hello from host secured endpoint");
    }

    @PreAuthorize("hasAuthority('ROLE_CLIENT')")
    @GetMapping("/client")
    public ResponseEntity<String> sayHelloClient() {
        return ResponseEntity.ok("Hello from client secured endpoint");
    }

}