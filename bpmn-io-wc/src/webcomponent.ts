import {default as BpmnViewerInternal} from 'bpmn-js/lib/NavigatedViewer';
import {default as OutlineModule} from 'bpmn-js/lib/features/outline/index';
// @ts-ignore temporary should load the bpmn from remote
import bpmnText from 'bundle-text:../../examples/test.bpmn';
import {default as Canvas} from "diagram-js/lib/core/Canvas";
import {default as Overlays} from 'diagram-js/lib/features/overlays/Overlays';
import {default as EventBus} from 'diagram-js/lib/core/EventBus';

export class BpmnIOIntegrationElement extends HTMLElement implements WebComponent {

    bpmn: BpmnViewerInternal;
    hookNode: HTMLDivElement;
    _width: string;
    _height: string;
    _status: ActivityStatus[] = [];
    _initialized: boolean;

    readonly trademark_id = "bjs-powered-by";

    connectedCallback() {
        this.hookNode = this.appendChild(this.createHookNode())
        this.initBpmnViewer()
    }

    initBpmnViewer() {
        this.bpmn = new BpmnViewerInternal({
            container: `#${wc_id}`,
            height: this._height,
            width: this._width,
            additionalModules: [OutlineModule]
        })
        this.importXml();
    }

    importXml() {
        this.bpmn.importXML(bpmnText)
            .then(_ => this._initialized = true)
            .then(_ => this.canvas.zoom('fit-viewport'))
            .then(_ => this.removeBPMNTrademark())
            .then(_ => this.addProcessInstanceOverlays())
            .then(_ => this.registerEvents())
    }

    addProcessInstanceOverlays() {
        const overlays = this.overlays;
        for (const activity of this._status) {
            overlays.remove({element: activity.name});
            overlays.add(activity.name, 'process_instances_indicator', {
                position: {
                    top: 70,
                    left: 70
                },
                html: `<div class="process-instance-count"><p>${activity.instances}</p><p>${activity.errors}</p></div>`
            })
        }
    }

    registerEvents() {
        this.eventBus.on("element.click", (event) => {
            console.log(event)
            this.dispatchEvent(new CustomEvent('bpmnClick', {detail: event}))
        })
    }

    get overlays() {
        return this.bpmn.get<Overlays>("overlays");
    }

    get eventBus() {
        return this.bpmn.get<EventBus>('eventBus');
    }

    get canvas() {
        return this.bpmn.get<Canvas>('canvas');
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

    set width(value: string) {
        this._width = value;
    }

    set height(value: string) {
        this._height = value;
    }

    set activity_status(value: ActivityStatus[]) {
        this._status = value ?? [];
        if (this._initialized) {
            this.addProcessInstanceOverlays()
        }
    }
}

interface WebComponent {
    disconnectedCallback: () => void,
    connectedCallback: () => void
    width: string
    height: string
    activity_status: ActivityStatus[]
}

interface ActivityStatus {
    name: string,
    errors: number,
    instances: number,
}

export const wc_id = "bpmn-io-wc";