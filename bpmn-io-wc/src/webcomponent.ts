import {default as BpmnViewerInternal} from 'bpmn-js/lib/NavigatedViewer';
import {default as OutlineModule} from 'bpmn-js/lib/features/outline/index';
// @ts-ignore temporary should load the bpmn from remote
import bpmnText from 'bundle-text:../../examples/test.bpmn';
import {default as Canvas} from "diagram-js/lib/core/Canvas";
import {default as Overlays} from 'diagram-js/lib/features/overlays/Overlays';

export class BpmnIOIntegrationElement extends HTMLElement {

    bpmn: BpmnViewerInternal;
    hookNode: HTMLDivElement;
    _width: string;
    _height: string;

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
        const status = {
            name: 'Do_Something_Activity',
            errorCount: 1,
            runningInstances: 1
        } as ActivityStatus;
        this.bpmn.importXML(bpmnText)
            .then(_ => this.canvas.zoom('fit-viewport'))
            .then(_ => this.addProcessInstanceOverlays(status))
            .then(_ => this.removeBPMNTrademark())
    }

    addProcessInstanceOverlays(activity: ActivityStatus) {
        this.overlays.add(activity.name, 'process_instances_indicator', {
            position: {
                top: 70,
                left: 70
            },
            html: `<div class="process-instance-count"><p>${activity.runningInstances}</p><p>${activity.errorCount}</p></div>`
        })
    }

    get overlays() {
        return this.bpmn.get<Overlays>("overlays");
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
}

interface ActivityStatus {
    name: string,
    errorCount: number,
    runningInstances: number,
}

export const wc_id = "bpmn-io-wc";