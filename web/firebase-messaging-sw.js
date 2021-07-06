importScripts('https://www.gstatic.com/firebasejs/8.2.10/firebase-app.js');
importScripts('https://www.gstatic.com/firebasejs/8.2.10/firebase-messaging.js');


firebase.initializeApp({
     apiKey: "AIzaSyC8f6R5OPRRCXHmHCi2bZ30fTn04okdFoI",
     authDomain: "obrero.firebaseapp.com",
     projectId: "obrero",
     storageBucket: "obrero.appspot.com",
     messagingSenderId: "1074033755188",
     appId: "1:1074033755188:web:640bdcefa3db86b8613661",
     measurementId: "G-YQRRGCF8WR"
});

const messaging = firebase.messaging();