"use strict";




const CONFIG = {
    q_EImu2EB: unitQuatWXYZ([1,-1,0,0]), // -90° in x direction to make z vertical
    //q_Imu2Box: unitQuatWXYZ([0,0,1,1]), // Musclelab
    q_Imu2Box: unitQuatWXYZ([0.5,0.5,0.5,0.5]), // XSens
    // q_Bone2ISB_U: unitQuatWXYZ([1,0,0,0]),
    // q_Bone2ISB_U: unitQuatWXYZ([0,1,0,1]), // for Arne's arms, Quaternion.fromAxes(x=[0,0,0],y=[0,-1,0],z=[1,0,0])
    q_Bone2ISB_U: unitQuatWXYZ([0,1,0,1]), // for Eric's human, Quaternion.fromAxes(x=[0,0,0],y=[0,-1,0],z=[1,0,0])
    // q_Bone2ISB_F: unitQuatWXYZ([1,0,0,0]),
    // q_Bone2ISB_F: unitQuatWXYZ([0,-1,0,1]), // for Arne's arms, Quaternion.fromAxes(x=[0,0,0],y=[0,-1,0],z=[0,0,1])
    q_Bone2ISB_F: unitQuatWXYZ([0,0,0,1]), // for Eric's human, Quaternion.fromAxes(x=[0,0,0],y=[0,-1,0],z=[1,0,0])
};



const GROUND_LEVEL = -130;
const SCALE = 50;
const OFFSET_Z = -5;
const REF_ALPHA = 0.5;
const REF_COLOR = COLORS.orange;

function quatRotate(quat, vecXYZ) {
    const qVec = new BABYLON.Quaternion(vecXYZ[0], vecXYZ[1], vecXYZ[2], 0);
    const qVecRot = quat.multiply(qVec).multiply(quat.conjugate());
    if (Math.abs(qVecRot.w) > 0.001)
        console.log(qVecRot);
    return [qVecRot.x, qVecRot.y, qVecRot.z];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////  WEBSOCKET BACKEND                                                                                             ////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class DataSource {
    constructor(url) {
        this.url = url;
        this.open = false;
        this.sendQueue = [];
        this.sinks = [];
        this.parameters = [];

        this.openSocket();
    }

    openSocket() {
        this.socket = new WebSocket(this.url);
        if (!this.socket) {
            alert('Opening WebSocket failed!');
        }

        this.socket.onopen = this.onOpen.bind(this);
        this.socket.onmessage = this.onMessage.bind(this);
        this.socket.onerror = this.onError.bind(this);
        this.socket.onclose = this.onClose.bind(this);
    }

    // sendCommand(block, command) {
    //     const message = JSON.stringify([block, command]);
    //     if (!this.open) {
    //         this.sendQueue.push(message);
    //     } else {
    //         this.socket.send(message);
    //     }
    // }

    addSink(sink) {
        this.sinks.push(sink);
    }

    onOpen(open) {
        console.log("WebSocket has been opened", open, this);
        this.open = true;
        for (let message of this.sendQueue) {
            this.socket.send(message);
        }
        this.sendQueue = [];
    };

    onMessage(message) {
        this.lastSample = this.processSample(JSON.parse(message.data));

        this.lastSample.pos_x = this.lastSample.pos[0];
        this.lastSample.pos_y = this.lastSample.pos[1];
        this.lastSample.pos_z = this.lastSample.pos[2];

        this.lastSample.pos_ref_x = this.lastSample.pos_ref[0];
        this.lastSample.pos_ref_y = this.lastSample.pos_ref[1];
        this.lastSample.pos_ref_z = this.lastSample.pos_ref[2];

        for (let sink of this.sinks) {
            sink.addSample(this.lastSample);
        }

        let params = {};
        for (let entry of this.parameters) {
            const object = entry[0];
            const propertyName = entry[1];
            const parameterName = entry[2];
            params[parameterName] = object[propertyName];
        }
        this.lastParams = params;
        // console.log(JSON.stringify(params));
        this.socket.send(JSON.stringify(params));
    }

    onError(error) {
        console.log("WebSocket error:", error, this);
    }

    onClose(close) {
        console.log("WebSocket has been closed", close, this);
        this.open = false;

        this.openSocket();
    }

    addParameter(object, propertyName, parameterName) {
        this.parameters.push([object, propertyName, parameterName]);
    }

    processSample(sample) {
        return sample;
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////  BABYLON 3D RENDERING                                                                                          ////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////  DEFINITION OF USER INTERFACE ELEMENTS                                                                         ////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////  CREATE CLASSES                                                                                                ////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// MODIFY SAMPLE (e.g. add new signal or modify incoming data)
// NOTE THAT THE CODE THAT MOVES THE DRONE ALSO GETS THE MODIFIED DATA!
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// dataSource.processSample = function(sample) {
//     sample['zero'] = 0.0;
//     if (mainScene.drone.crashed) {
//         const dronePos = mainScene.drone.obj.position;
//         sample['realpos'] = [-dronePos.z/SCALE, -dronePos.x/SCALE, (dronePos.y-OFFSET_Z)/SCALE];
//     } else {
//         sample['realpos'] = sample['pos'];
//     }
//     sample['crashed'] = 2*mainScene.drone.crashed - 1;
//     return sample;
// };

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// PLOTS AND CONTROLS
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


// LinePlot parameters: id, container, width, height, signals, labels, colors, ylim
// id: must be a unique html element id
// container: "sidebar" or "advanced"
// signals: for vectors, use "vec#0" to access the first element etc.
//
// to change plot style:
// search for "this.chart = new SmoothieChart({" in the code and look at http://smoothiecharts.org/builder/
//
// nice line colors: http://matplotlib.org/2.0.0/users/dflt_style_changes.html#colors-color-cycles-and-color-maps

// Checkbox parameters: id, container, text, checked
// The "checked" property of the checkbox is 1/true if the checkbox is checked and 0/false if not.

// ToggleButton parameters: id, container, text
// The "value" property of the button changes from 0 to 1 and vice versa.

// Dropdown parameters: id, container, options, initialValue
// The "value" property of the dropdown is the selected index, starting with 0.

// insertHtml can be used to inject arbitrary html (e.g. headings or <br>).

//insertHtml('sidebar', '<h4>Settings</h4>');

//const testCheckbox = new Checkbox('testcheckbox', 'sidebar', 'test checkbox', true);
//dataSource.addParameter(testCheckbox, 'checked', 'testcheckbox');
//
// insertHtml('sidebar', '<br>');
//
// const testButton = new ToggleButton('resetbutton', 'sidebar', 'Reset');
// dataSource.addParameter(testButton, 'value', 'reset');
//
// insertHtml('sidebar', '<br>');
//
// const testDropdown = new Dropdown('testdropdown', 'sidebar', ['both QC react equally (1 IMU)', 'QC2 reacts stronger (1 IMU)', 'QC2 reacts faster (1 IMU)', 'y of QC1 stronger – y of QC2 faster'], 0);
// dataSource.addParameter(testDropdown, 'value', 'mode');
//
// //insertHtml('sidebar', '<h4>Plots</h4>');
// insertHtml('sidebar', '<br>');
//
// //const posPitchPlot = new LinePlot('AnglesPlot', 'sidebar', 500, 250, ['angles_ref#0', 'angles_ref#1', 'angles#0', 'angles#1'], ['pitch-1','roll-1','pitch-2','roll-2'], ['#1f77b4', '#2ca02c', '#000000','#ff0000'], [-0.5, 0.5]);
// //dataSource.addSink(AnglesPlot);
//
// const posXPlot = new LinePlot('posXPlot', 'sidebar', 500, 250, ['pos_ref#0', 'pos#0'], ['pos-1-x', 'pos-2-x'], ['#1f77b4', '#2ca02c'], [-1, 1]);
// dataSource.addSink(posXPlot);
//
// const posZPlot = new LinePlot('posZPlot', 'sidebar', 500, 250, ['pos_ref#1', 'pos#1'], ['pos-1-y', 'pos-2-y'], ['#1f77b4', '#2ca02c'], [-1, 1]);
// dataSource.addSink(posZPlot);
//





