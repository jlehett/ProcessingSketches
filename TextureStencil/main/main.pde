
// Set up variables for texture images
String[] imageFiles = {
    "textures/tile.jpg",
    "textures/red.jpg",
    "textures/marble.jpg",
    "textures/gray.jpg"
};
PImage[] images;
// Set up variables for texture pgrahics objects
PGraphics[] g;

// Set up variables for texture stencils
PGraphics[] s;

// Set up variables for shaders
PShader textureStencil;

// Scene Parameters
int numTextures = 4;
int numStencils = 8;

float time = 0.0;

void setup() {
    // Make sure that the arguments to size are the same as WIDTH & HEIGHT
    size(1000, 1000, P2D);

    noSmooth();

    // Setup textures for shader
    loadTextures();

    // Setup texture stencils
    setupStencilObjects();

    // Load the shaders
    loadShaders();
}

void draw() {
    renderStencils();
    renderWhole();

    if (time <= 0.005*60.0*7.0) saveFrame("./output/######.png");
    else background(0);
}

void renderWhole() {
    // Activate the shader and render the scene
    shader(textureStencil);

    rect(0, 0, width, height);
}

void renderStencils() {
    time += 0.005;

    for (int i = 0; i < numStencils; i++) {
        float thisTime = time + 20.0 * i;

        s[i].beginDraw();
        s[i].background(255);
        s[i].fill(0);

        s[i].arc(width/2, height/2, 800.0-i*100.0, 800.0-i*100.0,
                noise(thisTime) * 10.0 - 5.0, 
                PI*3.0/2.0 + noise(thisTime) * 10.0 - 5.0);
        s[i].fill(255);
        s[i].ellipse(width/2, height/2, 800.0-i*100.0-100.0, 800.0-i*100.0-100.0);
        
        s[i].endDraw();
    }
}

void loadShaders() {
    // Load the texture stencil shader and set its uniforms
    textureStencil = loadShader("shaders/StencilFrag.glsl");

    for (int i=0; i < numTextures; i++) {
        String textureUniformName = "t" + str(i+1);
        textureStencil.set(textureUniformName, g[i]);
    }
    for (int i=0; i < numStencils; i++) {
        String stencilUniformName = "s" + str(i+1);
        textureStencil.set(stencilUniformName, s[i]);
    }

    textureStencil.set("resX", width);
    textureStencil.set("resY", height);
}

void loadTextures() {
    // Load the images into textures
    images = new PImage[numTextures];
    g = new PGraphics[numTextures];
    for (int i = 0; i < numTextures; i++) {
        println(imageFiles[i]);
        images[i] = loadImage(imageFiles[i]);
        g[i] = createGraphics(images[i].width, images[i].height, P2D);
        g[i].beginDraw();
        g[i].image(images[i], 0, 0);
        g[i].endDraw();
    }
}

void setupStencilObjects() {
    // Create PGraphics objects for each stencil
    s = new PGraphics[numStencils];
    for (int i = 0; i < numStencils; i++) {
        s[i] = createGraphics(width, height, P2D);
    }
}