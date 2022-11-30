import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';


admin.initializeApp();

const messagingAdmin = admin.messaging();
const db = admin.firestore()

export const newFollow = functions.firestore
    .document('follows/{followId}')
    .onCreate(async snapshot => {
        var followerName = 'Someone';
        const followData = snapshot.data()
        const followingId = followData.followingId;

        console.log('followData.followingId', followData.followingId);
        const userQuerySnapshot = await db
            .collection('users')
            .doc(followingId)
            .get();

        const userDocRef = userQuerySnapshot.ref;
        const tokensQuerySnapshot = await userDocRef.collection('tokens').orderBy('updated', 'desc').get();
        const tokens = tokensQuerySnapshot.docs.map((snap) => snap.id);
        const payload = {
            notification: {
                title: `${followerName} requested to follow you!`,
                icon: 'your-icon-url',
                click_action: 'FLUTTER_NOTIFICATION_CLICK'
            }
        };
        console.log('tokens', tokens)
        await messagingAdmin.sendToDevice(tokens[0], payload).then((response) => {
            console.log('Successfully sent message:', response);
            console.log('Message', response.results[0].error?.message);
        })
        .catch((error) => {
            console.log('Error sending message:', error);
        });
        return null;

    });
