import { Elm } from "../src/Main.elm";
import { registerWebcomponent } from 'bpmn-io-wc';

registerWebcomponent();

Elm.Main.init({ node: document.getElementById("root") });