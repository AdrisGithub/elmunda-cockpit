import {Elm} from "../src/Main.elm";
import {registerWebcomponent} from 'bpmn-io-wc';
import './styles.css';

registerWebcomponent();

Elm.Main.init({
    node: document.getElementById("root"),
    flags: {
        apiUrl: "http://localhost:8080/"
    }
});