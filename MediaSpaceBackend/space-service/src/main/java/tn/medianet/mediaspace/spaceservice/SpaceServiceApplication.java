package tn.medianet.mediaspace.spaceservice;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;

import java.util.Collection;
import java.util.List;


@SpringBootApplication
@EnableDiscoveryClient
public class SpaceServiceApplication {

	public static void main(String[] args) {
		SpringApplication.run(SpaceServiceApplication.class, args);
	}

}
