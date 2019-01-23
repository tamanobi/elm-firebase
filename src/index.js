"use strict";

require("./styles.scss");
import firebase from "firebase";
import {database} from "firebase";
import { Elm } from "./Main.elm"

const config = {
    apiKey: "AIzaSyACX0QhAMqmrn7ZrPAwbr4TkXw9kaScgzI",
    authDomain: "elm-test-47075.firebaseapp.com",
    databaseURL: "https://elm-test-47075.firebaseio.com",
    projectId: "elm-test-47075",
    storageBucket: "elm-test-47075.appspot.com",
    messagingSenderId: "318652114360"
};
firebase.initializeApp(config)

const app = Elm.Main.init()

app.ports.save.subscribe(doc => {
    const db = database()
    db.ref('user').set(doc)
})