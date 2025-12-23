import {default as BpmnViewerInternal} from 'bpmn-js/lib/NavigatedViewer';
import {default as OutlineModule} from 'bpmn-js/lib/features/outline/index';
// @ts-ignore temporary should load the bpmn from remote
import bpmnText from 'bundle-text:../../examples/test.bpmn';

export class BpmnIOIntegrationElement extends HTMLElement {

    bpmn: BpmnViewerInternal;
    hookNode: HTMLDivElement;

    connectedCallback() {
        this.hookNode = this.appendChild(this.createHookNode())
        this.bpmn = new BpmnViewerInternal({
            container: "#bpmn-io-wc",
            height: 600,
            width: 1000,
            additionalModules: [OutlineModule]
        })
        this.bpmn.importXML(bpmnText)
            .then(_ => this.bpmn.get('canvas').zoom('fit-viewport'))
            .then(value => this.removeBPMNTrademark())
    }

    removeBPMNTrademark() {
        const element = this.getElementsByClassName("bjs-powered-by").item(0)
        if (element) {
            element.remove();
        }
    }

    createHookNode(): HTMLDivElement {
        const div = document.createElement("div");
        div.className = "canvas";
        div.id = "bpmn-io-wc"
        return div;
    }

    disconnectedCallback() {
        this.hookNode.remove()
    }
}