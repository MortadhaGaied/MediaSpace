package tn.medianet.mediaspace.mediainteractionservice.service;

import tn.medianet.mediaspace.mediainteractionservice.entity.Comment;
import tn.medianet.mediaspace.mediainteractionservice.entity.Video;

import java.util.List;

public interface MediaInteractionService {
    Video saveVideo(Video video);
    Video getVideo(Long id);
    void likeVideo(Long userId, Long videoId);
    void likeComment(Long userId, Long commentId);
    Comment addComment(Comment comment);
    List<Comment> getCommentsForVideo(Long videoId);
    List<Video> getAllVideos();
    void deleteComment(Long commentId);
    boolean isCommentLiked(Long idComment,Long idUser);
}
