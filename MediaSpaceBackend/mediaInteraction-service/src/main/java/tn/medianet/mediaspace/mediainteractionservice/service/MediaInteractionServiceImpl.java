package tn.medianet.mediaspace.mediainteractionservice.service;

import jakarta.transaction.Transactional;
import lombok.AllArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import tn.medianet.mediaspace.mediainteractionservice.entity.Comment;
import tn.medianet.mediaspace.mediainteractionservice.entity.Like;
import tn.medianet.mediaspace.mediainteractionservice.entity.LikeType;
import tn.medianet.mediaspace.mediainteractionservice.entity.Video;
import tn.medianet.mediaspace.mediainteractionservice.repository.CommentRepository;
import tn.medianet.mediaspace.mediainteractionservice.repository.LikeRepository;
import tn.medianet.mediaspace.mediainteractionservice.repository.VideoRepository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
@AllArgsConstructor
public class MediaInteractionServiceImpl implements MediaInteractionService {
    private final CommentRepository commentRepository;
    private final LikeRepository likeRepository;
    private final VideoRepository videoRepository;


    @Override
    public Video saveVideo(Video video) {
        return videoRepository.save(video);
    }

    @Override
    public Video getVideo(Long id) {
        return videoRepository.getReferenceById(id);
    }

    @Transactional
    public void likeVideo(Long userId, Long videoId) {
        Optional<Like> existingLike = likeRepository.findByUserIdAndTargetIdAndTargetType(userId, videoId, LikeType.VIDEO);
        if (existingLike.isEmpty()) {
            Like like = new Like(null, userId, videoId, LikeType.VIDEO);
            likeRepository.save(like);

            Video video = videoRepository.findById(videoId).orElseThrow();
            video.setLikeCount(video.getLikeCount() + 1);
            videoRepository.save(video);
        }
        else{
            likeRepository.delete(existingLike.get());
            Video video = videoRepository.findById(videoId).orElseThrow();
            video.setLikeCount(video.getLikeCount() - 1);
            videoRepository.save(video);

        }
    }

    @Transactional
    public void likeComment(Long userId, Long commentId) {
        Optional<Like> existingLike = likeRepository.findByUserIdAndTargetIdAndTargetType(userId, commentId, LikeType.COMMENT);
        if (existingLike.isEmpty()) {
            Like like = new Like(null, userId, commentId, LikeType.COMMENT);
            likeRepository.save(like);

            Comment comment = commentRepository.findById(commentId).orElseThrow();
            comment.setLikeCount(comment.getLikeCount() + 1);
            commentRepository.save(comment);
        }
    }

    @Override
    public Comment addComment(Comment comment) {
        comment.setCreatedAt(LocalDateTime.now());
        return commentRepository.save(comment);
    }

    @Override
    public List<Comment> getCommentsForVideo(Long videoId) {
        return commentRepository.findByVideoId(videoId);
    }
    @Override
    public List<Video> getAllVideos() {
        return videoRepository.findAll();
    }

    @Transactional
    public void deleteComment(Long commentId) {
        Comment comment = commentRepository.findById(commentId).orElseThrow();
        commentRepository.delete(comment);
    }

    @Override
    public boolean isCommentLiked(Long idComment, Long idUser) {
        Optional<Like> existingLike = likeRepository.findByUserIdAndTargetIdAndTargetType(idUser, idComment, LikeType.COMMENT);
        return existingLike.isPresent();
    }

}
