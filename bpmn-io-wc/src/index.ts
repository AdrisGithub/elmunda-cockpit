import { BpmnIOIntegrationElement } from './webcomponent';
import './styles.css'

export function registerWebcomponent() {
    if(!customElements.get("bpmn-io-wc")) {
        customElements.define("bpmn-io-wc", BpmnIOIntegrationElement)
    }
}
