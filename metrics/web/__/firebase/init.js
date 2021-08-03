// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

if (typeof firebase === 'undefined') throw new Error('hosting/init-error: Firebase SDK not detected. You must include it before /__/firebase/init.js');

firebase.initializeApp({
    apiKey: "AIzaSyA9bMhMyKLVzqsiRkjSNwkpDflskYtfvhc",
    authDomain: "metrics-varim.firebaseapp.com",
    projectId: "metrics-varim",
    storageBucket: "metrics-varim.appspot.com",
    messagingSenderId: "517259371361",
    appId: "1:517259371361:web:0eec124f11f383fab9db20",
    measurementId: "G-SFWJKD17Z9"
});
