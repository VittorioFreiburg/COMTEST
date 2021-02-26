

class onScreenGUI{
    constructor(){
        this.advancedTexture = BABYLON.GUI.AdvancedDynamicTexture.CreateFullscreenUI("UI");
    }

    addTextControl(posX,posY){
        return new GUI_text(this,posX,posY);
    }
}


class GUI_Text{
    constructor(onScreenGUI,posX,posY){
        this.control = new BABYLON.GUI.TextBlock();
        this.control.text = "Hello world";
        this.control.color = "white";
        this.control.fontSize = 24;
        this.control.left = posX;
        this.control.top = posY;
        advancedTexture.addControl(text1); 
    }

    setText(text){
        this.control.text = text;
    }
}





class VideoPanel extends Container {
    constructor(container, options) {
        const defaults = {
            id: '',
            content: '',
            spacing: '10px',
        };
        options = {...defaults, ...options};
        super(container, options);

        this.data = $('<video>', {id:'player', width: '100%'});
        this.data.attr('controls',true);
        this.data.attr('autobuffer','auto');
        this.data.attr('preload',true);

        this.source = $('<source>', {src:'./video.mp4', type: 'video/mp4'});

        this.data.append(this.source);
        this.player = this.data[0];

        insertDOM(container, this.data);       

    }

    getVideoTime(){
        return this.player.currentTime;
    }

    setVideoTime(time){
        this.player.currentTime = time;
    }
    play(){
        this.player.play();
    }
    pause(){
        this.player.pause();
    }
}

class TiledGround{
    constructor(scene,color1,color2){
        var grid = {
            'h' : 16,
            'w' : 16
        };

        this.tiledGround = new BABYLON.MeshBuilder.CreateTiledGround("Tiled Ground", {xmin: -30, zmin: -30, xmax: 30, zmax: 30, subdivisions: grid}, scene);

    //Create the multi material
    // Create differents materials
    this.whiteMaterial = new BABYLON.StandardMaterial("White", scene);
    this.whiteMaterial.diffuseColor = new BABYLON.Color3(color1[0],color1[1],color1[2]);
    this.whiteMaterial.specularColor = new BABYLON.Color3(0, 0, 0);

    this.blackMaterial = new BABYLON.StandardMaterial("White", scene);
    this.blackMaterial.diffuseColor = new BABYLON.Color3(color2[0],color2[1],color2[2]);
    this.blackMaterial.specularColor = new BABYLON.Color3(0, 0, 0);

    // Create Multi Material
    this.multimat = new BABYLON.MultiMaterial("multi", scene);
    this.multimat.subMaterials.push(this.whiteMaterial);
    this.multimat.subMaterials.push(this.blackMaterial);
    

    // Apply the multi material
    // Define multimat as material of the tiled ground
    this.tiledGround.material = this.multimat;

    // Needed variables to set subMeshes
    this.verticesCount = this.tiledGround.getTotalVertices();
    this.tileIndicesLength = this.tiledGround.getIndices().length / (grid.w * grid.h);
    
    // Set subMeshes of the tiled ground
    this.tiledGround.subMeshes = [];
    var base = 0;
    for (var row = 0; row < grid.h; row++) {
        for (var col = 0; col < grid.w; col++) {
            this.tiledGround.subMeshes.push(new BABYLON.SubMesh(row%2 ^ col%2, 0, this.verticesCount, base , this.tileIndicesLength, this.tiledGround));
            base += this.tileIndicesLength;
        }
    }
}
}
