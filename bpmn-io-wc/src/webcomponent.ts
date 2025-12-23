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
    _count: number;
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
        const status = {
            name: 'Do_Something_Activity',
            errorCount: Math.round(this._count / 2),
            runningInstances: this._count
        } as ActivityStatus;
        this.bpmn.importXML(bpmnText)
            .then(_ => this.canvas.zoom('fit-viewport'))
            .then(_ => this.addProcessInstanceOverlays(status))
            .then(_ => this.removeBPMNTrademark())
            .then(_ => this._initialized = true)
    }

    addProcessInstanceOverlays(activity: ActivityStatus) {
        this.overlays.remove({element: activity.name});
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

    set count(value: number) {
        this._count = value;
        if (this._initialized) {
            const status = {
                name: 'Do_Something_Activity',
                errorCount: Math.round(value / 2),
                runningInstances: value
            } as ActivityStatus;
            this.addProcessInstanceOverlays(status)
        }
    }
}

interface ActivityStatus {
    name: string,
    errorCount: number,
    runningInstances: number,
}

export const wc_id = "bpmn-io-wc";