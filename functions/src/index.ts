import * as admin from 'firebase-admin';
// import { initializeApp } from 'firebase-admin/app';
import * as functions from 'firebase-functions';


admin.initializeApp();

const messagingAdmin = admin.messaging();
// const db = FirebaseFirestore.
// export const db = getFirestore(app);
const db = admin.firestore()

export const newFollow = functions.firestore
    .document('follows/{followId}')
    .onCreate(async snapshot => {
        var followerName = 'Someone';
        const followData = snapshot.data()
        const followingId = followData.followingId;
        // const followerId = followData.followerId;

        console.log('followData.followingId', followData.followingId);
        const userQuerySnapshot = await db
            .collection('users')
            .doc(followingId)
            .get();



        // const userDocSnapshot = userQuerySnapshot.; // Assumption: there is only ONE user with this email
        const userDocRef = userQuerySnapshot.ref;
        const tokensQuerySnapshot = await userDocRef.collection('tokens').get();

        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        const tokens = tokensQuerySnapshot.docs.map((snap: { id: any; }) => snap.id);

        // await db
        //     .collection('users')
        //     .doc(followerId)
        //     .get().then((user) => {
        //         if (user.exists) {
        //             followerName = user.data()?.username;
        //         }
        //     });
        const payload: admin.messaging.MessagingPayload = {
            notification: {
                title: `${followerName} requested to follow you!`,
                // body: 'new notification',
                icon: 'your-icon-url',
                click_action: 'FLUTTER_NOTIFICATION_CLICK'
            }
        };

        await messagingAdmin.sendToDevice(tokens, payload);
        return null;

    });
