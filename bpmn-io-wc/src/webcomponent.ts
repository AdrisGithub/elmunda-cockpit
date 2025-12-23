import {default as BpmnViewerInternal} from 'bpmn-js/lib/NavigatedViewer';
import {default as OutlineModule} from 'bpmn-js/lib/features/outline/index';
// @ts-ignore temporary should load the bpmn from remote
import bpmnText from 'bundle-text:../../examples/test.bpmn';
import {Canvas} from "bpmn-js/lib/features/context-pad/ContextPadProvider";

export class BpmnIOIntegrationElement extends HTMLElement {

    bpmn: BpmnViewerInternal;
    hookNode: HTMLDivElement;

    readonly trademark_id = "bjs-powered-by";

    connectedCallback() {
        this.hookNode = this.appendChild(this.createHookNode())
        this.bpmn = new BpmnViewerInternal({
            container: `#${wc_id}`,
            height: 600,
            width: 1000,
            additionalModules: [OutlineModule]
        })
        this.bpmn.importXML(bpmnText)
            .then(_ => this.bpmn.get<Canvas>('canvas').zoom('fit-viewport'))
            .then(value => this.removeBPMNTrademark())
    }

    removeBPMNTrademark() {
        const element = this.getElementsByClassName(this.trademark_id).item(0)
        if (element) {
            element.remove();
        }
    }

    createHookNode(): HTMLDivElement {
        const div = document.createElement("div");
        div.id = wc_id;
        return div;
    }

    disconnectedCallback() {
        this.hookNode.remove()
    }
}

export const wc_id = "bpmn-io-wc";