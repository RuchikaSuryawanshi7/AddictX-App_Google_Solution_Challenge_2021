const functions = require("firebase-functions");
const admin = require("firebase-admin");
const gcs = require('@google-cloud/storage');
admin.initializeApp();
const bucket = admin.storage().bucket();

exports.onCreateNotificationItem = functions.region('asia-south1').firestore
.document('/notifications/{userId}/notificationItems/{notificationItems}')
.onCreate(async (snapshot, context) =>
{
    const userId = context.params.userId;
    const userRef = admin.firestore().doc(`users/${userId}`);
    const doc = await userRef.get();


    const androidNotificationToken = doc.data().androidNotificationToken;
    const createNotificationItem = snapshot.data();

    if(androidNotificationToken)
    {
        sendNotification(androidNotificationToken, createNotificationItem);
    }
    else
    {
        console.log("No token for user, can not send notification.")
    }

    function sendNotification(androidNotificationToken, createNotificationItem)
    {
        let body;
        let url;

        switch (createNotificationItem.type)
        {
            case "commented on your post":
                body = `${createNotificationItem.username} replied: ${activityFeedItem.commentData}`;
                break;

            case "like problem":
                body = `${createNotificationItem.username} supported your problem`;
                break;

            case "like post":
                body = `${createNotificationItem.username} liked your post`;
                break;

            default:
            break;
        }
        url=`${createNotificationItem.userProfileImg}`;
        url=url==""?'https://drive.google.com/file/d/1WtZbQyNTFP1DoCNJWOZUfm3s9mcqfOLG/view?usp=sharing':url;
        const message =
        {
            notification: {
                            title:'AddictX',
                            body: body,
                            imageUrl: url,
                          },
            token: androidNotificationToken,
            data: { recipient: userId },
        };

        admin.messaging().send(message)
        .then(response =>
        {
            console.log("Successfully sent message", response);
        })
        .catch(error =>
        {
            console.log("Error sending message", error);
        })

    }
});

exports.onCreateMessage = functions.region('asia-south1').firestore
.document('/chatRoom/{chatRoomId}/chats/{chatItem}')
.onCreate(async (snapshot, context) =>
{
    const senderUserId = snapshot.data().sendBy;
    const chatItem = snapshot.data();

    const chatRoomRef = admin.firestore().doc(`chatRoom/${context.params.chatRoomId}`);
    const chatRoomDocument = await chatRoomRef.get();

    sendNotification(chatItem);

    async function sendNotification(chatItem)
        {
            let body;
            const ids=chatRoomDocument.data().ids;
            const messageRecieverId=senderUserId==ids[0]?ids[1]:ids[0];
            const recieverUserRef = admin.firestore().doc(`users/${messageRecieverId}`);
            const recieverDoc = await recieverUserRef.get();

            const androidNotificationToken = recieverDoc.data().androidNotificationToken;
            const tempUrl= chatRoomDocument.data().Avatar1==recieverDoc.data().url?chatRoomDocument.data().Avatar2:chatRoomDocument.data().Avatar1;
            const url=tempUrl==""?'https://firebasestorage.googleapis.com/v0/b/challenge-ada8a.appspot.com/o/AppRelatedData%2FNo%20dp.png?alt=media&token=cc22294c-88d2-4204-9249-b3c1e7ac3465':tempUrl;

            switch (chatItem.type)
            {
                case 0:
                    body = `${chatItem.senderUsername}: ${chatItem.message}`;
                    break;

                case 1:
                    body = `${chatItem.senderUsername}: shared a photo`;
                    break;

                default:
                break;
            }
            const message =
            {
                notification: {
                                title:'Message',
                                body: body,
                                imageUrl: url,
                              },
                token: androidNotificationToken,
                data: { recipient: senderUserId },
            };

            admin.messaging().send(message)
            .then(response =>
            {
                console.log("Successfully sent message", response);
            })
            .catch(error =>
            {
                console.log("Error sending message", error);
            })

        }
});