class Bone {
    constructor(scene, options) {
        this.scene = scene;
        const defaults = {
            length: 4,
            diameter: 1,
            color: COLORS.C1,
            scale: 1.0,
            opacity: 1,
            zOffset:0,
        };
        options = {...defaults, ...options};

        this.length = options.length;
        this.diameter = options.diameter;
        this._anchor = [0,0,0];
        this._position = [0,0,0];
        this._orientation = [1,0,0,0];

        this.cyl = BABYLON.MeshBuilder.CreateCylinder("cylinder", {height: options.length, diameter: options.diameter}, this.scene);
        var mat = new BABYLON.StandardMaterial("greenMat", scene);
        var color = [0.8,0.8,0.8]
        mat.diffuseColor = new BABYLON.Color3(color[0],color[1],color[2]);
        this.cyl.material = mat;
        this.cyl.material.alpha = options.opacity;

        this.cyl.enableEdgesRendering();    
        this.cyl.edgesWidth = 4.0;
        this.cyl.edgesColor = new BABYLON.Color4(0, 0, 0, 1*options.opacity); 

        this.q_EImu2EB = new Quaternion(1, -1, 0, 0);

        this.orientation = Quaternion.fromAngleAxis(Math.PI/2,[1,0,1]);
        this.anchor = [-this.length/2,0,0];

        this.position = [0,0,10];

        

        this.testSphere = new Sphere(scene,0.2,[0.5,0,0],1);
        this.testSphere.setPosition([0,0,10]);
    }

    hide(){

    }

    show(){

    }

    set orientation(quat){
    	this._orientation = new Quaternion(quat);
    	this.cyl.rotationQuaternion = this.q_EImu2EB.multiply(this._orientation).babylon();
    	this.position = this._position;
    }

    set position(pos){
    	this._position = pos;

        var test =  this._orientation.rotate(this._anchor);

        var position_babylon = this.q_EImu2EB.rotate([this._position[0] - test[0],this._position[1] - test[1],this._position[2] - test[2]]);
        console.log(position_babylon);

        this.cyl.position.x = position_babylon[0];
        this.cyl.position.y = position_babylon[1];
        this.cyl.position.z = position_babylon[2];
    }

    get anchorGlob(){

    }

    set anchor(anch){
    	this._anchor = anch;
    }

    getGlobalPoint(point){

    }
}


class SegmentBox {
    constructor(scene, options) {
        this.scene = scene;
        const defaults = {
            dimX: 4,
            dimY: 1,
            dimZ: 1,
            color: COLORS.C1,
            scale: 1.0,
            opacity: 1,
            zOffset:0,
        };
        options = {...defaults, ...options};

        const x = options.dimX, y = options.dimY, z = options.dimZ;
        const boxOpts = {
            width: x*options.scale,
            height: z*options.scale,
            depth: y*options.scale,
        };
        const mat = new BABYLON.StandardMaterial('mat', scene);

        const faceColors = new Array(6);
        faceColors[0] = options.color; // front
        boxOpts.faceColors = faceColors;

        this.dimensions = [options.dimX,options.dimY,options.dimZ];

        this.box = BABYLON.MeshBuilder.CreateBox('box', boxOpts, scene);
        this.box.material = mat;
        this.box.material.alpha = options.opacity;
        this.box.material.zOffset = options.zOffset;

        this.box.enableEdgesRendering();    
        this.box.edgesWidth = 4.0;
        this.box.edgesColor = new BABYLON.Color4(0, 0, 0, 1*options.opacity); 

        this.q_EImu2EB = new Quaternion(1, -1, 0, 0);

        this.anchor = [0,0,0];
        this.position = [0,0,0];
        this.orientation = new Quaternion(1,0,0,0);
        this.setOrientation([0.707,0,0.707,0]);
    }

    hide(){
        this.box.setEnabled(false);
    }

    show(){
        this.box.setEnabled(true);
    }

    setOrientation(quat){
        this.setQuat(quat);
        this.setPosition(this.position);
    }

    setQuat(quat) {
        //this.box.rotationQuaternion = this.q_EImu2EB.multiply(quat).multiply(this.q_Box2Imu).babylon();
        this.orientation = new Quaternion(quat);
        this.box.rotationQuaternion = this.q_EImu2EB.multiply(this.orientation).babylon();
    }

    setPosition(position){

        this.position = position;

        var test =  this.orientation.rotate(this.anchor);

        var position_babylon = this.q_EImu2EB.rotate([this.position[0] - test[0],this.position[1] - test[1],this.position[2] - test[2]]);

        this.box.position.x = position_babylon[0];
        this.box.position.y = position_babylon[1];
        this.box.position.z = position_babylon[2];
    }

    getAnchorGlob(){
        var anchorpos = this.getGlobalPoint([0,0,0]);
        return anchorpos;
    }

    setAnchor(anchor){
        this.anchor = anchor;
    }

    getDimensions(){
        return this.dimensions;
    }

    getGlobalPoint(point){
        var test = this.orientation.rotate(point);    
        return [this.position[0] + test[0],this.position[1] + test[1],this.position[2] + test[2]]; // + 
    }


    setAxis(axis) {
        if (this.axis === undefined) {
            this.axis = BABYLON.MeshBuilder.CreateCylinder("axis", {height: 7, diameter: 0.1}, this.scene);
            this.axis.parent = this.box;
        }

        // default orientation is in z direction
        const angle = Math.acos(axis[2]); // dot([0 0 1], j)
        const rotAxis = [-axis[1], axis[0], 0]; // cross([0 0 1], j)
        const qAxis = Quaternion.fromAngleAxis(angle, rotAxis);
        // this.axis.rotationQuaternion = CONFIG.q_Imu2Box.conjugate().multiply(qAxis).multiply(CONFIG.q_Imu2Box);
        this.axis.rotationQuaternion = this.q_Box2Imu.multiply(qAxis).multiply(this.q_Box2Imu.conj());
    }

    setColor(color){

    }
}

class Finger{
    constructor(scene,options){ //segmentLengths){

        const defaults = {
            segmentLengths: [4,3,3],
            colors: [[0,1,0],[0,0,1],[1,0,0]],
            opacity: 1,
            opacity_segments: [1,1,1],
            zOffset:0,
        };

        options = {...defaults, ...options};

        this.position = [0,0,0];

        this.proxSettings = {
            dimX: options.segmentLengths[0],
            dimY: 1,
            dimZ: 1,
            color: new BABYLON.Color3(options.colors[0][0],options.colors[0][1],options.colors[0][2]),
            scale: 1.0,
            opacity: options.opacity*options.opacity_segments[0],
            zOffset: options.zOffset,
        };
        this.prox = new SegmentBox(scene,this.proxSettings);
        this.prox.setAnchor([-this.proxSettings.dimX/2 - this.proxSettings.dimY/2,0,0]);
        this.prox.setPosition(this.position);

        
        this.middSettings = {
            dimX: options.segmentLengths[1],
            dimY: 1,
            dimZ: 1,
            color: new BABYLON.Color3(options.colors[1][0],options.colors[1][1],options.colors[1][2]),
            scale: 1.0,
            opacity: options.opacity*options.opacity_segments[1],
            zOffset: options.zOffset,
        };
        this.midd = new SegmentBox(scene,this.middSettings);
        this.midd.setAnchor([-this.middSettings.dimX/2 - this.middSettings.dimY/2,0,0]);
        this.midd.setPosition(this.prox.getGlobalPoint([this.proxSettings.dimX + 1 + this.middSettings.dimY/2,0,0]));

        this.distSettings = {
            dimX: options.segmentLengths[2],
            dimY: 1,
            dimZ: 1,
            color: new BABYLON.Color3(options.colors[2][0],options.colors[2][1],options.colors[2][2]),
            scale: 1.0,
            opacity: options.opacity*options.opacity_segments[2],
            zOffset: options.zOffset,
        };
        this.dist = new SegmentBox(scene,this.distSettings);
        this.dist.setAnchor([-this.distSettings.dimX/2 - this.distSettings.dimY/2,0,0]);
        this.dist.setPosition(this.midd.getGlobalPoint([this.middSettings.dimX + 1 + this.distSettings.dimY/2,0,0]));

        this.MCP = new Sphere(scene,this.proxSettings.dimY,[1,1,1],options.opacity*options.opacity_segments[0]);
        this.MCP.setPosition(this.prox.getGlobalPoint([-this.proxSettings.dimY,0,0]));

        this.PIP = new Sphere(scene,this.proxSettings.dimY,[1,1,1],options.opacity*options.opacity_segments[1]);
        this.PIP.setPosition(this.prox.getGlobalPoint([this.proxSettings.dimX + this.proxSettings.dimY,0,0]));

        this.DIP = new Sphere(scene,this.proxSettings.dimY,[1,1,1],options.opacity*options.opacity_segments[2]);
        this.DIP.setPosition(this.midd.getGlobalPoint([this.middSettings.dimX + this.middSettings.dimY,0,0]));
    }

    setPosition(position){
        this.position = position;
        this.prox.setPosition(position);
        this.midd.setPosition(this.prox.getGlobalPoint([this.proxSettings.dimX + 1,0,0]));
        this.dist.setPosition(this.midd.getGlobalPoint([this.middSettings.dimX + 1,0,0]));

        this.MCP.setPosition(this.prox.getGlobalPoint([0,0,0]));
        this.PIP.setPosition(this.prox.getGlobalPoint([this.proxSettings.dimX + this.proxSettings.dimY,0,0]));
        this.DIP.setPosition(this.midd.getGlobalPoint([this.middSettings.dimX + this.middSettings.dimY,0,0]));
    }


    setOrientations(q_prox,q_midd,q_dist){
        this.prox.setOrientation(q_prox);
        this.midd.setOrientation(q_midd);
        this.dist.setOrientation(q_dist);
        this.setPosition(this.position);
    }

    hide(){
        this.prox.hide();
        this.midd.hide();
        this.dist.hide();
        this.MCP.hide();
        this.PIP.hide();
        this.DIP.hide();
    }

    show(){
        this.prox.show();
        this.midd.show();
        this.dist.show();
        this.MCP.show();
        this.PIP.show();
        this.DIP.show();
    }
} 

class BoxHand{
    
		constructor(scene,options){

        const defaults = {
            opacity: 1,
            //opacity_f1: [1,1,1],
            opacity_f2: [1,1,1],
            opacity_f3: [1,1,1],
            opacity_f4: [1,1,1],
            opacity_f5: [1,1,1],

            //colors_f1: [[0,1,0],[0,0,1],[1,0,0]],
            colors_f2: [[0,1,0],[0,0,1],[1,0,0]],
            colors_f3: [[0,1,0],[0,0,1],[1,0,0]],
            colors_f4: [[0,1,0],[0,0,1],[1,0,0]],
            colors_f5: [[0,1,0],[0,0,1],[1,0,0]],
            zOffset: 0,
        };




        options = {...defaults, ...options};

        this.corners = [ 
        new BABYLON.Vector2(1.5, 0),
        new BABYLON.Vector2(5.5, 0),
        new BABYLON.Vector2(5.5,2),
        new BABYLON.Vector2(1.5,2)
        ];


        this.poly_tri = new BABYLON.PolygonMeshBuilder("polytri", this.corners, scene);
        this.polygon = this.poly_tri.build(null, 1);

        var greenMat = new BABYLON.StandardMaterial("greenMat", scene);
        greenMat.diffuseColor = new BABYLON.Color3(238/255,207/255,180/255);
        this.polygon.material = greenMat;
        this.polygon.material.alpha = options.opacity;
        this.polygon.enableEdgesRendering();    
        this.polygon.edgesWidth = 4.0;
        this.polygon.edgesColor = new BABYLON.Color4(0, 0, 0, 1*options.opacity); 
        //########### CREATE LABELS #############
    

var outputplane1 = BABYLON.Mesh.CreatePlane("outputplane", 30, scene, false);
				outputplane1.billboardMode = BABYLON.AbstractMesh.BILLBOARDMODE_ALL;
				outputplane1.material = new BABYLON.StandardMaterial("outputplane", scene);
				outputplane1.position = new BABYLON.Vector3(0, 17, 5);
				outputplane1.scaling.y = 0.15;
				outputplane1.scaling.x = 0.3;
				outputplane1.rotate(new BABYLON.Vector3(0, 0, 1), 1 * Math.PI , BABYLON.Space.LOCAL);
				
				var outputplaneTexture1 = new BABYLON.DynamicTexture("dynamic texture", 900, scene);
				outputplane1.material.diffuseTexture = outputplaneTexture1;
				outputplane1.material.specularColor = new BABYLON.Color3(0, 0, 0);
				outputplane1.material.emissiveColor = new BABYLON.Color3(1, 1, 1);
				outputplane1.material.backFaceCulling = false;
				outputplaneTexture1.drawText("realtime", null, 450,"140px verdana", "black", "white",false,true);
    
        this.q_Build = new Quaternion(0.5,0.5,0.5,0.5);
        this.q_EImu2EB = new Quaternion(1, -1, 0, 0);
        //this.q_Build = new Quaternion(1,0,0,0);
        //this.q_EImu2EB = new Quaternion(1, 0, 0, 0);
        this.q_SB = new Quaternion(1,0,0,0);//new Quaternion(0.707,0,0,0.707);
        this.q_RL = new Quaternion(1,0,0,0);//new Quaternion(0,0,1,0);
        
        this.q_RR = new Quaternion(1,0,0,0);
        //this.q_legs = new Quaternion(0.5,0.5,0,0)
        //this.q_f =
        
        this.position = [0,0,0];
        this.anchor = [0,3.5,-0.5];
        this.orientation = new Quaternion(1,0,0,0);

        //this.anchor_F2 = [8.5,-3,0];
        this.anchor_F3 = [2.5,-1.5,0];
        this.anchor_F4 = [2.5,1.5,0];
        //this.anchor_F5 = [8.5,3,0];

        //this.F2 = new Finger(scene,{segmentLengths: [2.3,1.6,1.2],opacity: options.opacity, opacity_segments: options.opacity_f2, colors: options.colors_f2,zOffset: options.zOffset});
        this.F3 = new Finger(scene,{segmentLengths:[2.8,1.8,1.2],opacity: options.opacity,opacity_segments: options.opacity_f3,colors: options.colors_f3,zOffset: options.zOffset});
        this.F4 = new Finger(scene,{segmentLengths:[2.8,1.8,1.2],opacity: options.opacity,opacity_segments: options.opacity_f4,colors: options.colors_f4,zOffset: options.zOffset});
        //this.F5 = new Finger(scene,{segmentLengths:[1.6,1.1,0.9],opacity: options.opacity,opacity_segments: options.opacity_f5,colors: options.colors_f5,zOffset: options.zOffset});

        this.setOrientation(this.orientation);
        this.setPosition(this.position);            
    }

    setPosition(position){
        this.position = position;

        var test =  this.orientation.rotate(this.anchor);

        var position_babylon = this.q_EImu2EB.rotate([this.position[0] - test[0],this.position[1] - test[1],this.position[2] - test[2]]);

        this.polygon.position.x = position_babylon[0];
        this.polygon.position.y = position_babylon[1];
        this.polygon.position.z = position_babylon[2];

        //this.F2.setPosition(this.getAnchorF2());
        this.F3.setPosition(this.getAnchorF3());
        this.F4.setPosition(this.getAnchorF4());
        //this.F5.setPosition(this.getAnchorF5());

    }
   
    setOrientation(quat){
        this.orientation = new Quaternion(quat);

        this.polygon.rotationQuaternion = this.q_EImu2EB.multiply(this.orientation).multiply(this.q_Build).babylon();
        this.setPosition(this.position);
    }

    hide(){
        //this.F2.hide();
        this.F3.hide();
        this.F4.hide();
        //this.F5.hide();
        this.polygon.setEnabled(false);
    }

    show(){
        //this.F2.show();
        this.F3.show();
        this.F4.show();
        //this.F5.show();
        this.polygon.setEnabled(true);
    }

    setColors(colors){

    }

    getGlobalPoint(point){
      var test = this.orientation.rotate(point);    
                    return [this.position[0] + test[0],this.position[1] + test[1],this.position[2] + test[2]]; // +  
                }

                getAnchorGlob(){
                    var anchorpos = this.getGlobalPoint([0,0,0]);
                    return anchorpos; 
                }

            
                getAnchorF3(){
                    return this.getGlobalPoint(this.anchor_F3);
                }

                getAnchorF4(){
                    return this.getGlobalPoint(this.anchor_F4);
                }
            

    addSample_JSON(sample,mode){
                    

   if(mode == 0){ // 6D + KC
                    this.q_EE = new Quaternion(1,0,0,0);
                    var q_hb = new Quaternion(sample.hip);
                    this.setOrientation(this.q_EE.multiply(q_hb));
                    this.F4.setOrientations(this.q_EE.multiply(new Quaternion(sample.thigh_right_deltaFilt_rt_corrected)),this.q_EE.multiply(new Quaternion(sample.shank_right_deltaFilt_rt_corrected)),this.q_EE.multiply(new Quaternion(sample.foot_right_deltaFilt_rt_corrected))); //TODO
                    this.F3.setOrientations(this.q_EE.multiply(new Quaternion(sample.thigh_left_deltaFilt_rt_corrected)),this.q_EE.multiply(new Quaternion(sample.shank_left_deltaFilt_rt_corrected)),this.q_EE.multiply(new Quaternion(sample.foot_left_deltaFilt_rt_corrected)));
             }

}
	
    
  
	
 
}


class BoxHand3{
    
		constructor(scene,options){

        const defaults = {
            opacity: 1,
            //opacity_f1: [1,1,1],
            opacity_f2: [1,1,1],
            opacity_f3: [1,1,1],
            opacity_f4: [1,1,1],
            opacity_f5: [1,1,1],

            //colors_f1: [[0,1,0],[0,0,1],[1,0,0]],
            colors_f2: [[0,1,0],[0,0,1],[1,0,0]],
            colors_f3: [[0,1,0],[0,0,1],[1,0,0]],
            colors_f4: [[0,1,0],[0,0,1],[1,0,0]],
            colors_f5: [[0,1,0],[0,0,1],[1,0,0]],
            zOffset: 0,
        };




        options = {...defaults, ...options};

        this.corners = [ 
        new BABYLON.Vector2(1.5, 0),
        new BABYLON.Vector2(5.5, 0),
        new BABYLON.Vector2(5.5,2),
        new BABYLON.Vector2(1.5,2)
        ];


        this.poly_tri = new BABYLON.PolygonMeshBuilder("polytri", this.corners, scene);
        this.polygon = this.poly_tri.build(null, 1);

        var greenMat = new BABYLON.StandardMaterial("greenMat", scene);
        greenMat.diffuseColor = new BABYLON.Color3(238/255,207/255,180/255);
        this.polygon.material = greenMat;
        this.polygon.material.alpha = options.opacity;
        this.polygon.enableEdgesRendering();    
        this.polygon.edgesWidth = 4.0;
        this.polygon.edgesColor = new BABYLON.Color4(0, 0, 0, 1*options.opacity); 
				

        var outputplane = BABYLON.Mesh.CreatePlane("outputplane", 30, scene, false);
        outputplane.billboardMode = BABYLON.AbstractMesh.BILLBOARDMODE_ALL;
        outputplane.material = new BABYLON.StandardMaterial("outputplane", scene);
        outputplane.position = new BABYLON.Vector3(0, 17, -15);
        outputplane.scaling.y = 0.15;
      outputplane.scaling.x = 0.3;
      outputplane.rotate(new BABYLON.Vector3(0, 0, 1), 1 * Math.PI , BABYLON.Space.LOCAL);
        
        var outputplaneTexture = new BABYLON.DynamicTexture("dynamic texture", 900, scene);
        outputplane.material.diffuseTexture = outputplaneTexture;
        outputplane.material.specularColor = new BABYLON.Color3(0, 0, 0);
        outputplane.material.emissiveColor = new BABYLON.Color3(1, 1, 1);
        outputplane.material.backFaceCulling = false;

        outputplaneTexture.drawText("6D result", null, 450,"140px verdana", "black", "white",false,true);
				

        this.q_Build = new Quaternion(0.5,0.5,0.5,0.5);
        this.q_EImu2EB = new Quaternion(1, -1, 0, 0);
        //this.q_Build = new Quaternion(1,0,0,0);
        //this.q_EImu2EB = new Quaternion(1, 0, 0, 0);
        this.q_SB = new Quaternion(1,0,0,0);//new Quaternion(0.707,0,0,0.707);
        this.q_RL = new Quaternion(1,0,0,0);//new Quaternion(0,0,1,0);
        
        this.q_RR = new Quaternion(1,0,0,0);
        //this.q_legs = new Quaternion(0.5,0.5,0,0)
        //this.q_f =

        
        this.position = [0,0,0];
        this.anchor = [0,3.5,-0.5];
        this.orientation = new Quaternion(1,0,0,0);

        //this.anchor_F2 = [8.5,-3,0];

        this.anchor_F3 = [2.5,-1.5,0];

        this.anchor_F4 = [2.5,1.5,0];

        //this.anchor_F5 = [8.5,3,0];



        //this.F2 = new Finger(scene,{segmentLengths: [2.3,1.6,1.2],opacity: options.opacity, opacity_segments: options.opacity_f2, colors: options.colors_f2,zOffset: options.zOffset});

        this.F3 = new Finger(scene,{segmentLengths:[2.8,1.8,1.2],opacity: options.opacity,opacity_segments: options.opacity_f3,colors: options.colors_f3,zOffset: options.zOffset});

        this.F4 = new Finger(scene,{segmentLengths:[2.8,1.8,1.2],opacity: options.opacity,opacity_segments: options.opacity_f4,colors: options.colors_f4,zOffset: options.zOffset});

        //this.F5 = new Finger(scene,{segmentLengths:[1.6,1.1,0.9],opacity: options.opacity,opacity_segments: options.opacity_f5,colors: options.colors_f5,zOffset: options.zOffset});



        this.setOrientation(this.orientation);

        this.setPosition(this.position);            

    }

    setPosition(position){
        this.position = position;

        var test =  this.orientation.rotate(this.anchor);


        var position_babylon = this.q_EImu2EB.rotate([this.position[0] - test[0],this.position[1] - test[1],this.position[2] - test[2]]);



        this.polygon.position.x = position_babylon[0];
        this.polygon.position.y = position_babylon[1];
        this.polygon.position.z = position_babylon[2];

        //this.F2.setPosition(this.getAnchorF2());
        this.F3.setPosition(this.getAnchorF3());
        this.F4.setPosition(this.getAnchorF4());
        //this.F5.setPosition(this.getAnchorF5());

    }

    setOrientation(quat){
        this.orientation = new Quaternion(quat);

        this.polygon.rotationQuaternion = this.q_EImu2EB.multiply(this.orientation).multiply(this.q_Build).babylon();

        this.setPosition(this.position);
    }

    hide(){
        //this.F2.hide();
        this.F3.hide();
        this.F4.hide();
        //this.F5.hide();
        this.polygon.setEnabled(false);
    }

    show(){
        //this.F2.show();
        this.F3.show();
        this.F4.show();
        //this.F5.show();
        this.polygon.setEnabled(true);
    }

    setColors(colors){

    }

    getGlobalPoint(point){
      var test = this.orientation.rotate(point);    
                    return [this.position[0] + test[0],this.position[1] + test[1],this.position[2] + test[2]]; // +  
                }

                getAnchorGlob(){
                    var anchorpos = this.getGlobalPoint([0,0,0]);
                    return anchorpos; 
                }

            
                getAnchorF3(){
                    return this.getGlobalPoint(this.anchor_F3);
                }

                getAnchorF4(){
                    return this.getGlobalPoint(this.anchor_F4);
                }
            

    addSample_JSON(sample,mode){

                    

    if(mode == 0){ // 6D + KC
                    
                    var q_hb = new Quaternion(sample.hip);
                    this.setOrientation(q_hb);

                    this.F4.setOrientations(new Quaternion(sample.thigh_right),new Quaternion(sample.shank_right),new Quaternion(sample.foot_right)); //TODO
                    this.F3.setOrientations(new Quaternion(sample.thigh_left),new Quaternion(sample.shank_left),new Quaternion(sample.foot_left));
                } 
}
	
    
  
	
 
}





class Sphere{
    constructor(scene,diameter,color,opacity){

        this.sphere = BABYLON.MeshBuilder.CreateSphere("sphere", {diameterX: diameter, diameterY: diameter, diameterZ: diameter}, scene);
        var greenMat = new BABYLON.StandardMaterial("greenMat", scene);
        greenMat.diffuseColor = new BABYLON.Color3(color[0],color[1],color[2]);
        this.sphere.material = greenMat;
        this.sphere.material.alpha = opacity;

        this.q_EImu2EB = new Quaternion(1, -1, 0, 0);
    }

    setPosition(position){

        var position_babylon = this.q_EImu2EB.rotate(position);

        this.sphere.position.x = position_babylon[0];
        this.sphere.position.y = position_babylon[1];
        this.sphere.position.z = position_babylon[2]; 
    }

    hide(){
        this.sphere.setEnabled(false);
    }
    show(){
        this.sphere.setEnabled(true);
    }
}




