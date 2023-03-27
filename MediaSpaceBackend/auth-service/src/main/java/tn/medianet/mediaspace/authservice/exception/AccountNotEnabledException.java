package tn.medianet.mediaspace.authservice.exception;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

@ResponseStatus(HttpStatus.FORBIDDEN)
public class AccountNotEnabledException extends RuntimeException {
    public AccountNotEnabledException(String message) {
        super(message);
    }
}

