import {Elm} from "../src/Main.elm";
import {registerWebcomponent} from 'bpmn-io-wc';
import './styles.css';

registerWebcomponent();

let darkMode = false;

if (window.matchMedia) {
    darkMode = window.matchMedia('(prefers-color-scheme: dark)').matches
}

Elm.Main.init({
    node: document.getElementById("root"),
    flags: {
        apiUrl: "http://localhost:8080/",
        darkMode
    }
});