package tn.medianet.mediaspace.gatewayservice.filter;

import org.springframework.stereotype.Component;
import org.springframework.http.server.reactive.ServerHttpRequest;
import java.util.List;
import java.util.function.Predicate;
@Component
public class RouteValidator {
    public static final List<String> openApiEndpoints = List.of(
            "/api/v1/auth/register",
            "/api/v1/auth/authenticate",
            "/api/v1/auth/refresh",
            "/eureka"
    );

    public Predicate<ServerHttpRequest> isSecured =
            request -> openApiEndpoints
                    .stream()
                    .noneMatch(uri -> request.getURI().getPath().contains(uri));
}
