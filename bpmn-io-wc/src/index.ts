import { BpmnIOIntegrationElement } from './webcomponent';

import '../../node_modules/bpmn-js/dist/assets/bpmn-js.css';
import '../../node_modules/bpmn-js/dist/assets/diagram-js.css';

export function registerWebcomponent() {
    if(!customElements.get("bpmn-io-wc")) {
        customElements.define("bpmn-io-wc", BpmnIOIntegrationElement)
    }
}
