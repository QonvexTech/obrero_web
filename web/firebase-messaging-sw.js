importScripts('https://www.gstatic.com/firebasejs/8.2.10/firebase-app.js');
importScripts('https://www.gstatic.com/firebasejs/8.2.10/firebase-messaging.js');
importScripts('https://www.gstatic.com/firebasejs/8.2.10/firebase-firestore.js');

firebase.initializeApp({
     apiKey: "AIzaSyC8f6R5OPRRCXHmHCi2bZ30fTn04okdFoI",
     authDomain: "obrero.firebaseapp.com",
     projectId: "obrero",
     storageBucket: "obrero.appspot.com",
     messagingSenderId: "1074033755188",
     appId: "1:1074033755188:web:640bdcefa3db86b8613661",
     measurementId: "G-YQRRGCF8WR"
});

if (firebase.messaging.isSupported()){
	const messaging = firebase.messaging();
	messaging.usePublicVapidKey("BNL0PFNdVX9Io5bSuXde__RrOLib39TqyW-6h_ubUHq7gYFbswQaH_T7ZG3MmmO2P5m18Gw4T9n3cYPHGbS1hSM");
}