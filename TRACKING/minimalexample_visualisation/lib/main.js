"use strict";

function unitQuatWXYZ(q) {
    return new BABYLON.Quaternion(q[1], q[2], q[3], q[0]).normalize();
}


const COLORS = {
    orange: new BABYLON.Color4(255/255, 127/255, 14/255, 1), // matplotlib C1
    darkgrey: new BABYLON.Color4(46/255, 52/255, 54/255, 1), // oxygen dark grey #2E3436
    grey: new BABYLON.Color4(136/255, 138/255, 133/255, 1), // oxygen grey #888A85
    lightgrey: new BABYLON.Color4(211/255, 215/255, 207/255, 1), // oxygen light grey #D3D7CF
    black: new BABYLON.Color4(0/255, 0/255, 0/255, 1),
    greengrey: new BABYLON.Color4(100/255, 120/255, 100/255, 1),
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

class Scene {
    constructor(id) {
        this.canvas = document.getElementById(id);
        this.engine = new BABYLON.Engine(this.canvas, true);
        this.scene = new BABYLON.Scene(this.engine);
        this.scene.useRightHandedSystem = true;
        this.engine.runRenderLoop(function(){
            this.scene.render();
        }.bind(this));
    }
}

class MainScene extends Scene {
    constructor(id) {
        super(id);
        this.createScene();
        window.addEventListener('resize', function() {
            this.engine.resize();
        }.bind(this));
    }

    createScene() {
        this.camera = new BABYLON.ArcRotateCamera("ArcRotateCamera", 0, 0.3, 100, new BABYLON.Vector3(0, 0, 0), this.scene);
        this.camera.attachControl(this.canvas, false);
        this.light = new BABYLON.HemisphericLight('light1', new BABYLON.Vector3(1,0,0), this.scene);
        this.light2 = new BABYLON.DirectionalLight("DirectionalLight", new BABYLON.Vector3(0, -0.1, 0.2), this.scene);

        // https://babylonjsguide.github.io/intermediate/Skybox
        const skybox = BABYLON.MeshBuilder.CreateBox("skyBox", {size:1000.0}, this.scene);
        const skyboxMaterial = new BABYLON.StandardMaterial("skyBox", this.scene);
        skyboxMaterial.backFaceCulling = false;
        skyboxMaterial.reflectionTexture = new BABYLON.CubeTexture("textures/skybox", this.scene);
        skyboxMaterial.reflectionTexture.coordinatesMode = BABYLON.Texture.SKYBOX_MODE;
        skyboxMaterial.diffuseColor = new BABYLON.Color3(0, 0, 0);
        skyboxMaterial.specularColor = new BABYLON.Color3(0, 0, 0);
        skybox.material = skyboxMaterial;

        this.ground = new Ground(this.scene);

        // pos_x, pos_y, dim_x, dim_y, height
        this.buildings = [  
            new Skyscraper(this.scene,-1.15 , 0, 0.7, 0.7, -0.5-0.3, new BABYLON.Color4(230/255, 220/255, 220/255, 1)),
            new Skyscraper(this.scene, 0.9, 0, 0.7, 0.7,  -0.35-0.3, new BABYLON.Color4(210/255, 220/255, 220/255, 1)),

            new Skyscraper(this.scene, -0.2, 0, 0.5, 0.5, -0.4-0.3, new BABYLON.Color4(220/255, 220/255, 220/255, 1)),
            new Skyscraper(this.scene, -0.2, 0, 0.4, 0.4, -0.3-0.3, new BABYLON.Color4(220/255, 220/255, 220/255, 1)),
            new Skyscraper(this.scene, -0.2, 0, 0.3, 0.3, -0.2-0.3, new BABYLON.Color4(220/255, 220/255, 220/255, 1)),
            new Skyscraper(this.scene, -0.2, 0, 0.2, 0.2, -0.1-0.3, new BABYLON.Color4(220/255, 220/255, 220/255, 1)),
            new Skyscraper(this.scene, -0.2, 0, 0.1, 0.1,    0-0.3, new BABYLON.Color4(220/255, 220/255, 220/255, 1)),

            new Skyscraper(this.scene,  0.2,  1.7,  0.6, 0.8  -0.4-0.3, new BABYLON.Color4(220/255, 200/255, 220/255, 1)),
            new Skyscraper(this.scene, 0.25,  0.0, 0.15, 0.3, -0.7-0.3, new BABYLON.Color4(220/255, 230/255, 220/255, 1)),
            new Skyscraper(this.scene, -0.3, -0.8,  0.4, 0.65,-0.5-0.3, new BABYLON.Color4(220/255, 220/255, 200/255, 1)),
            new Skyscraper(this.scene,  1.7, -0.2,  0.6, 0.52, 0.8-0.9, new BABYLON.Color4(220/255, 220/255, 230/255, 1)),
            new Skyscraper(this.scene,   -2, -0.4,  0.6, 0.6,  0.3-0.3, new BABYLON.Color4(220/255, 220/255, 220/255, 1)),

            new Skyscraper(this.scene,-0.45, 0.8, 0.6, 0.5,    0.1-0.5,  new BABYLON.Color4(220/255, 230/255, 200/255, 1)),
            new Skyscraper(this.scene, 0.44, 1.1, 0.5, 0.45, -0.18-0.5,  new BABYLON.Color4(220/255, 220/255, 230/255, 1)),
            new Skyscraper(this.scene, -1.4, 1.1, 0.5, 0.7,    0.1-0.5,  new BABYLON.Color4(210/255, 230/255, 230/255, 1)),
            new Skyscraper(this.scene,  1.5, 1.2, 0.5, 0.4,    0.3-0.5,  new BABYLON.Color4(220/255, 220/255, 220/255, 1)),
        ];

        this.obstacles = this.buildings.map(function(o) {return o.box;});
        this.obstacles.push(this.ground.obj);

        this.scene.enablePhysics(new BABYLON.Vector3(0,-2*9.81, 0), new BABYLON.OimoJSPlugin());
        for (let o of this.obstacles) {
            o.physicsImpostor = new BABYLON.PhysicsImpostor(o, BABYLON.PhysicsImpostor.BoxImpostor, { mass: 0, restitution: 0.5 }, this.scene);
        }

        //this.drone = new Drone(this.scene, false, this.obstacles);
        this.drone = new Drone(this.scene, false, []);
        this.droneRef = new Drone(this.scene, true, []);
    }

    addSample(sample) {
        this.drone.addSample(sample);
        this.droneRef.addSample(sample);
    }
}

class Ground {
    constructor(scene) {
        this.scene = scene;
        this.obj = BABYLON.Mesh.CreatePlane("ground", 350, scene);
        this.obj.position.y = GROUND_LEVEL;
        this.obj.rotation.x = Math.PI / 2;

        const materialPlane = new BABYLON.StandardMaterial("texturePlane", scene);
        materialPlane.diffuseColor = COLORS.greengrey;
        materialPlane.backFaceCulling = false;

        this.obj.material = materialPlane;
    }
}

class Skyscraper {
    constructor(scene, pos_x, pos_y, dim_x, dim_y, height, col) {
        this.scene = scene;

        pos_x = SCALE*pos_x;
        pos_y = SCALE*pos_y;
        dim_x = SCALE*dim_x;
        dim_y = SCALE*dim_y;
        height = SCALE*height - GROUND_LEVEL + OFFSET_Z - 2.5; // 2.5 is half of the uav height

        // const col = COLORS.lightgrey;
        const options = {
            width: dim_y,
            height: height,
            depth: dim_x,
            // faceColors: faceColors
            faceColors: [col, col, col, col, col, col]
        };
        this.box = BABYLON.MeshBuilder.CreateBox('box', options, scene);
        this.box.position.y = GROUND_LEVEL + height/2;
        this.box.position.x = -pos_y;
        this.box.position.z = -pos_x;
    }
}


class Drone {
    constructor(scene, ref, obstacles) {
        this.scene = scene;
        this.ref = ref;
        this.obstacles = obstacles;
        this.crashed = false;

        this.createDrone();
    }

    createDrone() {
        const scene = this.scene;

        this.bbox = BABYLON.MeshBuilder.CreateBox("bbox", {height: 3, width: 13, depth: 13}, scene);
        this.bbox.visibility = false;

        // center sphere
        //(name of the sphere, segments, diameter, scene)
        var sphere = BABYLON.Mesh.CreateSphere("sphere", 5.0, 5.0, scene);
        sphere.material = new BABYLON.StandardMaterial("texturespere", scene);
        sphere.material.diffuseColor = this.ref ? REF_COLOR : COLORS.grey;
        if (this.ref) {
            sphere.material.alpha = REF_ALPHA;
        }

        sphere.parent = this.bbox;

        //Creation of a cylinder
        //(name, height, diameter, tessellation, scene, updatable)
        //Balken
        var cylinderlu = BABYLON.Mesh.CreateCylinder("cylinderlu", 4, 0.4, 0.4, 30, 1, scene, false);
        cylinderlu.parent = sphere;

        var cylinderlo = BABYLON.Mesh.CreateCylinder("cylinderlu", 4, 0.4, 0.4, 30, 1, scene, false);
        cylinderlo.parent = sphere;

        var cylinderru = BABYLON.Mesh.CreateCylinder("cylinderlu", 4, 0.4, 0.4, 30, 1, scene, false);
        cylinderru.parent = sphere;

        var cylinderro = BABYLON.Mesh.CreateCylinder("cylinderlu", 4, 0.4, 0.4, 30, 1, scene, false);
        cylinderro.parent = sphere;

        //Propella
        var cylinderLU = BABYLON.Mesh.CreateCylinder("cylinderlu", 3, 3, 3, 6, 1, scene, false);
        cylinderLU.parent = sphere;

        var cylinderLO = BABYLON.Mesh.CreateCylinder("cylinderlu", 3, 3, 3, 6, 1, scene, false);
        cylinderLO.parent = sphere;

        var cylinderRU = BABYLON.Mesh.CreateCylinder("cylinderlu", 3, 3, 3, 6, 1, scene, false);
        cylinderRU.parent = sphere;

        var cylinderRO = BABYLON.Mesh.CreateCylinder("cylinderlu", 3, 3, 3, 6, 1, scene, false);
        cylinderRO.parent = sphere;


        // Creation of a torus
        // (name, diameter, thickness, tessellation, scene, updatable)
        var torus = BABYLON.Mesh.CreateTorus("torus", 5, 1, 10, scene, false);
        torus.parent = sphere;

        // var shadow = BABYLON.Mesh.CreateCylinder("cylinderT", 0.05, 5, 5, 32, 1, scene, false);
        // shadow.material = new BABYLON.StandardMaterial("texturespere", scene);
        // shadow.material.diffuseColor =  COLORS.black;
        // // shadow.material.diffuseTexture.hasAlpha = true;//Have an alpha
        // // shadow.material.diffuseTexture.alpha = 1;//Have an alpha
        // shadow.parent = sphere;
        // shadow.position.y = GROUND_LEVEL;


        // Moving elements
        sphere.position = new BABYLON.Vector3(0, 0, 0); // Using a vector
        cylinderlu.position = new BABYLON.Vector3(-3, 0, -3);
        cylinderlu.rotation.x = Math.PI/2;
        cylinderlu.rotation.y = Math.PI/4;
        cylinderLU.position = new BABYLON.Vector3(-5, 0, -5);

        cylinderlo.position = new BABYLON.Vector3(-3, 0, 3);
        cylinderlo.rotation.x = Math.PI/2;
        cylinderlo.rotation.y = -Math.PI/4;
        cylinderLO.position = new BABYLON.Vector3(-5, 0, 5);

        cylinderru.position = new BABYLON.Vector3(3, 0, -3);
        cylinderru.rotation.x = Math.PI/2;
        cylinderru.rotation.y = -Math.PI/4;
        cylinderRU.position = new BABYLON.Vector3(5, 0, -5);

        cylinderro.position = new BABYLON.Vector3(3, 0, 3);
        cylinderro.rotation.x = Math.PI/2;
        cylinderro.rotation.y = Math.PI/4;
        cylinderRO.position = new BABYLON.Vector3(5, 0, 5);

        const material = new BABYLON.StandardMaterial("texturespere", scene);
        material.diffuseColor = this.ref ? REF_COLOR : COLORS.grey;
        if (this.ref) {
            sphere.material.alpha = REF_ALPHA;
            material.alpha = REF_ALPHA;

            cylinderlu.material = material;
            cylinderlo.material = material;
            cylinderro.material = material;
            cylinderru.material = material;
            torus.material = material;
        }

        cylinderLU.material = material;
        cylinderLO.material = material;
        cylinderRO.material = material;
        cylinderRU.material = material;

        this.burningObjects = [sphere, cylinderLU, cylinderLO, cylinderRO, cylinderRU];
        this.burningProxies = [];
        for (let o of this.burningObjects) {
            const p = BABYLON.MeshBuilder.CreateBox("bbox", {height: 1, width: 1, depth: 1}, scene);
            p.visibility = false;
            this.burningProxies.push(p);
        }

        this.obj = this.bbox;

        if (!this.ref) {
            this.fire = [
                new Fire(this.burningProxies[0], this.scene, 3),
                new Fire(this.burningProxies[1], this.scene, 2),
                new Fire(this.burningProxies[2], this.scene, 2),
                new Fire(this.burningProxies[3], this.scene, 2),
                new Fire(this.burningProxies[4], this.scene, 2),
            ];
        }

        this.updateProxies();
    }


    addSample(sample) {
        const pos = this.ref ? sample.pos_ref : sample.pos;
        const quat = this.ref ? sample.quat_ref : sample.quat;

        if (this.crashed) {
            if(pos[0] === 0.0 && pos[1] == 0.0 && pos[2] === 0.0) {
                this.crashed = false;
                this.stopFire();
                this.bbox.physicsImpostor.dispose();

            }
        } else {
            const quatBabylon = [quat[0], -quat[2], quat[3], -quat[1]];

            const lastPos = this.obj.position;
            this.obj.position = new BABYLON.Vector3(-SCALE*pos[1], SCALE*pos[2]+OFFSET_Z, -SCALE*pos[0]);
            this.obj.rotationQuaternion = unitQuatWXYZ(quatBabylon);

            this.bbox.computeWorldMatrix(true);

            for (let o of this.obstacles) {
                const intersects = this.bbox.intersectsMesh(o, true);
                if (intersects) {
                    this.crashed = true;
                    this.startFire();
                    this.bbox.physicsImpostor = new BABYLON.PhysicsImpostor(this.bbox, BABYLON.PhysicsImpostor.BoxImpostor, { mass: 10, restitution: 0.5 }, this.scene);

                    const vel = this.obj.position.subtract(lastPos).scale(5);
                    this.bbox.physicsImpostor.setLinearVelocity(vel);
                    break; // only create one impostor!
                }
            }

        }
    }

    startFire() {
        this.fire.forEach(function(f) {f.start()});
    }

    stopFire() {
        this.fire.forEach(function(f) {f.stop()});
    }

    updateProxies() {
        for (let i=0; i<this.burningObjects.length; i++) {
            this.burningObjects[i].computeWorldMatrix(true);
            this.burningProxies[i].position = this.burningObjects[i].getAbsolutePosition();
        }
    }
}

class Fire {
    // http://www.html5gamedevs.com/topic/10471-fire-particles/?tab=comments#comment-61447
    // http://www.babylonjs-playground.com/#1DZUBR
    constructor (emitter, scene, scale) {
        //Smoke
        const smokeSystem = new BABYLON.ParticleSystem("particles", 1000, scene);
        smokeSystem.particleTexture = new BABYLON.Texture("lib/textures/flare.png", scene);
        smokeSystem.emitter = emitter; // the starting object, the emitter
        smokeSystem.minEmitBox = new BABYLON.Vector3(-scale*0.5, scale*0, -scale*0.5); // Starting all from
        smokeSystem.maxEmitBox = new BABYLON.Vector3(scale*0.5, scale*1, scale*0.5); // To...

        smokeSystem.color1 = new BABYLON.Color4(0.1, 0.1, 0.1, 1.0);
        smokeSystem.color2 = new BABYLON.Color4(0.1, 0.1, 0.1, 1.0);
        smokeSystem.colorDead = new BABYLON.Color4(0, 0, 0, 0.0);

        smokeSystem.minSize = scale*0.3;
        smokeSystem.maxSize = scale*1;

        smokeSystem.minLifeTime = 0.3;
        smokeSystem.maxLifeTime = 1.5;

        smokeSystem.emitRate = 350;

        // Blend mode : BLENDMODE_ONEONE, or BLENDMODE_STANDARD
        smokeSystem.blendMode = BABYLON.ParticleSystem.BLENDMODE_ONEONE;

        smokeSystem.gravity = new BABYLON.Vector3(0, 0, 0);

        smokeSystem.direction1 = new BABYLON.Vector3(-1.5, 8, -1.5).multiply(scale);
        smokeSystem.direction2 = new BABYLON.Vector3(1.5, 8, 1.5).multiply(scale);

        smokeSystem.minAngularSpeed = 0;
        smokeSystem.maxAngularSpeed = Math.PI;

        smokeSystem.minEmitPower = 0.5;
        smokeSystem.maxEmitPower = 1.5;
        smokeSystem.updateSpeed = 0.005;

        this.smokeSystem = smokeSystem;


        // Create a particle system
        const fireSystem = new BABYLON.ParticleSystem("particles", 2000, scene);

        //Texture of each particle
        fireSystem.particleTexture = new BABYLON.Texture("textures/flare.png", scene);

        // Where the particles come from
        fireSystem.emitter = emitter; // the starting object, the emitter
        fireSystem.minEmitBox = new BABYLON.Vector3(-scale*0.5, scale*0, -scale*0.5); // Starting all from
        fireSystem.maxEmitBox = new BABYLON.Vector3(scale*0.5, scale*1, scale*0.5); // To...

        // Colors of all particles
        fireSystem.color1 = new BABYLON.Color4(1, 0.5, 0, 1.0);
        fireSystem.color2 = new BABYLON.Color4(1, 0.5, 0, 1.0);
        fireSystem.colorDead = new BABYLON.Color4(0, 0, 0, 0.0);

        // Size of each particle (random between...
        fireSystem.minSize = scale*0.3;
        fireSystem.maxSize = scale*1;

        // Life time of each particle (random between...
        fireSystem.minLifeTime = 0.2;
        fireSystem.maxLifeTime = 0.4;

        // Emission rate
        fireSystem.emitRate = 600;

        // Blend mode : BLENDMODE_ONEONE, or BLENDMODE_STANDARD
        fireSystem.blendMode = BABYLON.ParticleSystem.BLENDMODE_ONEONE;

        // Set the gravity of all particles
        fireSystem.gravity = new BABYLON.Vector3(0, 0, 0);

        // Direction of each particle after it has been emitted
        fireSystem.direction1 = new BABYLON.Vector3(0, scale*4, 0);
        fireSystem.direction2 = new BABYLON.Vector3(0, scale*4, 0);

        // Angular speed, in radians
        fireSystem.minAngularSpeed = 0;
        fireSystem.maxAngularSpeed = Math.PI;

        // Speed
        fireSystem.minEmitPower = 1;
        fireSystem.maxEmitPower = 3;
        fireSystem.updateSpeed = 0.007;
        this.fireSystem = fireSystem;

    }

    start() {
        this.fireSystem.start();
        this.smokeSystem.start();
    }

    stop() {
        this.fireSystem.stop();
        this.smokeSystem.stop();
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////  DEFINITION OF USER INTERFACE ELEMENTS                                                                         ////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////




////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////  CREATE CLASSES                                                                                                ////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

const dataSource = new DataSource("ws://localhost:30000/ws");

const mainScene = new MainScene('renderCanvas');
dataSource.addSink(mainScene);

$('#debugLayerCheckbox').change(function() {
    if ($(this).prop('checked')) {
        mainScene.scene.debugLayer.show();
    } else {
        mainScene.scene.debugLayer.hide();
    }
});

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// MODIFY SAMPLE (e.g. add new signal or modify incoming data)
// NOTE THAT THE CODE THAT MOVES THE DRONE ALSO GETS THE MODIFIED DATA!
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

dataSource.processSample = function(sample) {
    sample['zero'] = 0.0;
    if (mainScene.drone.crashed) {
        const dronePos = mainScene.drone.obj.position;
        sample['realpos'] = [-dronePos.z/SCALE, -dronePos.x/SCALE, (dronePos.y-OFFSET_Z)/SCALE];
    } else {
        sample['realpos'] = sample['pos'];
    }
    sample['crashed'] = 2*mainScene.drone.crashed - 1;
    return sample;
};

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

insertHtml('sidebar', '<br>');

const testButton = new ToggleButton('resetbutton', 'sidebar', 'Reset');
dataSource.addParameter(testButton, 'value', 'reset');

insertHtml('sidebar', '<br>');

const testDropdown = new Dropdown('testdropdown', 'sidebar', ['both QC react equally (1 IMU)', 'QC2 reacts stronger (1 IMU)', 'QC2 reacts faster (1 IMU)', 'y of QC1 stronger – y of QC2 faster'], 0);
dataSource.addParameter(testDropdown, 'value', 'mode');

//insertHtml('sidebar', '<h4>Plots</h4>');
insertHtml('sidebar', '<br>');

//const posPitchPlot = new LinePlot('AnglesPlot', 'sidebar', 500, 250, ['angles_ref#0', 'angles_ref#1', 'angles#0', 'angles#1'], ['pitch-1','roll-1','pitch-2','roll-2'], ['#1f77b4', '#2ca02c', '#000000','#ff0000'], [-0.5, 0.5]);
//dataSource.addSink(AnglesPlot);

const posXPlot = new LinePlot('posXPlot', 'sidebar', 500, 250, ['pos_ref#0', 'pos#0'], ['pos-1-x', 'pos-2-x'], ['#1f77b4', '#2ca02c'], [-1, 1]);
dataSource.addSink(posXPlot);

const posZPlot = new LinePlot('posZPlot', 'sidebar', 500, 250, ['pos_ref#1', 'pos#1'], ['pos-1-y', 'pos-2-y'], ['#1f77b4', '#2ca02c'], [-1, 1]);
dataSource.addSink(posZPlot);


