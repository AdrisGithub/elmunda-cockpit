import {BpmnIOIntegrationElement, wc_id} from './webcomponent';
import './styles.css'

export function registerWebcomponent() {
    if (!customElements.get(wc_id)) {
        customElements.define(wc_id, BpmnIOIntegrationElement)
    }
}
