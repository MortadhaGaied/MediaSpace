package tn.medianet.mediaspace.mediainteractionservice.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import tn.medianet.mediaspace.mediainteractionservice.entity.Comment;
import tn.medianet.mediaspace.mediainteractionservice.entity.Video;
import tn.medianet.mediaspace.mediainteractionservice.service.IServiceFile;
import tn.medianet.mediaspace.mediainteractionservice.service.MediaInteractionServiceImpl;

import java.io.IOException;
import java.util.List;

@RestController
@RequestMapping("/mediainteraction")
public class MediaInteractionController {

    @Autowired
    private MediaInteractionServiceImpl mediaInteractionService;
    @Autowired
    private IServiceFile serviceFile;

    @PostMapping("/video/{spaceId}")
    public ResponseEntity<Video> addVideo(@PathVariable Long spaceId, @RequestParam("file") MultipartFile file) {
        try {
            // Check file size (5 * 1024 * 1024 is 5MB in bytes)
            if (file.getSize() > 50 * 1024 * 1024) {
                // return an empty ResponseEntity with BAD_REQUEST status
                return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
            }

            byte[] bytes = file.getBytes();
            String fileName = file.getOriginalFilename();
            String contentType = file.getContentType();

            if (fileName == null || contentType == null) {
                return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
            }

            // Upload the file and get the filename
            String uploadedFileName = serviceFile.uploadFile(bytes, fileName, contentType);

            // Create a new Video object and set its properties
            Video video = new Video();
            video.setTitle(uploadedFileName);
            video.setSpaceId(spaceId);
            // Save the Video object
            return new ResponseEntity<>(mediaInteractionService.saveVideo(video), HttpStatus.CREATED);

        } catch (IOException e) {
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
    @PostMapping("/comment")
    public ResponseEntity<Comment> addComment(@RequestBody Comment comment) {
        return new ResponseEntity<>(mediaInteractionService.addComment(comment), HttpStatus.CREATED);
    }

    @GetMapping("/video/{id}/comments")
    public ResponseEntity<List<Comment>> getCommentsForVideo(@PathVariable Long id) {
        return new ResponseEntity<>(mediaInteractionService.getCommentsForVideo(id), HttpStatus.OK);
    }

    @PostMapping("/video/{videoId}/like")
    public ResponseEntity<Void> likeVideo(@PathVariable Long videoId, @RequestParam Long userId) {
        mediaInteractionService.likeVideo(userId, videoId);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @PostMapping("/comment/{commentId}/like")
    public ResponseEntity<Void> likeComment(@PathVariable Long commentId, @RequestParam Long userId) {
        mediaInteractionService.likeComment(userId, commentId);
        return new ResponseEntity<>(HttpStatus.OK);
    }
    @GetMapping("/videos")
    public ResponseEntity<List<Video>> getAllVideos() {
        return new ResponseEntity<>(mediaInteractionService.getAllVideos(), HttpStatus.OK);
    }

    @DeleteMapping("/comment/{commentId}")
    public ResponseEntity<Void> deleteComment(@PathVariable Long commentId) {
        mediaInteractionService.deleteComment(commentId);
        return new ResponseEntity<>(HttpStatus.NO_CONTENT);
    }
    @GetMapping("/isLiked")
    public ResponseEntity<Boolean> isCommentLiked(
            @RequestParam Long idComment,
            @RequestParam Long idUser) {

        boolean isLiked = mediaInteractionService.isCommentLiked(idComment, idUser);
        return ResponseEntity.ok(isLiked);
    }
    @GetMapping("/videoUrl/{id}")
    public ResponseEntity<String> getVideoUrl(@PathVariable Long id) {
        try {
            Video video = mediaInteractionService.getVideo(id);
            if (video == null) {
                return new ResponseEntity<>("Video not found", HttpStatus.NOT_FOUND);
            }
            String downloadUrl = serviceFile.getDownloadUrl(video.getTitle());
            if (downloadUrl == null) {
                return new ResponseEntity<>("Could not generate download URL", HttpStatus.INTERNAL_SERVER_ERROR);
            }
            return new ResponseEntity<>(downloadUrl, HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>(e.getMessage(), HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }



    @ExceptionHandler({ Exception.class })
    public ResponseEntity<String> handleException() {
        return new ResponseEntity<>("An error occurred", HttpStatus.INTERNAL_SERVER_ERROR);
    }

}
