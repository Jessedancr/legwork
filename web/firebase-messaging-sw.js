importScripts(
  "https://www.gstatic.com/firebasejs/9.0.0/firebase-app-compat.js"
);
importScripts(
  "https://www.gstatic.com/firebasejs/9.0.0/firebase-messaging-compat.js"
);

// Initialize Firebase
firebase.initializeApp({
  apiKey: "AIzaSyAdI0ZfVQIkHgE8RJt_6zLyuPo2v8t3Ddo",
  authDomain: "legwork-jessedancr.firebaseapp.com",
  projectId: "legwork-jessedancr",
  storageBucket: "legwork-jessedancr",
  messagingSenderId: "725137144668",
  appId: "1:725137144668:web:9729962b4794b5770e1f99",
});

// Retrieve an instance of Firebase Messaging
const messaging = firebase.messaging();
