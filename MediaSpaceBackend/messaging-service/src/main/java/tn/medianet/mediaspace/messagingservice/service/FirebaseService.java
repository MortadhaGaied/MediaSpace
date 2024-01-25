package tn.medianet.mediaspace.messagingservice.service;

import com.google.api.core.ApiFuture;
import com.google.cloud.firestore.*;
import com.google.firebase.messaging.FirebaseMessaging;
import com.google.firebase.messaging.FirebaseMessagingException;
import com.google.firebase.messaging.Notification;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import tn.medianet.mediaspace.messagingservice.entity.Chat;
import tn.medianet.mediaspace.messagingservice.entity.Message;
import tn.medianet.mediaspace.messagingservice.entity.NotificationMessage;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ExecutionException;

@Service
public class FirebaseService {

    private final Firestore firestore;
    private final FirebaseMessaging firebaseMessaging;
    @Autowired
    public FirebaseService(Firestore firestore,FirebaseMessaging firebaseMessaging) {
        this.firestore = firestore;
        this.firebaseMessaging=firebaseMessaging;
    }
    public String sendNotificationByToken(NotificationMessage notificationMessage){
        Notification notification=Notification.builder()
                .setTitle(notificationMessage.getTitle())
                .setBody(notificationMessage.getBody())
                .setImage(notificationMessage.getImage())
                .build();
        com.google.firebase.messaging.Message message=com.google.firebase.messaging.Message.builder()
                .setToken(notificationMessage.getRecipientToken())
                .setNotification(notification)
                .putAllData(notificationMessage.getData())
                .build();
        try{
            firebaseMessaging.send(message);
            return "Success Sending Notification";
        }catch (FirebaseMessagingException e){
            e.printStackTrace();
            return "Error Sending Notification";
        }
    }
    public void saveMessage(Message message) {
        ApiFuture<WriteResult> future = firestore.collection("messages").document(message.getId().toString()).set(message);
        try {
            future.get();
        } catch (InterruptedException | ExecutionException e) {
            // Handle exception
            e.printStackTrace();
        }
    }

    public List<Message> getMessagesForChat(String chatId) {
        List<Message> messages = new ArrayList<>();
        ApiFuture<QuerySnapshot> future = firestore.collection("messages").whereEqualTo("chatId", chatId).get();

        try {
            List<QueryDocumentSnapshot> documents = future.get().getDocuments();
            for (QueryDocumentSnapshot document : documents) {
                messages.add(document.toObject(Message.class));
            }
        } catch (InterruptedException | ExecutionException e) {
            // Handle exception
            e.printStackTrace();
        }

        return messages;
    }
    public void updateMessage(Message message) {
        ApiFuture<WriteResult> future = firestore.collection("messages").document(message.getId().toString()).set(message);
        try {
            future.get();
        } catch (InterruptedException | ExecutionException e) {
            e.printStackTrace();
        }
    }
    public void deleteMessage(String messageId) {
        ApiFuture<WriteResult> future = firestore.collection("messages").document(messageId).delete();
        try {
            future.get();
        } catch (InterruptedException | ExecutionException e) {
            e.printStackTrace();
        }
    }
    public Message getMessage(String messageId) {
        ApiFuture<DocumentSnapshot> future = firestore.collection("messages").document(messageId).get();
        try {
            DocumentSnapshot document = future.get();
            if (document.exists()) {
                return document.toObject(Message.class);
            } else {
                return null;
            }
        } catch (InterruptedException | ExecutionException e) {
            e.printStackTrace();
        }
        return null;
    }
    public List<Message> getUnreadMessages(String chatId) {
        List<Message> messages = new ArrayList<>();
        ApiFuture<QuerySnapshot> future = firestore.collection("messages").whereEqualTo("chatId", chatId).whereEqualTo("read", false).get();

        try {
            List<QueryDocumentSnapshot> documents = future.get().getDocuments();
            for (QueryDocumentSnapshot document : documents) {
                messages.add(document.toObject(Message.class));
            }
        } catch (InterruptedException | ExecutionException e) {
            e.printStackTrace();
        }

        return messages;
    }
    public List<Chat> getChatsForParticipant(Long participantId) {
        List<Chat> chats = new ArrayList<>();
        try {
            ApiFuture<QuerySnapshot> query1 = firestore.collection("chats")
                    .whereEqualTo("participantId1", participantId).get();
            ApiFuture<QuerySnapshot> query2 = firestore.collection("chats")
                    .whereEqualTo("participantId2", participantId).get();

            List<QueryDocumentSnapshot> documents1 = query1.get().getDocuments();
            List<QueryDocumentSnapshot> documents2 = query2.get().getDocuments();

            for (QueryDocumentSnapshot document : documents1) {
                chats.add(document.toObject(Chat.class));
            }
            for (QueryDocumentSnapshot document : documents2) {
                chats.add(document.toObject(Chat.class));
            }

        } catch (InterruptedException | ExecutionException e) {
            e.printStackTrace();
        }
        return chats;
    }



}

