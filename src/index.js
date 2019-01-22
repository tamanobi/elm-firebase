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
var app = Elm.Main.init({ flags: 6 });

app.ports.toJs.subscribe(data => {
    console.log(data)
});

// Use ES2015 syntax and let Babel compile it for you
var testFn = inp => {
    let a = inp + 1
    return a
}

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