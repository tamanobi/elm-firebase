"use strict";

require("./styles.scss");
import firebase from "firebase";

const config = {
    apiKey: "AIzaSyACX0QhAMqmrn7ZrPAwbr4TkXw9kaScgzI",
    authDomain: "elm-test-47075.firebaseapp.com",
    databaseURL: "https://elm-test-47075.firebaseio.com",
    projectId: "elm-test-47075",
    storageBucket: "elm-test-47075.appspot.com",
    messagingSenderId: "318652114360"
};
firebase.initializeApp(config);

const { Elm } = require("./Main");
var app = Elm.Main.init();

const docRef = firestore.collection("elm").doc("txt");
app.ports.toJs.subscribe(doc => {
  docRef.set({
    data: doc
  });
})

docRef.onSnapshot(doc => {
    app.ports.fromJs.send(doc.data().data)
}, error => {
    console.log(error)
})