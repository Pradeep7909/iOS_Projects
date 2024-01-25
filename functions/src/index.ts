import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();

// Cloud Function to be triggered when a new chat is added
export const onNewChatAdded = functions.database
  .ref("/allChat/{chatId}/{messageId}")
  .onCreate(async (snapshot, context) => {
    // const chatId = context.params.chatId;
    // const messageId = context.params.messageId;

    // Get the data of the new chat message
    const messageData = snapshot.val();

    // Extract necessary information (e.g., sender, receiver, etc.)
    // const senderUid = messageData.senderId;
    const receiverUid = messageData.receiverId;

    // Check if the receiver is offline (you need to implement this logic)
    const isReceiverOffline = await checkUserOffline(receiverUid);

    if (isReceiverOffline) {
      // The receiver is offline, send a notification

      // Retrieve the FCM token of the receiver from the database
      const receiverFcmToken = await getFcmToken(receiverUid);

      // Send the notification
      if (receiverFcmToken !== null) {
        await sendNotification(receiverFcmToken, "New Chat", "You have a msg");
      } else {
        console.log("Receiver FCM token is null. Notification not sent.");
      }
    }
  });

/**
 * Function to check if a user is offline
 * @param {string} uid - The UID of the user
 * @return {Promise<boolean>} - Returns true if the user is offline
 */
async function checkUserOffline(uid: string): Promise<boolean> {
  try {
    const userSnapshot = await admin
      .database()
      .ref("/users/${uid}").once("value");
    if (userSnapshot.exists()) {
      const userData = userSnapshot.val();
      // Assume that the user is offline if isOnline  set to true
      return userData.isOnline !== true;
    } else {
      // User not found, consider offline
      return true;
    }
  } catch (error) {
    console.error("Error checking user online status:", error);
    // Handle the error accordingly, e.g., return true or false
    return true;
  }
}

/**
 * Function to retrieve the FCM token of a user from the database
 * @param {string} uid - The UID of the user
 * @return {Promise<string | null>} - Returns the FCM token or null if not found
 */
async function getFcmToken(uid: string): Promise<string | null> {
  try {
    const userSnapshot = await admin
      .database()
      .ref(`/users/${uid}`)
      .once("value");
    if (userSnapshot.exists()) {
      const userData = userSnapshot.val();
      return userData.fcmToken || null;
    } else {
      // User not found, return null
      return null;
    }
  } catch (error) {
    console.error("Error retrieving user FCM token:", error);
    // Handle the error accordingly, e.g., return null or a default FCM token
    return null;
  }
}

/**
 * Function to send a notification using FCM
 * @param {string} token - The FCM token of the recipient
 * @param {string} title - The title of the notification
 * @param {string} body - The body of the notification
 * @return {Promise<void>}
 */
async function sendNotification(
  token: string,
  title: string,
  body: string
): Promise<void> {
  try {
    const message = {
      token: token,
      notification: {
        title: title,
        body: body,
      },
    };

    await admin.messaging().send(message);

    console.log("Notification sent successfully");
  } catch (error) {
    console.error("Error sending notification:", error);
    // Handle the error accordingly based on your use case
  }
}

