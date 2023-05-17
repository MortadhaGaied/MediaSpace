package tn.medianet.mediaspace.gatewayservice.filter;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cloud.gateway.filter.GatewayFilter;
import org.springframework.cloud.gateway.filter.factory.AbstractGatewayFilterFactory;
import org.springframework.http.HttpHeaders;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.core.publisher.Mono;

@Component
public class AuthenticationFilter extends AbstractGatewayFilterFactory<AuthenticationFilter.Config> {

    @Autowired
    private RouteValidator validator;
    @Autowired
    private WebClient.Builder webClientBuilder;



    public AuthenticationFilter() {
        super(Config.class);
    }

    @Override
    public GatewayFilter apply(Config config) {
        return ((exchange, chain) -> {
            if (validator.isSecured.test(exchange.getRequest())) {
                //header contains token or not
                if (!exchange.getRequest().getHeaders().containsKey(HttpHeaders.AUTHORIZATION)) {
                    throw new RuntimeException("missing authorization header");
                }

                String authHeader = exchange.getRequest().getHeaders().get(HttpHeaders.AUTHORIZATION).get(0);
                if (authHeader != null && authHeader.startsWith("Bearer ")) {
                    authHeader = authHeader.substring(7);
                }


                //REST call to AUTH service
                Mono<Boolean> isValidMono = webClientBuilder.build()
                        .get()
                        .uri("http://AUTH-SERVICE/auth/validate?token=" + authHeader)
                        .retrieve()
                        .bodyToMono(Boolean.class);
                return isValidMono.flatMap(isValid -> {
                    if (!isValid) {
                        return Mono.error(new RuntimeException("unauthorized access to application"));
                    } else {
                        return chain.filter(exchange);
                    }
                });


            }
            return chain.filter(exchange);
        });
    }

    public static class Config {

    }
}

