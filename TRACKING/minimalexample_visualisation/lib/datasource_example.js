// const dataSource = new WebSocketDataSource("ws://localhost:30000/ws", {});
// const dataSource = new JsonDataSource("data.json");

"use strict";


class JsonDataSource {
    constructor(url) {
        this.sinks = [];

        $.getJSON(url, this.dataLoaded.bind(this));

        this.recording = false;
        this.socket = undefined;
        this.scene = undefined;
        this.camera = undefined;
        this.engine = undefined;
    }

    dataLoaded(data) {
        console.log('json loaded:', data)
        this.data = data;
        this.i = 0;
        this.sampleCount = this.data.t.length;
        setInterval(this.tick.bind(this), 10); // approx 100 Hz


        const ind = 300; // align heading based on this sample

        //const temp = new Quaternion(this.data["imu_quat_torso"][ind]).multiply(new Quaternion([0.5, -0.5, -0.5, -0.5])).multiply(new Quaternion(this.data["opt_quat_torso"][ind]).conj()).project([0,0,1]);
        this.heading_diff = 0;// temp[0];
        //this.heading_q =  temp[2];


        // create fake n_interp data if it doesn't exist
        if (this.data.n_interp_torso === undefined) {
            this.data.n_interp_torso = this.data.t.map(t => t % 2);
            this.data.n_interp_ua = this.data.t.map(t => t % 4);
            this.data.n_interp_fa = this.data.t.map(t => t % 6);
        }
    }

    addSink(sink) {
        this.sinks.push(sink);
    }

    tick() {
        if (this.recording) {
            this.recordSample();
            this.i+=1;
            if (this.i >= this.sampleCount) {
                this.socket.close();
                this.recording = false;
                console.log('recording done');
            }
        } else {
            this.sendSample();
            this.i+=1; // TODO!
        }
    }

    sendSample() {
        const ind = this.i % this.sampleCount;
        // console.log(quat)

        let sample = {
            ind: ind,
            length: this.sampleCount,
        };

        for (var key in this.data) {
            if (this.data[key].length === this.sampleCount) {
                sample[key] = this.data[key][ind];
            } else {
                sample[key] = this.data[key];
            }
        }

//             opt: {
//                 'side': 2, // 1: left, 2: right
//                 'quat_ua': this.data["opt_quat_ua"][ind],
//                 'quat_fa': this.data["opt_quat_fa"][ind],
//                 'quat_torso': this.data["opt_quat_torso"][ind],
//                 'earth_heading_offset': 0,
//             },
//             imu: {
//                 'side': 2, // 1: left, 2: right
// //                 'quat_ua': new Quaternion(this.data["quat_ua"][ind]).multiply(Quaternion.fromAngleAxis(Math.PI/2, [0,0,1])).multiply(Quaternion.fromAngleAxis(Math.PI/2, [0,1,0])).array,
// //                 'quat_fa': new Quaternion(this.data["quat_fa"][ind]).multiply(Quaternion.fromAngleAxis(Math.PI/2, [0,0,1])).multiply(Quaternion.fromAngleAxis(Math.PI/2, [0,1,0])).array,
// //                 'quat_hand': new Quaternion(this.data["quat_hand"][ind]).multiply(Quaternion.fromAngleAxis(Math.PI/2, [0,0,1])).multiply(Quaternion.fromAngleAxis(Math.PI/2, [0,1,0])).array,
// //                 'quat_torso': new Quaternion(this.data["quat_torso"][ind]).multiply(Quaternion.fromAngleAxis(Math.PI/2, [0,1,0])).array,
//                 'quat_ua': new Quaternion(this.data["quat_ua"][ind]).array,
//                 'quat_fa': new Quaternion(this.data["quat_fa"][ind]).array,
//                 'quat_hand': new Quaternion(this.data["quat_hand"][ind]).array,
//                 'quat_f2': new Quaternion(this.data["quat_f2"][ind]).array,
//                 'quat_clavicle': new Quaternion(this.data["quat_torso"][ind]).array,
//                 'earth_heading_offset': 0,
//             },
//             n_interp_torso: 0, //this.data.n_interp_torso[ind],
//             n_interp_ua: 0, //this.data.n_interp_ua[ind],
//             n_interp_fa: 0, //this.data.n_interp_fa[ind],
//         };
//
//         //sample.opt.earth_heading_offset = -120*Math.PI/180; // adjust to make the avatar face the camera
//         sample.imu.earth_heading_offset = 0; // sample.opt.earth_heading_offset + this.heading_diff;
//
//         sample.diff_angle_torso = 0; //2*Math.acos(Math.abs(new Quaternion(sample.imu.quat_torso).conj().multiply(this.heading_q.multiply(new Quaternion(sample.opt.quat_torso))).w));
//         sample.diff_angle_ua  = 0; //= 2*Math.acos(Math.abs(new Quaternion(sample.imu.quat_ua).conj().multiply(this.heading_q.multiply(new Quaternion(sample.opt.quat_ua))).w));
//         sample.diff_angle_fa  = 0; //= 2*Math.acos(Math.abs(new Quaternion(sample.imu.quat_fa).conj().multiply(this.heading_q.multiply(new Quaternion(sample.opt.quat_fa))).w));

        for (let sink of this.sinks) {
            sink.addSample(sample);
        }
    }

    addParameter(object, propertyName, parameterName) {
        // not implemented
    }

    recordVideo(scene, camera, engine) {
        this.socket = new WebSocket('ws://localhost:8765/ws');
        this.scene = scene;
        this.camera = camera;
        this.engine = engine;
        this.socket.onopen = function() {
            console.log('recording websocket onopen');
            this.i = 0;
            this.recording = true;
        }.bind(this);
        this.socket.onmessage = function() {
            console.log('recording websocket onmessage');
        };
        this.socket.onerror = function() {
            console.log('recording websocket onerror');
        };
        this.socket.onclose = function() {
            console.log('recording websocket onclose');
        };
    }

    recordSample() {
        const frameNum = this.i;
        const socket = this.socket;
        this.sendSample();
        this.scene.render();
        BABYLON.Tools.CreateScreenshotUsingRenderTarget(this.engine, this.camera, { width: 1920.0, height: 1080.0}, function(data) {
            socket.send(JSON.stringify([frameNum, data]));
        });
    }
}

