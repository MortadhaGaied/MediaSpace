package tn.medianet.mediaspace.messagingservice.config;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.cloud.firestore.Firestore;
import com.google.cloud.firestore.FirestoreOptions;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.io.FileInputStream;
import java.io.IOException;

@Configuration
public class FirestoreConfig {

    @Value("${firebase.config.file}")
    private String firebaseConfigPath;

    @Bean
    public Firestore firestore() throws IOException {
        GoogleCredentials credentials = GoogleCredentials.fromStream(new FileInputStream(firebaseConfigPath));
        FirestoreOptions firestoreOptions = FirestoreOptions.getDefaultInstance().toBuilder()
                .setProjectId("mediaspace-40056")
                .setCredentials(credentials)
                .build();
        return firestoreOptions.getService();
    }
}

