const admin = require('firebase-admin');
const SERVICE_ACCOUNT_KEY_PATH = process.env.SERVICE_ACCOUNT_KEY_PATH;
const serviceAccount = require(SERVICE_ACCOUNT_KEY_PATH);

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();

var projects = [
    {
        "name": "Project 1",
    },
    {
        "name": "Project 2",
    }
]

projects.forEach(function (obj) {
    db.collection("projects").add({
        name: obj.name,
    }).then(function (docRef) {
        console.log("Document written with ID: ", docRef.id);
    })
        .catch(function (error) {
            console.error("Error adding document: ", error);
        });
});
