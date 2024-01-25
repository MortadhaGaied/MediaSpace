package tn.medianet.mediaspace.authservice.service;

import org.springframework.web.multipart.MultipartFile;

import java.awt.image.BufferedImage;
import java.io.IOException;

public interface IServiceFile {
    String uploadFile(byte[] bytes, String fileName, String contentType) throws IOException ;
    String getDownloadUrl(String fileName) throws IOException;
}
