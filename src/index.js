"use strict";

require("./styles.scss");
import firebase from "firebase";
import { database, auth } from "firebase";
import { Elm } from "./Main.elm";

const config = {
    apiKey: "AIzaSyC7MbJsJWWvVU1mqHmnluEO3aYdy04-5Ms",
    authDomain: "elm-test-8d9a1.firebaseapp.com",
    databaseURL: "https://elm-test-8d9a1.firebaseio.com",
    projectId: "elm-test-8d9a1",
    storageBucket: "",
    messagingSenderId: "969408579913"
};
firebase.initializeApp(config);

const app = Elm.Main.init();

app.ports.save.subscribe(doc => {
    const db = database();
    db.ref("user").set(doc);
});

app.ports.login.subscribe(model => {
    const provider = new auth.GoogleAuthProvider();
    auth()
        .signInWithPopup(provider)
        .then(result => {
            // This gives you a Google Access Token. You can use it to access the Google API.
            var token = result.credential.accessToken;
            console.log("token", token);
            // The signed-in user info.
            var user = result.user;
            app.ports.loginUser.send(JSON.stringify(user));
        })
        .catch(error => {
            // Handle Errors here.
            var errorCode = error.code;
            var errorMessage = error.message;
            // The email of the user's account used.
            var email = error.email;
            // The firebase.auth.AuthCredential type that was used.
            var credential = error.credential;
            // ...
        });
});
