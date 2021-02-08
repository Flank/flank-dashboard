// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

if (typeof firebase === 'undefined') throw new Error('hosting/init-error: Firebase SDK not detected. You must include it before /__/firebase/init.js');

firebase.initializeApp({
    apiKey: "AIzaSyCkM-7WEAb9GGCjKQNChi5MD2pqrcRanzo",
    authDomain: "metrics-d9c67.firebaseapp.com",
    databaseURL: "https://metrics-d9c67.firebaseio.com",
    projectId: "metrics-d9c67",
    storageBucket: "metrics-d9c67.appspot.com",
    messagingSenderId: "650500796855",
    appId: "1:650500796855:web:65a4615a28f3d88e8bb832",
    measurementId: "G-3DB4JFLKHQ"
});
