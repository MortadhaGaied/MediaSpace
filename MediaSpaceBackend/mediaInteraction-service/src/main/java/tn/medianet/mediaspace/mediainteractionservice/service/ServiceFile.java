package tn.medianet.mediaspace.mediainteractionservice.service;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.cloud.storage.*;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Service;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.net.URL;
import java.util.concurrent.TimeUnit;
@Service
@Slf4j
public class ServiceFile implements IServiceFile {
    @Value("${app.firebase-configuration-file}")
    private String firebaseConfigPath;
    private final String BUCKETNAME = "mediaspace-daa28.appspot.com";

    private final String PROJECTID = "mediaspace-daa28";
    private StorageOptions getStorageOptions() throws IOException {
        StorageOptions storageOptions;

        storageOptions = StorageOptions.newBuilder()
                .setProjectId(PROJECTID)
                .setCredentials(GoogleCredentials.fromStream(new ClassPathResource(firebaseConfigPath).getInputStream())).build();
        return storageOptions;
    }

    public String uploadFile(byte[] bytes, String fileName, String contentType) throws IOException {
        // Add additional content types for video
        boolean isImage = contentType.equals("image/jpeg") || contentType.equals("image/png");
        boolean isVideo = contentType.equals("video/mp4") || contentType.equals("video/avi");

        if (!isImage && !isVideo) {
            return ("File uploaded must be of type image or video only");
        }

        Storage storage = getStorageOptions().getService();
        BlobId blobId = BlobId.of(BUCKETNAME, fileName);
        BlobInfo blobInfo = BlobInfo.newBuilder(blobId).setContentType(contentType).build();
        Blob blob = storage.create(blobInfo, bytes);

        log.info("File " + fileName + " uploaded to bucket " + BUCKETNAME + " as " + fileName + " blobId " + blobId);
        return fileName;
    }

    public String getDownloadUrl(String fileName) throws IOException {
        Storage storage = getStorageOptions().getService();

        BlobId blobId = BlobId.of(BUCKETNAME, fileName);
        Blob b = storage.get(blobId);

        if (b == null) {
            throw new FileNotFoundException("File not found in the storage bucket: " + fileName);
        }

        URL signedUrl = storage.signUrl(b, 1, TimeUnit.HOURS, Storage.SignUrlOption.withV4Signature());
        return signedUrl.toString();
    }
}
