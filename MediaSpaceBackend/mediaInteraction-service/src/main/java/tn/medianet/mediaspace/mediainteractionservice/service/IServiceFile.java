package tn.medianet.mediaspace.mediainteractionservice.service;

import java.io.IOException;

public interface IServiceFile {
    String uploadFile(byte[] bytes, String fileName, String contentType) throws IOException ;
    String getDownloadUrl(String fileName) throws IOException;
}
