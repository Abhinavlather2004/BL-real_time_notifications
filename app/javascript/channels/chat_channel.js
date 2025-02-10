// import consumer from "./consumer";

// const chatChannel = consumer.subscriptions.create("chatChannel", {
//   connected() {
//     console.log("connected");
//   },
//   received(data){
//     console.log("data is received", data.content);
//   },
// });
// export default chatChannel;

import { createConsumer } from "@rails/actioncable";

const consumer = createConsumer("ws://localhost:3000/cable");

const chatChannel = (userId) => {
  return consumer.subscriptions.create(
    { channel: "ChatChannel", user_id: userId },
    {
      connected() {
        console.log(`Connected to ChatChannel for user ${userId}`);
      },
      received(data) {
        console.log("New message received:", data.message);
        
        // Show browser notification
        if (Notification.permission === "granted") {
          new Notification(`New message from ${data.sender}`, {
            body: data.message,
          });
        }
      }
    }
  );
};

// Request notification permission
if (Notification.permission !== "granted") {
  Notification.requestPermission();
}

export default chatChannel;

