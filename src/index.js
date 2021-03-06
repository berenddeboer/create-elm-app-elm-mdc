"use strict";

import "../scss/main.scss";
import "../elm-mdc/src/elm-mdc.js"

import { Elm } from "../elm/Main.elm";
import * as serviceWorker from "./serviceWorker";

var loadjs = require('loadjs')

loadjs(["css!https://fonts.googleapis.com/icon?family=Material+Icons"], {
  success: function () {
    // Initialise Elm
    const flags = null
    Elm.Main.init({node: document.getElementById("root"), flags: flags})
  }
})

// If you want your app to work offline and load faster, you can change
// unregister() to register() below. Note this comes with some pitfalls.
// Learn more about service workers: https://bit.ly/CRA-PWA
//serviceWorker.unregister();
