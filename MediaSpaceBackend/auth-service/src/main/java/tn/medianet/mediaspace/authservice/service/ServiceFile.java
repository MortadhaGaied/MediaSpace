package tn.medianet.mediaspace.authservice.service;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.cloud.storage.*;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartFile;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.*;
import java.net.URL;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Date;
import java.util.Objects;
import java.util.concurrent.TimeUnit;
@Service
@Slf4j
public class ServiceFile implements IServiceFile {
    @Value("${app.firebase-configuration-file}")
    private String firebaseConfigPath;
    private final String BUCKETNAME = "mediaspace-40056.appspot.com";

    private final String PROJECTID = "mediaspace-40056";
    private StorageOptions getStorageOptions() throws IOException {
        StorageOptions storageOptions;

        storageOptions = StorageOptions.newBuilder()
                .setProjectId(PROJECTID)
                .setCredentials(GoogleCredentials.fromStream(new ClassPathResource(firebaseConfigPath).getInputStream())).build();
        return storageOptions;
    }

    public String uploadFile(byte[] bytes, String fileName, String contentType) throws IOException {


        for(byte b:bytes){
            System.out.println(b);
        }
        if (!contentType.equals("image/jpeg") && !contentType.equals("image/png")) {
            return ("File uploaded must be of type image only");
        }

        Storage storage = getStorageOptions().getService();
        BlobId blobId = BlobId.of(BUCKETNAME, fileName);
        BlobInfo blobInfo = BlobInfo.newBuilder(blobId).setContentType(contentType).build();
        Blob blob = storage.create(blobInfo, bytes);

        log.info("File " + fileName + " uploaded to bucket " + BUCKETNAME + " as " + fileName + " blobId " + blobId);
        return fileName;
    }

    private File convertMultiPartToFile(MultipartFile file) throws IOException {
        File convertedFile = new File(Objects.requireNonNull(file.getOriginalFilename()));
        FileOutputStream fos = new FileOutputStream(convertedFile);
        fos.write(file.getBytes());
        fos.close();
        return convertedFile;
    }

    private String generateFileName(MultipartFile multiPart) {
        return new Date().getTime() + "-" + Objects.requireNonNull(multiPart.getOriginalFilename()).replace(" ", "_");
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
