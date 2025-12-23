import { BpmnIOIntegrationElement } from './webcomponent';


export function registerWebcomponent() {
    if(!customElements.get("bpmn-io-wc")) {
        customElements.define("bpmn-io-wc", BpmnIOIntegrationElement)
    }
}
